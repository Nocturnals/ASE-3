const postCRUD = require("../../../services/firestore/postCRUD");

// delete all the posts of logged user
module.exports = async (req, res) => {
    try {
        const post_ids = req.loggedUser.getPost_ids();
        for (let i = 0; i < post_ids.length; i++) {
            const post = await postCRUD.getPostViaId(post_ids[i]);
            if (post) {
                let hashtags = await post.getHashtags();
                for (let j = 0; j < hashtags.length; j++)
                    this.removePostFromHashtag(req, res, hashtags[j]);

                // delete the post
                await postCRUD.deletePost(req.body.post_id);

                // remove post id from author post ids
                let post_ids = req.loggedUser.getPost_ids();
                await req.loggedUser.setPost_ids(
                    post_ids.splice(post_ids.indexOf(req.body.post_id), 1)
                );

                console.log("Post deleted sucessfully.");
            }
        }
        console.log("All posts deleted sucessfully.");

        return res
            .status(200)
            .json({ message: "All posts deleted sucessfully." });
    } catch (error) {
        catchError(res, error);
    }
};
