//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

// removing like
module.exports = async (req, res) => {
    try {
        // get post document from firestore using id
        const postDoc = await postCRUD.getPostViaId(req.body.post_id);
        if (postDoc) {
            let post = await PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id });

            // check if user already liked this post and update liked by users
            if (post.getLiked_by().includes(req.loggedUser.getId())) {
                await post.setLiked_by(
                    post.getLiked_by().splice(
                        post.getLiked_by().indexOf(req.body.unliked_user_id),
                        1
                    )
                );
                await post.setLikes_count();

                console.log("Like removed");

                const updatedPostDoc = await postCRUD.updatePost(post.toMap());
            }
        }

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
