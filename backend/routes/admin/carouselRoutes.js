const express = require('express');
const router = express.Router();
const {
    getAllCarouselImages,
    createCarouselImage,
    updateCarouselImage,
    reorderCarouselImages,
    deleteCarouselImage,
} = require('../../controllers/admin/carouselController');
const { adminProtect } = require('../../middleware/adminMiddleware');

router.route('/').get(getAllCarouselImages).post(adminProtect, createCarouselImage);
router.route('/reorder').put(adminProtect, reorderCarouselImages);
router.route('/:id').put(adminProtect, updateCarouselImage).delete(adminProtect, deleteCarouselImage);

module.exports = router;
