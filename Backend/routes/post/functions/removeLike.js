//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const userCRUD = require("../../../services/firestore/userCRUD");
const postCRUD = require("../../../services/firestore/postCRUD");

const { getUserById } = require("../../auth/helper");

// removing like
module.exports = async (req, res) => {
    try {
        // get post document from firestore using id
        const postDoc = await postCRUD.getPostViaId(req.body.post_id);
        if (postDoc) {
            // get user using id
            let user = await getUserById(req.loggedUser.getId());
            if (!user)
                return res
                    .status(500)
                    .json({
                        message: "Couldn't upload post! Problem with verifying user",
                    });

            let post = await PostfromFirestore({
                mapData: postDoc.data(),
                docId: postDoc.id,
            });

            // check if user already liked this post and update liked by users
            let liked_by = await post.getLiked_by();
            if (liked_by.includes(user.getId())) {
                // remove unliked user from liked by and get updated liked by list
                let updated_liked_by = [];
                for (let i = 0; i < liked_by.length; i++) {
                    if (liked_by[i] == user.getId())
                        continue;
                    updated_liked_by.push(liked_by[i]);
                }

                await post.setLiked_by(updated_liked_by);
                await post.setLikes_count(post.getLiked_by().length);

                await postCRUD.updatePost(post.toMap());

                console.log("Like removed");

                if (user.getLiked_post_ids().includes(post.getId())) {
                    let liked_post_ids = user.getLiked_post_ids();
                    // remove unliked user from liked by and get updated liked by list
                    let updated_liked_post_ids = [];
                    for (let i = 0; i < liked_post_ids.length; i++) {
                        if (liked_post_ids[i] == post.getId())
                            continue;
                        updated_liked_post_ids.push(liked_post_ids[i]);
                    }

                    await user.setLiked_post_ids(updated_liked_post_ids );
                    await userCRUD.updateUser(user.toMap());
                }

                return res.status(200).json({message: "Liked Removed"});
            }

            return res.status(400).json({message: "You haven't liked this post yet!!"});
        }
        return res.status(400).json({message: "Error finding post"});

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
