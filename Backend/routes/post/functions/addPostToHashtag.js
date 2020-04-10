//@ts-check

const {
    HashtagModel,
    HashtagfromFirestore,
} = require("../../../models/hashtag");

const { catchError } = require("../helper");

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
            await hashtag_post_ids.push(req.post.getId());
            console.log(hashtag_post_ids);
            await hashtag.setPost_ids(hashtag_post_ids);
            console.log(hashtag.getPost_ids());
            await hashtagCRUD.updateHashtag(hashtag.toMap());
        }
    } catch (error) {
        catchError(res, error);
    }
};
