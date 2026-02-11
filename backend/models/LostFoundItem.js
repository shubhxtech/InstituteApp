const mongoose = require('mongoose');

const lostFoundItemSchema = mongoose.Schema(
    {
        name: {
            type: String,
            required: [true, 'Please add a name'],
        },
        description: {
            type: String,
            required: [true, 'Please add a description'],
        },
        images: {
            type: [String],
            default: [],
        },
        lostOrFound: {
            type: String,
            enum: ['Lost', 'Found'],
            required: [true, 'Please specify if lost or found'],
        },
        from: {
            type: String, // User identifier
            required: [true, 'Please add sender info'],
        },
        phoneNo: {
            type: String,
            required: [true, 'Please add phone number'],
        },
    },
    {
        timestamps: true,
    }
);

module.exports = mongoose.model('LostFoundItem', lostFoundItemSchema);
