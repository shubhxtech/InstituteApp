const mongoose = require('mongoose');

const jobSchema = mongoose.Schema(
    {
        name: {
            type: String,
            required: [true, 'Please add a name'],
        },
        description: {
            type: String,
            required: [true, 'Please add a description'],
        },
        location: {
            type: String,
            required: [true, 'Please add a location'],
        },
        image: {
            type: String,
            default: '',
        },
        stipend: {
            type: String,
            required: [true, 'Please add a stipend'],
        },
        duration: {
            type: String,
            required: [true, 'Please add a duration'],
        },
        type: {
            type: String, // e.g., Internship, Full-time
            required: [true, 'Please add a job type'],
        },
        company: {
            type: String,
            required: [true, 'Please add a company'],
        },
        links: {
            type: [String],
            default: [],
        },
        tags: {
            type: [String],
            default: [],
        },
        deadline: {
            type: Date,
            required: [true, 'Please add a deadline'],
        },
    },
    {
        timestamps: true,
    }
);

module.exports = mongoose.model('Job', jobSchema);
