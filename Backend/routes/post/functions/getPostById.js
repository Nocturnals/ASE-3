//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

const { getUserByUsername } = require("../../auth/helper");
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
            let user = await getUserByUsername(post.getauthor_name());
            if (!user)
                return res.status(401).json({error: "Couldn't get post! Problem with verifying user"});

            // check the pricvacy status of the user
            const access = await checkPrivacyStatus(req, res, user);
            if (!access) {
                return res.status(401).json({
                    message:
                        "Post cannot be displayed! The user has a private account!!",
                });
            }

            return res.status(200).json(post.toMap());
        
        }

        return res.status(400).json({ message: "Post not found!" });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
