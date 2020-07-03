//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

const { getUserByUsername } = require("../../auth/helper");
const { checkPrivacyStatus } = require("../helper");
const { mentionValidation } = require("../postValidations");

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
        let user = await getUserByUsername(req.body.username);
        if (!user)
            return res.status(404).json({error: "Couldn't get posts! Problem with verifying user"});

        // check the pricvacy status of the user
        const access = await checkPrivacyStatus(req, res, user);
        if (!access) {
            return res.status(200).json({
                message:
                    "Posts cannot be displayed! The user has a private account!!",
            });
        }

        // get mentioned post ids
        let mentioned_post_ids = await user.getMentioned_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < mentioned_post_ids.length; i++) {
            let postDoc = await postCRUD.getPostViaId(mentioned_post_ids[i]);
            if (!postDoc.data())
                return res.status(404).json({error: "Couldn't get posts! Problem with finding post"});
            
            let post = await PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id });
            if (!post) return res.status(404).json({ message: 'Error in finding post' });

            mentioned_posts = [ ...mentioned_posts, post.toMap() ];
        }

        return res.json({ mentioned_posts: mentioned_posts });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
