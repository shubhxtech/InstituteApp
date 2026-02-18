const express = require('express');
const router = express.Router();
const {
    getNotifications,
    createNotification,
} = require('../controllers/notificationController');
const { protect } = require('../middleware/authMiddleware');
const { adminProtect } = require('../middleware/adminMiddleware');

// GET is public — any user (or guest) can read notifications
// POST is admin-only — only admins can create/broadcast notifications
router.route('/').get(getNotifications).post(adminProtect, createNotification);

module.exports = router;
