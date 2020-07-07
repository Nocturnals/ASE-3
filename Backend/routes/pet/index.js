//ts-check

const express = require("express");

const { verifyToken, verifyUserWithToken } = require("../auth/helper");

/**
 * The router instace of the pet api
 */
const router = express.Router();

router.post(
	"/register",
	verifyToken,
	verifyUserWithToken,
	require("./functions/register")
);

module.exports = router;
