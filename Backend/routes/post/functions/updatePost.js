//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

const { getPostDataWithHashtagsMentions } = require("../helper");
const { postValidation } = require("../postValidations");

// updating post
module.exports = async (req, res, next) => {
    // validating the post details
    const validatedPostData = postValidation({...req.body, ...req.postHM});
    if (validatedPostData.error) {
        return res
            .status(400)
            .json({ message: validatedPostData.error.details[0].message });
    }

    try {
        // get post document from firestore using id
        const postDoc = await postCRUD.getPostViaId(req.body.post_id);

        if (postDoc) {
            console.log("Updating post");

            let post = PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id })

            // setting updated description
            if (post.getDescription() != req.body.description)
                await post.setDescription(req.body.description);

            // setting updated hashtags
            let new_hashtags = [];
            let old_hashtags = [];
            if (post.getHashtags() != req.postHM.hashtags) {
                // new/updated post hashtags and mentions
                new_hashtags = new_hashtags.push(
                    req.postHM.hashtags.filter(
                        (x) => !post.getHashtags().includes(x)
                    )
                )[0];
                // old post hashtags and mentions
                old_hashtags = old_hashtags.push(
                    post
                        .getHashtags()
                        .filter((x) => !req.postHM.hashtags.includes(x))
                )[0];

                await post.setHashtags(req.postHM.hashtags);
            }

            // setting updated mentions
            let new_mentions = [];
            let old_mentions = [];
            if (post.getMentions() != req.postHM.mentions) {
                // new/updated post hashtags and mentions
                new_mentions = new_mentions.push(
                    req.postHM.mentions.filter(
                        (x) => !post.getMentions().includes(x)
                    )
                )[0];
                // old post hashtags and mentions
                old_mentions = old_mentions.push(
                    post
                        .getMentions()
                        .filter((x) => !req.postHM.mentions.includes(x))
                )[0];

                await post.setMentions(req.postHM.mentions);
            }

            // updating the post
            await postCRUD.updatePost(post.toMap());

            console.log("Post Updated");

            req.newPostHM = { hashtags: new_hashtags, mentions: new_mentions };
            req.oldPostHM = { hashtags: old_hashtags, mentions: old_mentions };

            req.post = post;

            next();

            // return res.status(200).json(post.toMap());
        }

        return res.status(400).json({ message: "Post couldn't be updated" });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
