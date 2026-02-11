const asyncHandler = require('express-async-handler');
const CarouselImage = require('../../models/CarouselImage');

// @desc    Get all carousel images
// @route   GET /api/admin/carousel
// @access  Admin
const getAllCarouselImages = asyncHandler(async (req, res) => {
    const images = await CarouselImage.find().sort({ order: 1 });
    res.status(200).json(images);
});

// @desc    Create carousel image
// @route   POST /api/admin/carousel
// @access  Admin
const createCarouselImage = asyncHandler(async (req, res) => {
    const { imageUrl, title, description, link, order, active } = req.body;

    if (!imageUrl) {
        res.status(400);
        throw new Error('Please add image URL');
    }

    const image = await CarouselImage.create({
        imageUrl,
        title,
        description,
        link,
        order,
        active,
        updatedBy: req.user._id,
    });

    res.status(201).json(image);
});

// @desc    Update carousel image
// @route   PUT /api/admin/carousel/:id
// @access  Admin
const updateCarouselImage = asyncHandler(async (req, res) => {
    const image = await CarouselImage.findById(req.params.id);

    if (!image) {
        res.status(404);
        throw new Error('Carousel image not found');
    }

    const updated = await CarouselImage.findByIdAndUpdate(
        req.params.id,
        { ...req.body, updatedBy: req.user._id },
        { new: true }
    );

    res.status(200).json(updated);
});

// @desc    Reorder carousel images
// @route   PUT /api/admin/carousel/reorder
// @access  Admin
const reorderCarouselImages = asyncHandler(async (req, res) => {
    const { images } = req.body; // Array of {id, order}

    const promises = images.map(img =>
        CarouselImage.findByIdAndUpdate(img.id, { order: img.order })
    );

    await Promise.all(promises);
    const allImages = await CarouselImage.find().sort({ order: 1 });

    res.status(200).json(allImages);
});

// @desc    Delete carousel image
// @route   DELETE /api/admin/carousel/:id
// @access  Admin
const deleteCarouselImage = asyncHandler(async (req, res) => {
    const image = await CarouselImage.findById(req.params.id);

    if (!image) {
        res.status(404);
        throw new Error('Carousel image not found');
    }

    await image.deleteOne();
    res.status(200).json({ id: req.params.id });
});

module.exports = {
    getAllCarouselImages,
    createCarouselImage,
    updateCarouselImage,
    reorderCarouselImages,
    deleteCarouselImage,
};
