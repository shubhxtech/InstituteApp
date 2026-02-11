const express = require('express');
const router = express.Router();
const { uploadFile } = require('../controllers/uploadController');
const { adminProtect } = require('../middleware/adminMiddleware');

router.post('/', adminProtect, uploadFile);

module.exports = router;
