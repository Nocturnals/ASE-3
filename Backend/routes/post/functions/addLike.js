//@ts-check

const userCRUD = require("../../../services/firestore/userCRUD");
const postCRUD = require("../../../services/firestore/postCRUD");

const { PostfromFirestore } = require("../../../models/post");

const { getUserById } = require("../../auth/helper");

// adding like
module.exports = async (req, res) => {
    try {
        // ePost -> existing post
        const postDoc = await postCRUD.getPostViaId(req.body.post_id);
        if (postDoc) {
            // get user using id
            let user = await getUserById(req.loggedUser.getId());
            if (!user)
                return res.status(500).json({error: "Couldn't upload post! Problem with verifying user"});

            let post = PostfromFirestore({
                mapData: postDoc.data(),
                docId: postDoc.id,
            });

            // check if user already liked this post and update liked by users
            if (!post.getLiked_by().includes(user.getId())) {
                post.setLiked_by(
                    post.getLiked_by().push(user.getId())
                );
                post.setLikes_count(
                    post.getLikes_count() + 1
                );

                console.log("Like added");

                const updatedPostDoc = await postCRUD.updatePost(
                    post.toMap()
                );

                if (!user.getLiked_post_ids().includes(post.getId())) {
                    let liked_post_ids = await user.getLiked_post_ids();

                    await user.setLiked_post_ids([ ...liked_post_ids, post.getId() ]);
                    let updatedUserDoc = await userCRUD.updateUser(user.toMap());
                }
            }
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
