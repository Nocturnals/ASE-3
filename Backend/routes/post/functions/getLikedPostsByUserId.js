const { PostfromFirestore } = require("../../../models/post");

const { getUserById } = require("../../auth/helper");
const { catchError } = require("../helper");

const postCRUD = require("../../../services/firestore/postCRUD");

// get liked posts of a user
module.exports.getLikedPostsByUserId = async (req, res) => {
    try {
        let user = getUserById(req.body.user_id);
        if (!user.getPublic_to().includes(req.loggedUser.id))
            return res.status(200).json({
                message:
                    "Post cannot be displayed! The user has a private account!!",
            });

        let liked_posts = [];
        // get post ids of posts of a user
        let liked_post_ids = await req.user.getLiked_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < liked_post_ids.length; i++) {
            let post = postCRUD.getPostViaId(liked_post_ids[i]);
            if (post) {
                post = PostfromFirestore({
                    mapData: post.data(),
                    docId: post.id,
                });
                liked_posts.push(post.toMap());
            }
        }

        return res.json(liked_posts);
    } catch (error) {
        return catchError(res, error);
    }
};
