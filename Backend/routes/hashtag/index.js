const express = require("express");

// instance of new router
const router = express.Router();

// All ruotes to post goes here
// get all hashtags from the collection
router.get("/get_all", require("./functions/getAllHashtags"));

module.exports = router;
