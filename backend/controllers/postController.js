const asyncHandler = require('express-async-handler');
const Post = require('../models/Post');

// @desc    Get all posts
// @route   GET /api/posts
// @access  Public
const getPosts = asyncHandler(async (req, res) => {
    const posts = await Post.find().sort({ createdAt: -1 });
    res.status(200).json(posts);
});

// @desc    Create a post
// @route   POST /api/posts
// @access  Private (Admin/Host)
const createPost = asyncHandler(async (req, res) => {
    const { title, description, images, link, host, type, emailId } = req.body;

    if (!title || !description || !host || !type || !emailId) {
        res.status(400);
        throw new Error('Please add all required fields');
    }

    const post = await Post.create({
        title,
        description,
        images,
        link,
        host,
        type,
        emailId,
    });

    res.status(201).json(post);
});

// @desc    Update a post
// @route   PUT /api/posts/:id
// @access  Private
const updatePost = asyncHandler(async (req, res) => {
    const post = await Post.findById(req.params.id);

    if (!post) {
        res.status(404);
        throw new Error('Post not found');
    }

    const updatedPost = await Post.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
    });

    res.status(200).json(updatedPost);
});

// @desc    Delete a post
// @route   DELETE /api/posts/:id
// @access  Private
const deletePost = asyncHandler(async (req, res) => {
    const post = await Post.findById(req.params.id);

    if (!post) {
        res.status(404);
        throw new Error('Post not found');
    }

    await post.deleteOne();

    res.status(200).json({ id: req.params.id });
});

module.exports = {
    getPosts,
    createPost,
    updatePost,
    deletePost,
};
