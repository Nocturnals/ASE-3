//@ts-check

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// get all hashtags from the collection
module.exports = async (req, res) => {
    try {
        let hashtags = await hashtagCRUD.getAll();
        console.log(hashtags);

        return res.json({ hashtags: hashtags });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
