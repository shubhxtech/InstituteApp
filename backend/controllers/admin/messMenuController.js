const asyncHandler = require('express-async-handler');
const MessMenu = require('../../models/MessMenu');

// @desc    Get all mess menus
// @route   GET /api/admin/mess-menu
// @access  Admin
const getAllMessMenus = asyncHandler(async (req, res) => {
    const menus = await MessMenu.find().sort({ day: 1 });
    res.status(200).json(menus);
});

// @desc    Update mess menu for a specific day
// @route   PUT /api/admin/mess-menu/:day
// @access  Admin
const updateMessMenu = asyncHandler(async (req, res) => {
    const { day } = req.params;
    const { meals } = req.body;

    const menu = await MessMenu.findOneAndUpdate(
        { day },
        { meals, updatedBy: req.user._id },
        { new: true, upsert: true }
    );

    res.status(200).json(menu);
});

// @desc    Bulk update all mess menus
// @route   POST /api/admin/mess-menu/bulk
// @access  Admin
const bulkUpdateMessMenus = asyncHandler(async (req, res) => {
    const { menus } = req.body; // Array of {day, meals}

    const promises = menus.map(menu =>
        MessMenu.findOneAndUpdate(
            { day: menu.day },
            { meals: menu.meals, updatedBy: req.user._id },
            { new: true, upsert: true }
        )
    );

    await Promise.all(promises);
    const allMenus = await MessMenu.find().sort({ day: 1 });

    res.status(200).json(allMenus);
});

module.exports = {
    getAllMessMenus,
    updateMessMenu,
    bulkUpdateMessMenus,
};
