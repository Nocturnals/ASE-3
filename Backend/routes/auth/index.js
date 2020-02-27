const express = require("express");

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const _ = require("lodash"); // for modifing the array contents

const { verifyToken, verifyUserWithToken } = require("./helper");
const { register, login, forgotPassword, getUser } = require("./functions");

// instance of new router
const router = express.Router();

// All ruotes to auth goes here
// route to register new user
router.post("/register", register);

// route to login new user
router.post("/login", login);

// route to forgotpassword
router.post("/forgotpassword", forgotPassword);

router.get("/user", verifyToken, verifyUserWithToken, getUser);

module.exports = router;
