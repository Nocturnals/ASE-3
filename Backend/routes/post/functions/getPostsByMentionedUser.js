//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const { getUserByUsername } = require("../../auth/helper");
const { catchError } = require("../helper");
const { mentionValidation } = require("../postValidations");

const postCRUD = require("../../../services/firestore/postCRUD");

// get specific user mentioned posts
module.exports = async (req, res) => {
    // validating mentions
    const validatedData = mentionValidation(req.body.mention);
    if (validatedData.error) {
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });
    }

    try {
        let mentioned_posts = [];
        // get mentioned user by username
        let user = getUserByUsername(req.body.mention);
        if (!user.getPublic_to().includes(req.loggedUser.id))
            return res.status(200).json({
                message:
                    "Post cannot be displayed! The user has a private account!!",
            });

        // get mentioned post ids
        let mentioned_post_ids = await user.getMentioned_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < mentioned_post_ids.length; i++) {
            let post = postCRUD.getPostViaId(mentioned_post_ids[i]);
            if (post) {
                post = PostfromFirestore({ mapData: post, docId: post.id });
                mentioned_posts.push(post.toMap());
            }
        }

        return res.json(mentioned_posts);
    } catch (error) {
        return catchError(res, error);
    }
};
