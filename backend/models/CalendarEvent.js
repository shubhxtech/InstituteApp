const mongoose = require('mongoose');

const calendarEventSchema = mongoose.Schema(
    {
        title: {
            type: String,
            required: [true, 'Please add event title'],
        },
        startDate: {
            type: Date,
            required: [true, 'Please add start date'],
        },
        endDate: {
            type: Date,
            required: [true, 'Please add end date'],
        },
        isAllDay: {
            type: Boolean,
            default: true,
        },
        color: {
            type: String,
            default: '#3283D5',
        },
        category: {
            type: String,
            enum: ['exam', 'holiday', 'event', 'deadline', 'break', 'other'],
            default: 'other',
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

module.exports = mongoose.model('CalendarEvent', calendarEventSchema);
