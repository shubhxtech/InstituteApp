const mongoose = require('mongoose');

const cafeteriaSchema = mongoose.Schema(
    {
        name: {
            type: String,
            required: [true, 'Please add cafeteria name'],
        },
        location: {
            type: String,
            default: '',
        },
        time: {
            type: String,
            default: '',
        },
        contact: {
            type: String,
            default: '',
        },
        deliveryTime: {
            type: String,
            default: '',
        },
        images: {
            type: [String],
            default: [],
        },
        menu: {
            type: [String],
            default: [],
        },
        updatedBy: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
        },
    },
    {
        timestamps: true,
    }
);

module.exports = mongoose.model('Cafeteria', cafeteriaSchema);
