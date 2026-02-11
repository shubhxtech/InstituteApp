const express = require('express');
const router = express.Router();
const {
    getBuySellItems,
    createBuySellItem,
    updateBuySellItem,
    deleteBuySellItem,
} = require('../controllers/buySellController');
const { protect } = require('../middleware/authMiddleware');

router.route('/').get(getBuySellItems).post(protect, createBuySellItem);
router.route('/:id').put(protect, updateBuySellItem).delete(protect, deleteBuySellItem);

module.exports = router;
