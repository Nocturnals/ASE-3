//@ts-check

const express = require("express");

// instance of new router
const router = express.Router();

// All ruotes to post goes here
// get all hashtags from the collection
router.get("/get_all", require("./functions/getAllHashtags"));

// get hashtag by name
router.get("/get_hashtag_by_name", require("./functions/getHashtagByName"));

module.exports = router;
