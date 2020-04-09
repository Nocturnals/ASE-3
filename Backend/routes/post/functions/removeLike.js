const { catchError } = require("../helper");

const postCRUD = require("../../../services/firestore/postCRUD");

// removing like
module.exports = async (req, res) => {
    try {
        // ePost -> existing post
        const ePost = await postCRUD.getPostViaId(req.body.post_id);
        if (ePost) {
            // check if user already liked this post and update liked by users
            if (ePost.getLiked_by().includes(req.body.unliked_user_id)) {
                await ePost.setLiked_by(
                    ePost.liked_by.splice(
                        ePost.getLiked_by().indexOf(req.body.unliked_user_id),
                        1
                    )
                );
                await ePost.setLikes_count();

                console.log("Like removed");

                const postDoc = await postCRUD.updatePost(ePost.toMap());
            }
        }
    } catch (error) {
        return catchError(error);
    }
};
