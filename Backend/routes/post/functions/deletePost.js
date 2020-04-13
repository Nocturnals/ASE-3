//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const { getUserById } = require("../../auth/helper");

const userCRUD = require("../../../services/firestore/userCRUD");
const postCRUD = require("../../../services/firestore/postCRUD");

// delete single post bby id
module.exports = async (req, res, next) => {
    try {
        const postDoc = await postCRUD.getPostViaId(req.body.post_id);
        if (postDoc) {
            let post = await PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id });

            // get user using logged user id
            let user = await getUserById(req.loggedUser.getId());
            if (!user)
                return res.status(500).json({error: "Couldn't upload post! Problem with verifying user"});

            req.newPostHM = { hashtags: [], mentions: [] };
            req.oldPostHM = {
                hashtags: post.getHashtags(),
                mentions: post.getMentions(),
            };
            // delete the post
            await postCRUD.deletePost(req.body.post_id);

            // remove post id from author post ids
            let post_ids = await user.getPost_ids();
            await user.setPost_ids(
                post_ids.splice(post_ids.indexOf(req.body.post_id), 1)
            );

            // updating user document
            let userDoc = await userCRUD.updateUser(user.toMap());

            // return res.status(200).json({ message: "Post deleted sucessfully." });
            console.log("Post deleted sucessfully.");

            req.post = null;
            req.postDeleted = true;

            next();
        }
        return res.status(400).json({ error: "Error deleting the post." });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
