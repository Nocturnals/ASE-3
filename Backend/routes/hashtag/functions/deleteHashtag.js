//@ts-check

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// deleting hashtag
module.exports = async (req, res, hashtag_name) => {
    try {
        const hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);
        if (hashtag) {
            await hashtagCRUD.deleteHashtag(hashtag.id);
            console.log("Hashtag deleted.");
        }

        console.log("No hashtag found!");
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
