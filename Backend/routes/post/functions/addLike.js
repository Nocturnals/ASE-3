const { catchError } = require("../helper");

const postCRUD = require("../../../services/firestore/postCRUD");

// adding like
module.exports = async (req, res) => {
    try {
        // ePost -> existing post
        const ePost = await postCRUD.getPostViaId(req.body.post_id);
        if (ePost) {
            // check if user already liked this post and update liked by users
            if (!ePost.getLiked_by().includes(req.body.liked_user_id)) {
                await ePost.setLiked_by(
                    ePost.getLiked_by().push(req.body.liked_user_id)
                );
                await ePost.setLikes_count();

                console.log("Like added");

                const postDoc = await postCRUD.updatePost(ePost.toMap());
            }
        }
    } catch (error) {
        return catchError(res, error);
    }
};
