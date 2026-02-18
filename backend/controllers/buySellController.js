const asyncHandler = require('express-async-handler');
const BuySellItem = require('../models/BuySellItem');

// @desc    Get all buy/sell items
// @route   GET /api/buy-sell
// @access  Public (or Private based on needs)
const getBuySellItems = asyncHandler(async (req, res) => {
    const items = await BuySellItem.find().sort({ updatedAt: -1 });
    res.status(200).json(items);
});

// @desc    Create a buy/sell item
// @route   POST /api/buy-sell
// @access  Private
const createBuySellItem = asyncHandler(async (req, res) => {
    const {
        name,
        productDescription,
        productImage,
        soldBy,
        maxPrice,
        minPrice,
        phoneNo,
    } = req.body;

    if (!name || !productDescription || !soldBy || !maxPrice || !minPrice || !phoneNo) {
        res.status(400);
        throw new Error('Please add all required fields');
    }

    const item = await BuySellItem.create({
        name,
        productDescription,
        productImage,
        soldBy,
        maxPrice,
        minPrice,
        phoneNo,
    });

    res.status(201).json(item);
});

// @desc    Update a buy/sell item
// @route   PUT /api/buy-sell/:id
// @access  Private (only owner or admin)
const updateBuySellItem = asyncHandler(async (req, res) => {
    const item = await BuySellItem.findById(req.params.id);

    if (!item) {
        res.status(404);
        throw new Error('Item not found');
    }

    // Check ownership: only the seller or an admin can update
    if (item.soldBy !== req.user.email && req.user.role !== 'admin') {
        res.status(403);
        throw new Error('Not authorized to update this listing');
    }

    const updatedItem = await BuySellItem.findByIdAndUpdate(
        req.params.id,
        req.body,
        {
            new: true,
        }
    );

    res.status(200).json(updatedItem);
});

// @desc    Delete a buy/sell item
// @route   DELETE /api/buy-sell/:id
// @access  Private
const deleteBuySellItem = asyncHandler(async (req, res) => {
    const item = await BuySellItem.findById(req.params.id);

    if (!item) {
        res.status(404);
        throw new Error('Item not found');
    }

    // Check ownership: only the seller or an admin can delete
    if (item.soldBy !== req.user.email && req.user.role !== 'admin') {
        res.status(403);
        throw new Error('Not authorized to delete this listing');
    }

    await item.deleteOne();

    res.status(200).json({ id: req.params.id });
});

module.exports = {
    getBuySellItems,
    createBuySellItem,
    updateBuySellItem,
    deleteBuySellItem,
};
