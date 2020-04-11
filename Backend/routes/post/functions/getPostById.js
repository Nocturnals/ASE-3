//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

const { getUserById } = require("../../auth/helper");
const { checkPrivacyStatus } = require("../helper");

// getting post
module.exports = async (req, res) => {
    try {
        const postDoc = await postCRUD.getPostViaId(req.body.post_id);
        if (postDoc) {
            const post = PostfromFirestore({
                mapData: postDoc.data(),
                docId: postDoc.id,
            });
            // get user by id and ckeck privacy status of account
            let user = await getUserById(post.getAuthor_id());

            // check the pricvacy status of the user
            await checkPrivacyStatus(req, res, user);

            return res.status(200).json(post.toMap());
        
        }

        return res.status(400).json({ message: "Post not found!" });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
