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
    deleteAllPostsofLoggedUser,
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
    verifyToken,
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
    verifyToken,
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
    verifyToken,
    verifyUserWithToken,
    getPostDataWithHashtagsMentions,
    updatePost,
    managePostHashtags
);
// Delete Post
router.post(
    "/delete",
    verifyToken,
    verifyUserWithToken,
    deletePost,
    managePostHashtags,
);
router.post(
    "/delete/all",
    verifyToken,
    verifyUserWithToken,
    deleteAllPostsofLoggedUser
)


// Add Like
router.post(
    "/like",
    verifyToken,
    verifyUserWithToken,
    addLike
)
// Remove Like
router.post(
    "/unlike",
    verifyToken,
    verifyUserWithToken,
    removeLike
)

module.exports = router;