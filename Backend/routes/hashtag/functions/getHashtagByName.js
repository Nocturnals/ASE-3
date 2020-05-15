//@ts-check

const { HashtagfromFirestore } = require("../../../models/hashtag");

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// get hashtag by hashtag name
module.exports = async (req, res) => {
    try {
        const hashtagDoc = await hashtagCRUD.getHashtagViaName(req.body.hashtag_name);
        
        // checking weather the hashtag with given name exists or not
        if (hashtagDoc) {
            let hashtag = await HashtagfromFirestore({mapData: hashtagDoc.data(), docId: hashtagDoc.id});
            return res.status(200).json({hashtag: hashtag.toMap()});
        }

        return res.status(400).json({ message: "No hashtag found with name: " + req.body.hashtag_name });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
}