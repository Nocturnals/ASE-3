const express = require("express");

const {
    getAllHashtags
} = require("./functions");

// instance of new router
const router = express.Router();

// All ruotes to post goes here
// get all hashtags from the collection
router.get(
    "/get_all",
    getAllHashtags
)

module.exports = router;