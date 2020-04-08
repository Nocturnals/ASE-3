const express = require("express");

const {
    verifyToken,
    verifyUserWithToken,
} = require("../auth/helper")
const { getPostDataWithHashtagsMentions } = require("./helper");

const {
    createPost,
    getPostById,
    updatePost,
    deletePost,
    getPostsByUserId,
    getPostsByUsername,
    getLikedPostsByUserId,
    getPostsByMentionedUser,
    generateGuestUserHomeFeed, 
    generateLoggedUserHomeFeed,
    addLike,
    removeLike,
    managePostHashtags
} = require("./functions");

// instance of new router
const router = express.Router();

// All ruotes to post goes here
// Creating new Post
router.post(
    "/create",
    verifyToken,
    verifyUserWithToken,
    getPostDataWithHashtagsMentions,
    createPost,
    managePostHashtags
);
// Get Post
// getting a single post by it;s id
router.get(
    "/",
    getPostById
);
// getting all posts of a user by id
router.get(
    "/user/id",
    verifyUserWithToken,
    getPostsByUserId
)
// getting all posts of a user by username
router.get(
    "/user/username",
    getPostsByUsername
)
// getting posts liked by a user
router.get(
    "/liked_posts",
    verifyUserWithToken,
    getLikedPostsByUserId,
)
// getting posts of a mentioned user
router.get(
    "/mentioned_user_posts",
    getPostsByMentionedUser
)
// Update Post
router.post(
    "/update",
    verifyUserWithToken,
    getPostDataWithHashtagsMentions,
    updatePost,
    managePostHashtags
);
// Delete Post
router.post(
    "/delete",
    verifyUserWithToken,
    deletePost
);


// Add Like
router.post(
    "/like",
    verifyUserWithToken,
    addLike
)
// Remove Like
router.post(
    "/unlike",
    verifyUserWithToken,
    removeLike
)

module.exports = router;