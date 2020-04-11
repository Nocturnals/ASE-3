//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const { getUserById } = require("../../auth/helper");
const { checkPrivacyStatus } = require("../helper");

const postCRUD = require("../../../services/firestore/postCRUD");

// get liked posts of a user
module.exports = async (req, res) => {
    try {
        let user = await getUserById(req.body.user_id);
        if (!user)
            return res.status(500).json({error: "Couldn't upload post! Problem with verifying user"});

        // check the pricvacy status of the user
        const access = await checkPrivacyStatus(req, res, user);
        if (!access) {
            return res.status(200).json({
                message:
                    "Posts cannot be displayed! The user has a private account!!",
            });
        }

        let liked_posts = [];
        // get post ids of posts of a user
        const liked_post_ids = await user.getLiked_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < liked_post_ids.length; i++) {
            // get post document from firestore
            let postDoc = await postCRUD.getPostViaId(liked_post_ids[i]);
            if (postDoc) {
                let post = PostfromFirestore({
                    mapData: postDoc.data(),
                    docId: postDoc.id,
                });
                liked_posts.push(post.toMap());
            }
        }

        return res.json({ liked_posts: liked_posts });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
