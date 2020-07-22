//ts-check

const express = require("express");

// instance of new router
const router = express.Router();

router.post("/", async (req, res, next) => {
    try {
        console.log(req.body);
        return res.json({ message: "successfully registered as babysitter" });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
    // res.json({ time: Date.now(), message: "hello", port: process.env });
});

module.exports = router;