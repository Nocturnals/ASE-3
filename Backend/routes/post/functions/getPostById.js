const { PostfromFirestore } = require("../../../models/post");

const { getUserById } = require("../../auth/helper");
const { catchError } = require("../helper");

const postCRUD = require("../../../services/firestore/postCRUD");

// getting post
module.exports = async (req, res) => {
    try {
        const post = await postCRUD.getPostViaId(req.body.post_id);
        if (post) {
            post = PostfromFirestore({ mapData: post.data(), docId: post.id });
            // get user by id and ckeck privacy status of account
            let user = getUserById(post.author_id);
            if (!user.getPublic_to().includes(req.loggedUser.id))
                return res.status(200).json({
                    message:
                        "Post cannot be displayed! The user has a private account!!",
                });
            else return res.status(200).json(post.toMap());
        }
        return res.status(400).json({ message: "Unkown error ocurred!" });
    } catch (error) {
        return catchError(res, error);
    }
};
