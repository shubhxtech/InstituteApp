const asyncHandler = require('express-async-handler');
const Cafeteria = require('../../models/Cafeteria');

// @desc    Get all cafeterias
// @route   GET /api/admin/cafeteria
// @access  Admin
const getAllCafeterias = asyncHandler(async (req, res) => {
    const cafeterias = await Cafeteria.find().sort({ name: 1 });
    res.status(200).json(cafeterias);
});

// @desc    Create cafeteria
// @route   POST /api/admin/cafeteria
// @access  Admin
const createCafeteria = asyncHandler(async (req, res) => {
    const { name, location, time, contact, deliveryTime, images, menu } = req.body;

    if (!name) {
        res.status(400);
        throw new Error('Please add cafeteria name');
    }

    const cafeteria = await Cafeteria.create({
        name,
        location,
        time,
        contact,
        deliveryTime,
        images,
        menu,
        updatedBy: req.user._id,
    });

    res.status(201).json(cafeteria);
});

// @desc    Update cafeteria
// @route   PUT /api/admin/cafeteria/:id
// @access  Admin
const updateCafeteria = asyncHandler(async (req, res) => {
    const cafeteria = await Cafeteria.findById(req.params.id);

    if (!cafeteria) {
        res.status(404);
        throw new Error('Cafeteria not found');
    }

    const updated = await Cafeteria.findByIdAndUpdate(
        req.params.id,
        { ...req.body, updatedBy: req.user._id },
        { new: true }
    );

    res.status(200).json(updated);
});

// @desc    Delete cafeteria
// @route   DELETE /api/admin/cafeteria/:id
// @access  Admin
const deleteCafeteria = asyncHandler(async (req, res) => {
    const cafeteria = await Cafeteria.findById(req.params.id);

    if (!cafeteria) {
        res.status(404);
        throw new Error('Cafeteria not found');
    }

    await cafeteria.deleteOne();
    res.status(200).json({ id: req.params.id });
});

module.exports = {
    getAllCafeterias,
    createCafeteria,
    updateCafeteria,
    deleteCafeteria,
};
