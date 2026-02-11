const mongoose = require('mongoose');

const carouselImageSchema = mongoose.Schema(
    {
        imageUrl: {
            type: String,
            required: [true, 'Please add image URL'],
        },
        title: {
            type: String,
            default: '',
        },
        description: {
            type: String,
            default: '',
        },
        link: {
            type: String,
            default: '',
        },
        order: {
            type: Number,
            default: 0,
        },
        active: {
            type: Boolean,
            default: true,
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

module.exports = mongoose.model('CarouselImage', carouselImageSchema);
