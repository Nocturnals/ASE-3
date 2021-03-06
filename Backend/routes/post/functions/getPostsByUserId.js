//@ts-check
const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

const { getUserById } = require("../../auth/helper");
const { checkPrivacyStatus } = require("../helper");

// get posts of a user by id
module.exports = async (req, res) => {
    try {
        // get user and check privacy status
        let user = await getUserById(req.body.user_id);
        if (!user)
            return res.status(500).json({error: "Couldn't upload post! Problem with verifying user"});

        // check the pricvacy status of the user
        const access = await checkPrivacyStatus(req, res, user);
        if (!access) {
            return res.status(200).json({
                message:
                    "Post cannot be displayed! The user has a private account!!",
            });
        }

        let posts = [];
        let post_ids = await user.getPost_ids();
        for (let i = 0; i < post_ids.length; i++) {
            // get post document using id
            let postDoc = await postCRUD.getPostViaId(post_ids[i]);
            let post = await PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id });

            posts.push(post.toMap());
        }

        return res.json({ posts: posts });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
