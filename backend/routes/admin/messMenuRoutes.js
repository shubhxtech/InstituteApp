const express = require('express');
const router = express.Router();
const {
    getAllMessMenus,
    updateMessMenu,
    bulkUpdateMessMenus,
} = require('../../controllers/admin/messMenuController');
const { adminProtect } = require('../../middleware/adminMiddleware');

router.route('/').get(getAllMessMenus);
router.route('/bulk').post(adminProtect, bulkUpdateMessMenus);
router.route('/:day').put(adminProtect, updateMessMenu);

module.exports = router;
