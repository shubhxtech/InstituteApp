const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const asyncHandler = require('express-async-handler');
const nodemailer = require('nodemailer');
const User = require('../models/User');

// @desc    Register new user
// @route   POST /api/auth/register
// @access  Public
const registerUser = asyncHandler(async (req, res) => {
    const { name, email, password, image } = req.body;

    if (!name || !email || !password) {
        res.status(400);
        throw new Error('Please add all fields');
    }

    // Check if user exists
    const userExists = await User.findOne({ email });

    if (userExists) {
        res.status(400);
        throw new Error('User already exists');
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user
    const user = await User.create({
        name,
        email,
        password: hashedPassword,
        image,
    });

    if (user) {
        res.status(201).json({
            _id: user.id,
            name: user.name,
            email: user.email,
            image: user.image,
            token: generateToken(user._id),
        });
    } else {
        res.status(400);
        throw new Error('Invalid user data');
    }
});

// @desc    Authenticate a user
// @route   POST /api/auth/login
// @access  Public
const loginUser = asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    console.log(`[LOGIN ATTEMPT] Email: ${email}`);

    // Check for user email
    const user = await User.findOne({ email });

    if (!user) {
        console.log(`[LOGIN FAILED] User not found: ${email}`);
        res.status(400);
        throw new Error('Invalid credentials');
    }

    console.log(`[LOGIN] User found: ${user.name}`);

    const passwordMatch = await bcrypt.compare(password, user.password);
    console.log(`[LOGIN] Password match: ${passwordMatch}`);

    if (passwordMatch) {
        console.log(`[LOGIN SUCCESS] User: ${email}`);
        res.json({
            _id: user.id,
            name: user.name,
            email: user.email,
            image: user.image,
            role: user.role,
            token: generateToken(user._id),
        });
    } else {
        console.log(`[LOGIN FAILED] Invalid password for: ${email}`);
        res.status(400);
        throw new Error('Invalid credentials');
    }
});

// @desc    Get user data
// @route   GET /api/auth/me
// @access  Private
const getMe = asyncHandler(async (req, res) => {
    res.status(200).json(req.user);
});

// @desc    Check if user exists
// @route   POST /api/auth/check-email
// @access  Public
const checkEmail = asyncHandler(async (req, res) => {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (user) {
        res.status(200).json({ exists: true });
    } else {
        res.status(200).json({ exists: false });
    }
});

// @desc    Update user profile
// @route   PUT /api/auth/profile
// @access  Private
const updateProfile = asyncHandler(async (req, res) => {
    const user = await User.findById(req.user._id);

    if (user) {
        user.name = req.body.name || user.name;
        user.email = req.body.email || user.email;
        user.image = req.body.image || user.image;
        if (req.body.password) {
            const salt = await bcrypt.genSalt(10);
            user.password = await bcrypt.hash(req.body.password, salt);
        }

        const updatedUser = await user.save();

        res.json({
            _id: updatedUser._id,
            name: updatedUser.name,
            email: updatedUser.email,
            image: updatedUser.image,
            token: generateToken(updatedUser._id),
        });
    } else {
        res.status(404);
        throw new Error('User not found');
    }
});

// @desc    Update password
// @route   PUT /api/auth/password
// @access  Public (Forgot Password flow) OR Private? 
// Current app uses email to identify user for password update.
// Assuming this is a "Forgot Password" or "Reset Password" flow where we trust the email/OTP verification done on client.
// Ideally should be authenticated or have a reset token. 
// For migration parity, we'll allow updating by email if it exists.
const updatePassword = asyncHandler(async (req, res) => {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (user) {
        // Hash new password
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(password, salt);
        await user.save();
        res.status(200).json({ message: 'Password updated successfully' });
    } else {
        res.status(404);
        throw new Error('User not found');
    }
});

// @desc    Send OTP email for signup verification
// @route   POST /api/auth/send-otp
// @access  Public
const sendOtp = asyncHandler(async (req, res) => {
    const { name, email, otp } = req.body;

    if (!email) {
        res.status(400);
        throw new Error('Email is required');
    }

    // Use provided OTP or generate 6-digit OTP
    const otpToSend = otp || Math.floor(100000 + Math.random() * 900000);

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.LEAD_EMAIL,
            pass: process.env.LEAD_PASSWORD,
        },
    });

    await transporter.sendMail({
        from: `"Vertex Team" <${process.env.LEAD_EMAIL}>`,
        to: email,
        subject: 'OTP for Sign Up on Vertex: IIT Mandi',
        text: `Dear ${name || 'User'},\nYour OTP for Sign Up on Vertex is ${otpToSend}.\n\nBest Regards,\nVertex Team\nIIT Mandi, Kamand 175005`,
    });

    res.status(200).json({ otp: otpToSend });
});

// Generate JWT
const generateToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: '30d',
    });
};

module.exports = {
    registerUser,
    loginUser,
    getMe,
    checkEmail,
    updateProfile,
    updatePassword,
    sendOtp,
};
