const postCRUD = require("../../../services/firestore/postCRUD");

// delete single post bby id
module.exports.deletePost = async (req, res, next) => {
    try {
        const post = await postCRUD.getPostViaId(req.body.post_id);
        if (post) {
            req.newPostHM = { hashtags: [], mentions: [] };
            req.oldPostHM = {
                hashtags: post.getHashtags(),
                mentions: post.getMentions(),
            };
            // delete the post
            await postCRUD.deletePost(req.body.post_id);

            // remove post id from author post ids
            let post_ids = req.loggedUser.getPost_ids();
            await req.loggedUser.setPost_ids(
                post_ids.splice(post_ids.indexOf(req.body.post_id), 1)
            );

            // return res.status(200).json({ message: "Post deleted sucessfully." });
            console.log("Post deleted sucessfully.");

            req.post = null;
            req.postDeleted = true;

            next();
        }
        return res.status(400).json({ error: "Error deleting the post." });
    } catch (error) {
        return catchError(res, error);
    }
};
