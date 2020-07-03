//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

const removePostFromHashtag = require("../../hashtag/functions/removePostFromHashtag");

// delete all the posts of logged user
module.exports = async (req, res) => {
    try {
        let err_fp = false;
        const post_ids = req.loggedUser.getPost_ids();
        for (let i = 0; i < post_ids.length; i++) {
            let postDoc = await postCRUD.getPostViaId(post_ids[i]);
            if (postDoc.data()) {
                // get post in Post Model type
                let post = await PostfromFirestore({mapData: postDoc.data(), docId: postDoc.id});

                let hashtags = await post.getHashtags();
                for (let j = 0; j < hashtags.length; j++)
                    await removePostFromHashtag(req, res, hashtags[j]);

                // delete the post
                await postCRUD.deletePost(req.body.post_id);

                // remove post id from author post ids
                let post_ids = req.loggedUser.getPost_ids();
                await req.loggedUser.setPost_ids(
                    post_ids.splice(post_ids.indexOf(req.body.post_id), 1)
                );

                console.log("Post deleted sucessfully.");
            } else err_fp = true;
        }
        if (err_fp) {
            console.log("Error finding some posts!!, Remaining are deleted sucessfully.");
            return res.status(200).json({ message: "Error finding some posts!!, Remaining are deleted sucessfully." });
        } else {
            console.log("All posts deleted sucessfully.");
            return res.status(200).json({ message: "All posts deleted sucessfully." });
        }  

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
