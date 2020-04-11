//@ts-check

const {
    HashtagModel,
    HashtagfromFirestore,
} = require("../../../models/hashtag");

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// adding post to hashtag
module.exports = async (req, res, hashtag_name) => {
    try {
        let hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);

        // check if hashtag already exists
        if (hashtag) {
            hashtag = await HashtagfromFirestore({
                mapData: hashtag.data(),
                docId: hashtag.id,
            });
        }
        if (!hashtag) {
            console.log("Creating hashtag");

            hashtag = new HashtagModel({
                id: null,
                hashtag_name: hashtag_name,
            });

            const hashtagDoc = await hashtagCRUD.createHashtag(hashtag.toMap());
            console.log(hashtagDoc);

            await hashtag.setId(hashtagDoc.id);
        }

        // add post id to hashtag post ids
        let hashtag_post_ids = await hashtag.getPost_ids();
        console.log(hashtag.getHashtag_name());

        if (!hashtag_post_ids.includes(req.post.getId())) {
            console.log(hashtag_post_ids);
            // add post id to hashtag
            await hashtag.setPost_ids([ ...hashtag_post_ids, req.post.getId() ]);
            console.log(hashtag.getPost_ids());
            // update hashtag document
            await hashtagCRUD.updateHashtag(hashtag.toMap());
        }

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
