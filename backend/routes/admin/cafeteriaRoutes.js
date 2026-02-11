const express = require('express');
const router = express.Router();
const {
    getAllCafeterias,
    createCafeteria,
    updateCafeteria,
    deleteCafeteria,
} = require('../../controllers/admin/cafeteriaController');
const { adminProtect } = require('../../middleware/adminMiddleware');

router.route('/').get(getAllCafeterias).post(adminProtect, createCafeteria);
router.route('/:id').put(adminProtect, updateCafeteria).delete(adminProtect, deleteCafeteria);

module.exports = router;
