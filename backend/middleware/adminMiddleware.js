const jwt = require('jsonwebtoken');
const asyncHandler = require('express-async-handler');
const User = require('../models/User');

// Admin middleware - checks if user is authenticated AND has admin role
const adminProtect = asyncHandler(async (req, res, next) => {
    let token;

    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
        try {
            // Get token from header
            token = req.headers.authorization.split(' ')[1];

            // Verify token
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            // Get user from token
            req.user = await User.findById(decoded.id).select('-password');

            // Check if user has admin role
            if (!req.user || req.user.role !== 'admin') {
                res.status(403);
                throw new Error('Not authorized as admin');
            }

            next();
        } catch (error) {
            // Preserve status code if already set (e.g. 403), otherwise default to 401
            if (res.statusCode === 200) {
                res.status(401);
            }
            throw error;
        }
    } else {
        res.status(401);
        throw new Error('Not authorized, no token');
    }
});

module.exports = { adminProtect };

