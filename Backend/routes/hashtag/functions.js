const { HashtagModel, HashtagfromFirestore } = require("../../models/hashtag");

const hashtagCRUD = require("../../services/firestore/hashtagCRUD");

// get all hashtags from the collection
module.exports.getAllHashtags = async (req, res) => {
    try {
        let hashtags = await hashtagCRUD.getAll();
        console.log(hashtags);
        
        res.json({hashtags: hashtags});
    } catch (error) {
        catchError(res, error);
    }
}

// common catch error function
function catchError(res, error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
}