const { HashtagfromFirestore } = require("../../../models/hashtag");

const { catchError } = require("../helper");

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// removing post from hashtag
module.exports.removePostFromHashtag = async (req, res, hashtag_name) => {
    try {
        const hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);

        if (hashtag) {
            hashtag = await HashtagfromFirestore({
                mapData: hashtag.data(),
                docId: hashtag.id,
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
                await this.updateHashtag(req, res, hashtag);
            }
        }

        console.log("Hashtag Not found!!");
    } catch (error) {
        catchError(res, error);
    }
};
