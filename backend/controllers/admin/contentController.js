const asyncHandler = require('express-async-handler');
const BuySellItem = require('../../models/BuySellItem');
const LostFoundItem = require('../../models/LostFoundItem');
const Post = require('../../models/Post');
const Job = require('../../models/Job');
const Notification = require('../../models/Notification');

// @desc    Get all items with pagination and filters
// @route   GET /api/admin/content/:type
// @access  Admin
const getContent = asyncHandler(async (req, res) => {
    const { type } = req.params;
    const { page = 1, limit = 20, search = '' } = req.query;

    let Model;
    switch (type) {
        case 'buy-sell':
            Model = BuySellItem;
            break;
        case 'lost-found':
            Model = LostFoundItem;
            break;
        case 'posts':
            Model = Post;
            break;
        case 'jobs':
            Model = Job;
            break;
        case 'notifications':
            Model = Notification;
            break;
        default:
            res.status(400);
            throw new Error('Invalid content type');
    }

    const query = search
        ? { $or: [{ name: { $regex: search, $options: 'i' } }, { title: { $regex: search, $options: 'i' } }] }
        : {};

    const items = await Model.find(query)
        .limit(limit * 1)
        .skip((page - 1) * limit)
        .sort({ createdAt: -1 });

    const count = await Model.countDocuments(query);

    res.status(200).json({
        items,
        totalPages: Math.ceil(count / limit),
        currentPage: page,
        total: count,
    });
});

// @desc    Delete content item
// @route   DELETE /api/admin/content/:type/:id
// @access  Admin
const deleteContent = asyncHandler(async (req, res) => {
    const { type, id } = req.params;

    let Model;
    switch (type) {
        case 'buy-sell':
            Model = BuySellItem;
            break;
        case 'lost-found':
            Model = LostFoundItem;
            break;
        case 'posts':
            Model = Post;
            break;
        case 'jobs':
            Model = Job;
            break;
        case 'notifications':
            Model = Notification;
            break;
        default:
            res.status(400);
            throw new Error('Invalid content type');
    }

    const item = await Model.findById(id);

    if (!item) {
        res.status(404);
        throw new Error('Item not found');
    }

    await item.deleteOne();
    res.status(200).json({ id });
});

module.exports = {
    getContent,
    deleteContent,
};
