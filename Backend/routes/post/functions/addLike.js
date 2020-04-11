//@ts-check

const postCRUD = require("../../../services/firestore/postCRUD");

const { PostfromFirestore } = require("../../../models/post");

// adding like
module.exports = async (req, res) => {
    try {
        // ePost -> existing post
        const postDoc = await postCRUD.getPostViaId(req.body.post_id);
        if (postDoc) {
            // check if user already liked this post and update liked by users
            let post = PostfromFirestore({
                mapData: postDoc.data(),
                docId: postDoc.id,
            });

            if (!post.getLiked_by().includes(req.loggedUser.getId())) {
                post.setLiked_by(
                    post.getLiked_by().push(req.loggedUser.getId())
                );
                post.setLikes_count(
                    post.getLikes_count() + 1
                );

                console.log("Like added");

                const updatedPostDoc = await postCRUD.updatePost(
                    post.toMap()
                );
            }
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
