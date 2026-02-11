const mongoose = require('mongoose');

const postSchema = mongoose.Schema(
    {
        title: {
            type: String,
            required: [true, 'Please add a title'],
        },
        description: {
            type: String,
            required: [true, 'Please add a description'],
        },
        images: {
            type: [String],
            default: [],
        },
        link: {
            type: String,
            default: '',
        },
        host: {
            type: String,
            required: [true, 'Please add a host'],
        },
        type: {
            type: String,
            required: [true, 'Please add a type'],
        },
        emailId: {
            type: String,
            required: [true, 'Please add an email ID'],
        },
    },
    {
        timestamps: true,
    }
);

module.exports = mongoose.model('Post', postSchema);
