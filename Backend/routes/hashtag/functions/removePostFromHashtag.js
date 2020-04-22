//@ts-check

const { HashtagfromFirestore } = require("../../../models/hashtag");

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// removing post from hashtag
module.exports = async (req, res, hashtag_name) => {
    try {
        const hashtagDoc = await hashtagCRUD.getHashtagViaName(hashtag_name);

        if (hashtagDoc) {
            let hashtag = await HashtagfromFirestore({
                mapData: hashtagDoc.data(),
                docId: hashtagDoc.id,
            });
            // remove post id from hashtag post ids
            const hashtag_post_ids = await hashtag.getPost_ids();
            if (hashtag_post_ids.includes(req.post.id)) {
                await hashtag.setPost_ids(
                    hashtag_post_ids.splice(
                        hashtag_post_ids.indexOf(req.post.id),
                        1
                    )
                );
                await hashtagCRUD.updateHashtag(hashtag.toMap());

                return hashtag;
            }

            console.log("Post doesn't have this hastag");
            
            return null;
        }

        console.log("Hashtag Not found!!");

        return null;

    } catch (error) {
        console.log(error);
        return false;
    }
};
