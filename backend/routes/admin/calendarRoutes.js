const express = require('express');
const router = express.Router();
const {
    getAllEvents,
    createEvent,
    updateEvent,
    deleteEvent,
} = require('../../controllers/admin/calendarController');
const { adminProtect } = require('../../middleware/adminMiddleware');

router.route('/').get(getAllEvents).post(adminProtect, createEvent);
router.route('/:id').put(adminProtect, updateEvent).delete(adminProtect, deleteEvent);

module.exports = router;
