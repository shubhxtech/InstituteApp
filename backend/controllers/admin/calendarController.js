const asyncHandler = require('express-async-handler');
const CalendarEvent = require('../../models/CalendarEvent');

// @desc    Get all calendar events
// @route   GET /api/admin/events
// @access  Admin
const getAllEvents = asyncHandler(async (req, res) => {
    const events = await CalendarEvent.find().sort({ startDate: 1 });
    res.status(200).json(events);
});

// @desc    Create calendar event
// @route   POST /api/admin/events
// @access  Admin
const createEvent = asyncHandler(async (req, res) => {
    const { title, startDate, endDate, isAllDay, color, category } = req.body;

    if (!title || !startDate || !endDate) {
        res.status(400);
        throw new Error('Please add title, start date, and end date');
    }

    const event = await CalendarEvent.create({
        title,
        startDate,
        endDate,
        isAllDay,
        color,
        category,
        updatedBy: req.user._id,
    });

    res.status(201).json(event);
});

// @desc    Update calendar event
// @route   PUT /api/admin/events/:id
// @access  Admin
const updateEvent = asyncHandler(async (req, res) => {
    const event = await CalendarEvent.findById(req.params.id);

    if (!event) {
        res.status(404);
        throw new Error('Event not found');
    }

    const updated = await CalendarEvent.findByIdAndUpdate(
        req.params.id,
        { ...req.body, updatedBy: req.user._id },
        { new: true }
    );

    res.status(200).json(updated);
});

// @desc    Delete calendar event
// @route   DELETE /api/admin/events/:id
// @access  Admin
const deleteEvent = asyncHandler(async (req, res) => {
    const event = await CalendarEvent.findById(req.params.id);

    if (!event) {
        res.status(404);
        throw new Error('Event not found');
    }

    await event.deleteOne();
    res.status(200).json({ id: req.params.id });
});

module.exports = {
    getAllEvents,
    createEvent,
    updateEvent,
    deleteEvent,
};
