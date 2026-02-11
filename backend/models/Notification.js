const mongoose = require('mongoose');

const notificationSchema = mongoose.Schema(
    {
        title: {
            type: String,
            required: [true, 'Please add a title'],
        },
        description: {
            type: String,
            required: [true, 'Please add a description'],
        },
        by: {
            type: String,
            required: [true, 'Please add sender info'],
        },
        image: {
            type: String,
            default: '',
        },
        type: {
            type: String, // e.g., 'info', 'alert'
            default: 'info',
        },
        read: {
            type: Boolean,
            default: false,
        },
        userId: {
            type: String,
            default: null,
        },
    },
    {
        timestamps: true,
    }
);

module.exports = mongoose.model('Notification', notificationSchema);
