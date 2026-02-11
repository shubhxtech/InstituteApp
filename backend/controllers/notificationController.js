const asyncHandler = require('express-async-handler');
const Notification = require('../models/Notification');

// @desc    Get all notifications
// @route   GET /api/notifications
// @access  Public (or Private)
const getNotifications = asyncHandler(async (req, res) => {
    const notifications = await Notification.find().sort({ createdAt: -1 });
    res.status(200).json(notifications);
});

// @desc    Create a notification
// @route   POST /api/notifications
// @access  Private (Admin)
const createNotification = asyncHandler(async (req, res) => {
    const { title, description, by, image, type, userId } = req.body;

    if (!title || !description || !by) {
        res.status(400);
        throw new Error('Please add title, description and sender');
    }

    const notification = await Notification.create({
        title,
        description,
        by,
        image,
        type,
        userId,
    });

    res.status(201).json(notification);
});

module.exports = {
    getNotifications,
    createNotification,
};
