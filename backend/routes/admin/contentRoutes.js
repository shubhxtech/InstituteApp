const express = require('express');
const router = express.Router();
const {
    getContent,
    deleteContent,
} = require('../../controllers/admin/contentController');
const { adminProtect } = require('../../middleware/adminMiddleware');

router.route('/:type').get(adminProtect, getContent);
router.route('/:type/:id').delete(adminProtect, deleteContent);

module.exports = router;
