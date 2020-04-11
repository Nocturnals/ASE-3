//@ts-check

const { hashtagsValidation } = require("../hashtagValidations");

const addPostToHashtag = require("./addPostToHashtag");
const removePostFromHashtag = require("../../post/functions/removePostFromHashtag");
const deleteHashtag = require("./deleteHashtag");

// adding post to hashtag immediately after creation
module.exports = async (req, res) => {
    // Validaing the hashtags
    const validatedNewHashtags = await hashtagsValidation({
        hashtags: req.newPostHM.hashtags,
    });
    const validatedOldHashtags = await hashtagsValidation({
        hashtags: req.oldPostHM.hashtags,
    });
    if (validatedNewHashtags.error) {
        return res
            .status(400)
            .json({ message: validatedNewHashtags.error.details[0].message });
    }
    if (validatedOldHashtags.error) {
        return res
            .status(400)
            .json({ message: validatedOldHashtags.error.details[0].message });
    }

    try {
        // removing the post from hashtags which are deleted from the description
        if (req.oldPostHM.hashtags.length != 0) {
            console.log("Updating old hashtags");

            const old_hashtags = req.oldPostHM.hashtags;
            for (let i = 0; i < old_hashtags.length; i++) {
                // removing post id from hashtag
                let hashtag = await removePostFromHashtag(req, res, old_hashtags[i]);

                // check if hashtag has 0 posts
                if (hashtag) {
                    let hashtag_posts = await hashtag.getPost_ids();
                    if (hashtag_posts.length == 0)
                        await deleteHashtag(req, res, old_hashtags[i]);
                }
            }
        }

        // adding the post to hashtags which are added in the description
        if (req.newPostHM.hashtags.length != 0) {
            console.log("Updating new hashtags");

            const new_hashtags = req.newPostHM.hashtags;
            for (let i = 0; i < new_hashtags.length; i++)
                await addPostToHashtag(req, res, new_hashtags[i]);
        }

        // return responses
        if (req.postDeleted) {
            return res
                .status(200)
                .json({ message: "Post deleted succesfully" });
        }
        return res.status(200).json(req.post.toMap());

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
