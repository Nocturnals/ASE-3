// @ts-check
/**express instance */
const express = require("express");

const { verifyToken, verifyUserWithToken } = require("../auth/helper");

/**
 * Instance of the babysitter router
 */
const router = express.Router();

// All routes of babysiter here
router.post("/register", verifyToken, verifyUserWithToken, require("./functions/registerBabysitter"));

module.exports = router;
