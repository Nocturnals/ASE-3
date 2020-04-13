//@ts-check

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// updating hashtag
module.exports = async (req, res, hashtag) => {
    try {
        console.log("Updating Hahstag");

        const hashtagDoc = await hashtagCRUD.updateHashtag(hashtag.toMap());
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
