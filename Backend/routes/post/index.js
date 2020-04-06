const express = require("express");

const { verifyUserWithToken } = require("../auth/helper")

const {
    createPost,
    getPostById,
    updatePost,
    deletePost,
    getPostsByUserId,
    getLikedPostsByUserId,
    addLike,
    removeLike
} = require("./functions");

// instance of new router
const router = express.Router();

// All ruotes to post goes here
// Creating new Post
router.post(
    "post/create",
    verifyUserWithToken,
    createPost
);
// Get Post
router.get(
    "/post",
    getPostById
);
// Update Post
router.post(
    "/post/update",
    verifyUserWithToken,
    updatePost
);
// Delete Post
router.post(
    "/post/delete",
    verifyUserWithToken,
    deletePost
);


// get posts of a user by id
router.get(
    "/user/posts",
    verifyUserWithToken,
    getPostsByUserId
)
// get liked posts of a user by id
router.get(
    "/user/posts_liked",
    verifyUserWithToken,
    getLikedPostsByUserId
)


// Add Like
router.post(
    "/post/like",
    verifyUserWithToken,
    addLike
)
// Remove Like
router.post(
    "/post/unlike",
    verifyUserWithToken,
    removeLike
)
