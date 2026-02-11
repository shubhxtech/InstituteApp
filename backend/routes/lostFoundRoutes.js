const express = require('express');
const router = express.Router();
const {
    getLostFoundItems,
    createLostFoundItem,
    updateLostFoundItem,
    deleteLostFoundItem,
} = require('../controllers/lostFoundController');
const { protect } = require('../middleware/authMiddleware');

router.route('/').get(getLostFoundItems).post(protect, createLostFoundItem);
router.route('/:id').put(protect, updateLostFoundItem).delete(protect, deleteLostFoundItem);

module.exports = router;
