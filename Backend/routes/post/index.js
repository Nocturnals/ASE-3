//@ts-check

const express = require("express");

const {
    verifyToken,
    verifyUserWithToken,
    verifyLogin 
} = require("../auth/helper");
const { getPostDataWithHashtagsMentions } = require("./helper");

// instance of new router
const router = express.Router();

// All ruotes to post goes here
// Creating new Post
router.post(
    "/create",
    verifyToken,
    verifyUserWithToken,
    getPostDataWithHashtagsMentions,
    require("./functions/createPost"),
    require("./functions/updatePostMentions"),
    require("../hashtag/functions/managePostHashtag")
);

// Get Post
// getting a single post by post id
router.get(
    "/id",
    verifyLogin,
    require("./functions/getPostById")
);

// getting all posts of a user by id
router.get(
    "/user/id",
    verifyToken,
    verifyUserWithToken,
    require("./functions/getPostsByUserId")
);

// getting all posts of a user by username
router.get(
    "/user/username",
    verifyLogin,
    require("./functions/getPostsByUsername")
);

// getting posts liked by a user
router.get(
    "/liked",
    verifyToken,
    verifyUserWithToken,
    require("./functions/getLikedPostsByUserId")
);

// getting posts of a mentioned user
router.get(
    "/mentioned_user",
    verifyLogin,
    require("./functions/getPostsByMentionedUser")
);

// Update Post
router.post(
    "/update",
    verifyToken,
    verifyUserWithToken,
    getPostDataWithHashtagsMentions,
    require("./functions/updatePost"),
    require("./functions/updatePostMentions"),
    require("../hashtag/functions/managePostHashtag")
);

// Delete Post
router.post(
    "/delete/id",
    verifyToken,
    verifyUserWithToken,
    require("./functions/deletePost"),
    require("../hashtag/functions/managePostHashtag")
);

// delete all post
router.post(
    "/delete/all",
    verifyToken,
    verifyUserWithToken,
    require("./functions/deleteAllPostOfLoggedUser")
);

// Add Like
router.post(
    "/like",
    verifyToken,
    verifyUserWithToken,
    require("./functions/addLike")
);

// Remove Like
router.post(
    "/unlike",
    verifyToken,
    verifyUserWithToken,
    require("./functions/removeLike")
);

// export the router
module.exports = router;
