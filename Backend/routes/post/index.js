const express = require("express");

const {
    verifyUserWithToken,
    getUserById,
    getUserByUsername,
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
    "post/create",
    verifyUserWithToken,
    getPostDataWithHashtagsMentions,
    createPost,
    managePostHashtags
);
// Get Post
// getting a single post by it;s id
router.get(
    "/post",
    getPostById
);
// getting all posts of a user by id
router.get(
    "/user/posts/id",
    verifyUserWithToken,
    getPostsByUserId
)
// getting all posts of a user by username
router.get(
    "/user/posts/username",
    getPostsByUsername
)
// getting posts liked by a user
router.get(
    "/posts/liked",
    verifyUserWithToken,
    getLikedPostsByUserId,
)
// getting posts of a mentioned user
router.get(
    "/posts/mentioned_user",
    getPostsByMentionedUser
)
// Update Post
router.post(
    "/post/update",
    verifyUserWithToken,
    getPostDataWithHashtagsMentions,
    updatePost,
    managePostHashtags
);
// Delete Post
router.post(
    "/post/delete",
    verifyUserWithToken,
    deletePost
);


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
