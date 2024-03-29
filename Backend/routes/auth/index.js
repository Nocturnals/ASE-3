//ts-check

const express = require("express");

const {
    verifyToken,
    verifyUserWithToken,
    verifyUserWithoutEmailVerification,
} = require("./helper");

// instance of new router
const router = express.Router();

// All ruotes to auth goes here
// route to register new user
router.post("/register", require("./functions/register"));

// route to login new user
router.post("/login", require("./functions/login"));

// route to forgotpassword
router.post("/forgotpassword", require("./functions/forgotPassword"));

// route to get the logged user details
router.get(
    "/user",
    verifyToken,
    verifyUserWithToken,
    require("./functions/getUser")
);

// route to send mail to verify the email of the user
router.post(
    "/sendEmailVerification",
    verifyToken,
    verifyUserWithoutEmailVerification,
    require("./functions/sendEmailVerification")
);

// route to verify the secret code and verify the email of the user
router.post(
    "/verifyEmail",
    verifyToken,
    verifyUserWithoutEmailVerification,
    require("./functions/verifyEmail")
);

// route to verify the given code and reset the password
router.post(
    "./verifyForgotPassword",
    require("./functions/verifyForgotPassword")
);

// ----
router.post(
    "/set_public_to",
    verifyToken,
    verifyUserWithToken,
    require("./functions/setPublic_to")
);
// follow user
router.post(
    "/follow",
    verifyToken,
    verifyUserWithToken,
    require("./functions/followUser")
);
// unfollow user
router.post(
    "/unfollow",
    verifyToken,
    verifyUserWithToken,
    require("./functions/unfollowUser")
);

module.exports = router;
