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
router.post("/register", require("./register"));

// route to login new user
router.post("/login", require("./login"));

// route to forgotpassword
router.post("/forgotpassword", require("./forgotPassword"));

// route to get the logged user details
router.get("/user", verifyToken, verifyUserWithToken, require("./getUser"));

// route to send mail to verify the email of the user
router.post(
    "/sendEmailVerification",
    verifyToken,
    verifyUserWithoutEmailVerification,
    require("./sendEmailVerification")
);

// route to verify the secret code and verify the email of the user
router.post(
    "/verifyEmail",
    verifyToken,
    verifyUserWithoutEmailVerification,
    require("./verifyEmail")
);

// route to verify the given code and reset the password
router.post("./verifyForgotPassword", require("./verifyForgotPassword"));

// ----
router.post(
    "/set_public_to",
    verifyToken,
    verifyUserWithToken,
    require("./setPublic_to")
);

module.exports = router;
