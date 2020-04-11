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
        let user = await getUserByUsername(req.body.mention);

        // check the pricvacy status of the user
        await checkPrivacyStatus(req, res, user);

        // get mentioned post ids
        let mentioned_post_ids = await user.getMentioned_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < mentioned_post_ids.length; i++) {
            let postDoc = await postCRUD.getPostViaId(mentioned_post_ids[i]);
            if (postDoc) {
                let post = PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id });
                mentioned_posts.push(post.toMap());
            }
        }

        return res.json({ mentioned_posts: mentioned_posts });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
