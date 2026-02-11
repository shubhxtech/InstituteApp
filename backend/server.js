const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

console.log('Starting server...');
console.log('Environment:', process.env.NODE_ENV);
console.log('Port:', process.env.PORT);

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});

// Database Connection
const connectDB = require('./config/db');

// Wrap startup in async function to handle errors
const startServer = async () => {
    try {
        console.log('Connecting to database...');
        await connectDB();
        console.log('Database connected.');

        // Routes
        app.get('/', (req, res) => {
            res.send('API is running...');
        });

        app.use('/api/auth', require('./routes/authRoutes'));
        app.use('/api/buy-sell', require('./routes/buySellRoutes'));
        app.use('/api/lost-found', require('./routes/lostFoundRoutes'));
        app.use('/api/jobs', require('./routes/jobRoutes'));
        app.use('/api/posts', require('./routes/postRoutes'));
        app.use('/api/notifications', require('./routes/notificationRoutes'));

        const path = require('path');

        // Admin Routes
        app.use('/api/admin/mess-menu', require('./routes/admin/messMenuRoutes'));
        app.use('/api/admin/cafeteria', require('./routes/admin/cafeteriaRoutes'));
        app.use('/api/admin/carousel', require('./routes/admin/carouselRoutes'));
        app.use('/api/admin/events', require('./routes/admin/calendarRoutes'));
        app.use('/api/admin/content', require('./routes/admin/contentRoutes'));
        app.use('/api/upload', require('./routes/uploadRoutes'));

        // Serve static assets
        app.use('/uploads', express.static(path.join(__dirname, '/uploads')));

        // Start Server
        app.listen(PORT, () => {
            console.log(`Server running on port ${PORT}`);
        });
    } catch (error) {
        console.error('Failed to start server:', error);
        process.exit(1);
    }
};

startServer();
