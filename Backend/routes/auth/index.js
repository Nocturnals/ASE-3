const express = require("express");

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const _ = require("lodash"); // for modifing the array contents

const userModel = require("../../models/user");
const { register, login } = require("./functions");

// instance of new router
const router = express.Router();

// All ruotes to auth goes here
// route to register new user
router.post("/register", register);

// route to login new user
router.post("/login", login);

module.exports = router;
