const mongoose = require('mongoose');

const buySellItemSchema = mongoose.Schema(
    {
        name: {
            type: String,
            required: [true, 'Please add a name'],
        },
        productDescription: {
            type: String,
            required: [true, 'Please add a description'],
        },
        productImage: {
            type: [String], // Array of image URLs
            default: [],
        },
        soldBy: {
            type: String, // Storing User Identifier (e.g. Email or ID)
            required: [true, 'Please add seller info'],
        },
        maxPrice: {
            type: String,
            required: [true, 'Please add max price'],
        },
        minPrice: {
            type: String,
            required: [true, 'Please add min price'],
        },
        phoneNo: {
            type: String,
            required: [true, 'Please add phone number'],
        },
    },
    {
        timestamps: true, // Automatically manages createdAt and updatedAt
    }
);

module.exports = mongoose.model('BuySellItem', buySellItemSchema);
