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
            return res.status(404).json({error: "Couldn't get posts! Problem with verifying user"});

        let liked_posts = [];
        // get post ids of posts of a user
        const liked_post_ids = await user.getLiked_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < liked_post_ids.length; i++) {
            // get post document from firestore
            let postDoc = await postCRUD.getPostViaId(liked_post_ids[i]);
            if (!postDoc.data())
                return res.status(404).json({error: "Couldn't get posts! Problem with finding post"});

            let post = await PostfromFirestore({
                mapData: postDoc.data(),
                docId: postDoc.id,
            });
            if (!post) return res.status(404).json({ message: 'Error in finding post' });

            liked_posts = [ ...liked_posts, post.toMap() ];
        }

        return res.json({ liked_posts: liked_posts });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
