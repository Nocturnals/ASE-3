const { catchError } = require("../helper");
const { hashtagValidation } = require("../postValidations");

// adding post to hashtag immediately after creation
module.exports.managePostHashtags = async (req, res) => {
    // Validaing the hashtags
    const validatedNewHashtags = await hashtagValidation({
        hashtags: req.newPostHM.hashtags,
    });
    const validatedOldHashtags = await hashtagValidation({
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
                await this.removePostFromHashtag(req, res, old_hashtags[i]);

                // check if hashtag has 0 posts
                hashtag_posts = await hashtag.getPost_ids();
                if (hashtag_posts.length == 0)
                    await this.deleteHashtag(req, res, old_hashtags[i]);
            }
        }

        // adding the post to hashtags which are added in the description
        if (req.newPostHM.hashtags.length != 0) {
            console.log("Updating new hashtags");

            const new_hashtags = req.newPostHM.hashtags;
            for (let i = 0; i < new_hashtags.length; i++)
                await this.addPostToHashtag(req, res, new_hashtags[i]);
        }

        if (req.postDeleted) {
            return res
                .status(200)
                .json({ message: "Post deleted succesfully" });
        }
        return res.status(200).json(req.post.toMap());
    } catch (error) {
        catchError(res, error);
    }
};
