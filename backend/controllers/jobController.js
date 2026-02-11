const asyncHandler = require('express-async-handler');
const Job = require('../models/Job');

// @desc    Get all jobs
// @route   GET /api/jobs
// @access  Public
const getJobs = asyncHandler(async (req, res) => {
    const jobs = await Job.find().sort({ deadline: 1 });
    res.status(200).json(jobs);
});

// @desc    Create a job
// @route   POST /api/jobs
// @access  Private (Admin only usually, but open for now based on app logic)
const createJob = asyncHandler(async (req, res) => {
    // Basic validation
    if (!req.body.name || !req.body.company) {
        res.status(400);
        throw new Error('Please add required fields');
    }
    const job = await Job.create(req.body);
    res.status(201).json(job);
});

module.exports = {
    getJobs,
    createJob,
};
