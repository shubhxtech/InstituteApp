const asyncHandler = require('express-async-handler');
const LostFoundItem = require('../models/LostFoundItem');

// @desc    Get all lost/found items
// @route   GET /api/lost-found
// @access  Public
const getLostFoundItems = asyncHandler(async (req, res) => {
    const items = await LostFoundItem.find().sort({ updatedAt: -1 });
    res.status(200).json(items);
});

// @desc    Create a lost/found item
// @route   POST /api/lost-found
// @access  Private
const createLostFoundItem = asyncHandler(async (req, res) => {
    const { name, description, images, lostOrFound, from, phoneNo } = req.body;

    if (!name || !description || !lostOrFound || !from || !phoneNo) {
        res.status(400);
        throw new Error('Please add all required fields');
    }

    const item = await LostFoundItem.create({
        name,
        description,
        images,
        lostOrFound,
        from,
        phoneNo,
    });

    res.status(201).json(item);
});

// @desc    Update a lost/found item
// @route   PUT /api/lost-found/:id
// @access  Private
const updateLostFoundItem = asyncHandler(async (req, res) => {
    const item = await LostFoundItem.findById(req.params.id);

    if (!item) {
        res.status(404);
        throw new Error('Item not found');
    }

    const updatedItem = await LostFoundItem.findByIdAndUpdate(
        req.params.id,
        req.body,
        { new: true }
    );

    res.status(200).json(updatedItem);
});

// @desc    Delete a lost/found item
// @route   DELETE /api/lost-found/:id
// @access  Private
const deleteLostFoundItem = asyncHandler(async (req, res) => {
    const item = await LostFoundItem.findById(req.params.id);

    if (!item) {
        res.status(404);
        throw new Error('Item not found');
    }

    await item.deleteOne();

    res.status(200).json({ id: req.params.id });
});

module.exports = {
    getLostFoundItems,
    createLostFoundItem,
    updateLostFoundItem,
    deleteLostFoundItem,
};
