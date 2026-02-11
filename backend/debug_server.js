console.log('Debug script starting...');
try {
    const express = require('express');
    console.log('Express loaded');
    const mongoose = require('mongoose');
    console.log('Mongoose loaded');
    const cors = require('cors');
    console.log('Cors loaded');
    const dotenv = require('dotenv');
    console.log('Dotenv loaded');
    dotenv.config();

    const connectDB = require('./config/db');
    console.log('ConnectDB loaded');

    // Test loading routes
    console.log('Loading admin routes...');
    require('./routes/admin/messMenuRoutes');
    console.log('MessMenu routes loaded');
    require('./routes/admin/cafeteriaRoutes');
    console.log('Cafeteria routes loaded');
    require('./routes/admin/carouselRoutes');
    console.log('Carousel routes loaded');
    require('./routes/admin/contentRoutes');
    console.log('Content routes loaded');

    console.log('All dependencies loaded successfully.');

    // Test DB connection (optional)
    // connectDB().then(() => {
    //    console.log('DB Connected via debug script');
    //    process.exit(0);
    // }).catch(err => {
    //    console.error('DB Connection failed:', err);
    //    process.exit(1);
    // });

} catch (err) {
    console.error('CRASH DETECTED:', err);
    process.exit(1);
}
