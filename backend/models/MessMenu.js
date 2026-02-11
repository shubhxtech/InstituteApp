const mongoose = require('mongoose');

const messMenuSchema = mongoose.Schema(
    {
        day: {
            type: String,
            required: true,
            enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
            unique: true,
        },
        meals: {
            breakfast: {
                type: [String],
                default: [],
            },
            lunch: {
                type: [String],
                default: [],
            },
            snacks: {
                type: [String],
                default: [],
            },
            dinner: {
                type: [String],
                default: [],
            },
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

module.exports = mongoose.model('MessMenu', messMenuSchema);
