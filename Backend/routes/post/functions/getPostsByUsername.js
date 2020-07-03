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
        
        if (!user)
            return res.status(404).json({error: "Couldn't get posts! Problem with verifying user"});

        // check the pricvacy status of the user
        const access = await checkPrivacyStatus(req, res, user);
        if (!access)
            return res.status(200).json({
                message:"Posts cannot be displayed! The user has a private account!!" });

        let posts = [];
        let post_ids = await user.getPost_ids();
        
        for (let i = 0; i < post_ids.length; i++) {
            // get post document using id
            let postDoc = await postCRUD.getPostViaId(post_ids[i]);
            
            if (!postDoc.data())
                return res.status(404).json({error: "Couldn't get posts! Problem with finding post"});

            let post = await PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id });
            if (!post) return res.status(404).json({ message: 'Error in finding post' });

            posts = [ ...posts, post.toMap() ];
        }

        return res.status(200).json({ posts: posts });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
