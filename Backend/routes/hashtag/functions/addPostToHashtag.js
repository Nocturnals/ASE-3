//@ts-check

const {
    HashtagModel,
    HashtagfromFirestore,
} = require("../../../models/hashtag");

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// adding post to hashtag
module.exports = async (req, res, hashtag_name) => {
    try {
        const hashtagDoc = await hashtagCRUD.getHashtagViaName(hashtag_name);
        let hashtag;

        // check if hashtag already exists
        if (hashtagDoc) {            
            hashtag = await HashtagfromFirestore({
                mapData: hashtagDoc.data(),
                docId: hashtagDoc.id,
            });
        }
        if (!hashtagDoc) {
            console.log("Creating hashtag");

            hashtag = new HashtagModel({
                id: null,
                hashtag_name: hashtag_name,
            });

            const newHashtagDoc = await hashtagCRUD.createHashtag(hashtag.toMap());

            await hashtag.setId(newHashtagDoc.id);
        }

        // add post id to hashtag post ids
        let hashtag_post_ids = await hashtag.getPost_ids();

        if (!hashtag_post_ids.includes(req.post.getId())) {
            console.log("Updating Hashtag");
            
            // add post id to hashtag
            await hashtag.setPost_ids([ ...hashtag_post_ids, req.post.getId() ]);
            // update hashtag document
            await hashtagCRUD.updateHashtag(hashtag.toMap());
        }

        return true;

    } catch (error) {
        console.log(error);
        return false;
    }
};
