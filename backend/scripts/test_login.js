const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const dotenv = require('dotenv');
const User = require('../models/User');

// Load env vars
dotenv.config({ path: __dirname + '/../.env' });

const connectDB = async () => {
    try {
        const conn = await mongoose.connect(process.env.MONGO_URI);
        console.log(`MongoDB Connected: ${conn.connection.host}`);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

const testLogin = async () => {
    await connectDB();

    const email = 'b23358@students.iitmandi.ac.in';
    const password = 'Shubh123';

    console.log(`Testing login for ${email} with password ${password}`);

    const user = await User.findOne({ email });

    if (!user) {
        console.log(`User with email ${email} not found.`);
        process.exit(1);
    }

    console.log(`User found: ${user.name}`);
    console.log(`Stored Hash: ${user.password}`);

    const isMatch = await bcrypt.compare(password, user.password);
    console.log(`Password Match Result: ${isMatch}`);

    process.exit(0);
};

testLogin();
