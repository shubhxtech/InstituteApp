const express = require('express');
const router = express.Router();
const {
    registerUser,
    loginUser,
    getMe,
    checkEmail,
    updateProfile,
    updatePassword,
    sendOtp,
} = require('../controllers/authController');
const { protect } = require('../middleware/authMiddleware');

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/check-email', checkEmail);
router.post('/send-otp', sendOtp);
router.put('/profile', protect, updateProfile);
router.put('/password', updatePassword);
router.get('/me', protect, getMe);

module.exports = router;
