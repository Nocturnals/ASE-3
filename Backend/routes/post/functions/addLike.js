//@ts-check

const { catchError } = require("../helper");

const postCRUD = require("../../../services/firestore/postCRUD");
const { PostfromFirestore } = require("../../../models/post");

// adding like
module.exports = async (req, res) => {
    try {
        // ePost -> existing post
        const ePost = await postCRUD.getPostViaId(req.body.post_id);
        if (ePost) {
            // check if user already liked this post and update liked by users
            const post_instance = PostfromFirestore({
                mapData: ePost.data(),
                docId: ePost.id,
            });

            if (!post_instance.getLiked_by().includes(req.body.liked_user_id)) {
                post_instance.setLiked_by(
                    post_instance.getLiked_by().push(req.body.liked_user_id)
                );
                post_instance.setLikes_count(
                    post_instance.getLikes_count() + 1
                );

                console.log("Like added");

                const postDoc = await postCRUD.updatePost(
                    post_instance.toMap()
                );
            }
        }
    } catch (error) {
        return catchError(res, error);
    }
};
