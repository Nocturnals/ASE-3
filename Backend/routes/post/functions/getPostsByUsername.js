//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

const { getUserByUsername } = require("../../auth/helper");
const { checkPrivacyStatus } = require("../helper");

// get posts of a user by username
module.exports = async (req, res) => {
    try {
        // get user and check privacy status
        let user = await getUserByUsername(req.body.username);

        // check the pricvacy status of the user
        await checkPrivacyStatus(req, res, user);

        let posts = [];
        let post_ids = await user.getPost_ids();
        for (let i = 0; i < post_ids.length; i++) {
            // get post document using id
            let postDoc = await postCRUD.getPostViaId(post_ids[i]);
            let post = await PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id });

            posts.push(post.toMap());
        }

        console.log(posts);

        return res.status(200).json({ posts: posts });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
