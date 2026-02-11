const express = require('express');
const router = express.Router();
const {
    getNotifications,
    createNotification,
} = require('../controllers/notificationController');
const { protect } = require('../middleware/authMiddleware');

router.route('/').get(getNotifications).post(protect, createNotification);

module.exports = router;
