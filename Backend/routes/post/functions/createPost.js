const { PostModel } = require("../../../models/post");

const { getUserById } = require("../../auth/helper");
const { catchError } = require("../helper");
const { postValidation } = require("../postValidations");

const userCRUD = require("../../../services/firestore/userCRUD");
const postCRUD = require("../../../services/firestore/postCRUD");

// creating post
module.exports.createPost = async (req, res, next) => {
    // validate post data
    const validatedPostData = postValidation(req.body);
    if (validatedPostData.error) {
        return res
            .status(400)
            .json({ message: validatedPostData.error.details[0].message });
    }
    try {
        console.log("Creating Post");

        const post = new PostModel({
            id: null,
            author_id: req.loggedUser.getId(),
            media_urls: req.body.media_urls,
            hashtags: req.postHM.hashtags,
            mentions: req.postHM.mentions,
        });

        // checking if description is null
        if (req.body.description)
            await post.setDescription(req.body.description);

        // creating new post document
        const postDoc = await postCRUD.createPost(post.toMap());
        await post.setId(postDoc.id);

        let user = await getUserById(req.loggedUser.getId());
        let post_ids = await user.getPost_ids();
        await user.setPost_ids([...post_ids, postDoc.id]);

        let userDoc = await userCRUD.updateUser(user.toMap());

        console.log("Post created sucessfully");

        req.newPostHM = {
            hashtags: req.postHM.hashtags,
            mentions: req.postHM.mentions,
        };
        req.oldPostHM = { hashtags: [], mentions: [] };

        req.post = post;
        next();
        // return res.status(200).json(post.toMap());
    } catch (error) {
        return catchError(res, error);
    }
};
