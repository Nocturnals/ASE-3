//@ts-check

const express = require("express");

const {
    verifyToken,
    verifyUserWithToken,
    verifyLogin 
} = require("../auth/helper");

// instance of new router
const router = express.Router();

// logged user home feed
router.get(
    "/feed/logged_user",
    verifyToken,
    verifyUserWithToken,
    require("./functions/generateLoggedUserHomeFeed").refreshFeed
);
router.get(
    "/feed/logged_user/more",
    verifyToken,
    verifyUserWithToken,
    require("./functions/generateLoggedUserHomeFeed").refreshFeed
);

// guest user home feed
router.get(
    "/feed/guest_user",
    require("../popularPost/functions/createPopularPosts"),
    require("./functions/generateGuestUserHomeFeed")
)

// export the router
module.exports = router;
