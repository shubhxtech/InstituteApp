const express = require('express');
const router = express.Router();
const {
    registerUser,
    loginUser,
    getMe,
    checkEmail,
    updateProfile,
    updatePassword,
} = require('../controllers/authController');
const { protect } = require('../middleware/authMiddleware');

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/check-email', checkEmail);
router.put('/profile', protect, updateProfile);
router.put('/password', updatePassword); // Consider securing this
router.get('/me', protect, getMe);

module.exports = router;
