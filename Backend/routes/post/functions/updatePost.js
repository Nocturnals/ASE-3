//@ts-check

const { getPostDataWithHashtagsMentions, catchError } = require("../helper");
const { postValidation } = require("../postValidations");

const postCRUD = require("../../../services/firestore/postCRUD");

// updating post
module.exports = async (req, res) => {
    const uPost = await getPostDataWithHashtagsMentions(req.body);

    // validating the post details
    const validatedPostData = postValidation(uPost);
    if (validatedPostData.error) {
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });
    }

    try {
        // ePost -> existing post
        const ePost = await postCRUD.getPostViaId(req.body.post_id);
        if (ePost) {
            console.log("Updating post");

            // setting updated description
            if (ePost.getDescription() != req.body.description)
                await ePost.setDescription(uPost.description);

            // setting updated hashtags
            let new_hashtags = [];
            let old_hashtags = [];
            if (ePost.getHashtags() != req.postHM.hashtags) {
                // new/updated post hashtags and mentions
                new_hashtags = new_hashtags.push(
                    req.postHM.hashtags.filter(
                        (x) => !ePost.getHashtags().includes(x)
                    )
                )[0];
                // old post hashtags and mentions
                old_hashtags = old_hashtags.push(
                    ePost
                        .getHashtags()
                        .filter((x) => !req.postHM.hashtags.includes(x))
                )[0];

                await ePost.setHashtags(req.postHM.hashtags);
            }

            // setting updated mentions
            let new_mentions = [];
            let old_mentions = [];
            if (ePost.getMentions() != req.postHM.mentions) {
                // new/updated post hashtags and mentions
                new_mentions = new_mentions.push(
                    req.postHM.mentions.filter(
                        (x) => !ePost.getMentions().includes(x)
                    )
                )[0];
                // old post hashtags and mentions
                old_mentions = old_mentions.push(
                    ePost
                        .getMentions()
                        .filter((x) => !req.postHM.mentions.includes(x))
                )[0];

                await ePost.setMentions(req.postHM.mentions);
            }

            // updating the post
            const postDoc = await postCRUD.updatePost(ePost.toMap());
            await ePost.setId(postDoc.id);

            console.log("Post Updated");

            req.newPostHM = { hashtags: new_hashtags, mentions: new_mentions };
            req.oldPostHM = { hashtags: old_hashtags, mentions: old_mentions };

            req.post = ePost;
            next();

            // return res.status(200).json(ePost.toMap());
        }

        return res.status(400).json({ message: "Post couldn't be updated" });
    } catch (error) {
        return catchError(res, error);
    }
};
