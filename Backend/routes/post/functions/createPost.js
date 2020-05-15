//@ts-check

const { PostModel } = require("../../../models/post");

const { getUserById } = require("../../auth/helper");
const { postValidation } = require("../postValidations");

const userCRUD = require("../../../services/firestore/userCRUD");
const postCRUD = require("../../../services/firestore/postCRUD");

// creating post
module.exports = async (req, res, next) => {
    // validate post data
    const validatedPostData = postValidation({...req.body, ...req.postHM});
    if (validatedPostData.error) {
        return res
            .status(400)
            .json({ message: validatedPostData.error.details[0].message });
    }
    try {
        console.log("Creating Post");

        // get user using logged user id
        let user = await getUserById(req.loggedUser.getId());
        if (!user)
            return res.status(500).json({message: "Couldn't upload post! Problem with verifying user"});

        let post = new PostModel({
            id: null,
            author_name: req.loggedUser.getUsername(),
            media_urls: req.body.media_urls
        });

        // checking if description is null
        if (req.body.description)
            await post.setDescription(req.body.description);
        // checking if there are no hashtags
        if (req.postHM.hashtags.length != 0)
            await post.setHashtags(req.postHM.hashtags);
        // checking if there are no mentions
        if (req.postHM.mentions.length != 0)
            await post.setMentions(req.postHM.mentions);

        // creating new post document
        const postDoc = await postCRUD.createPost(post.toMap());
        await post.setId(postDoc.id);

        let post_ids = await user.getPost_ids();
        await user.setPost_ids([...post_ids, postDoc.id]);

        // updating user document
        let userDoc = await userCRUD.updateUser(user.toMap());

        console.log("Post created sucessfully and updated user");

        req.newPostHM = {
            hashtags: req.postHM.hashtags,
            mentions: req.postHM.mentions,
        };
        req.oldPostHM = { hashtags: [], mentions: [] };

        req.post = post;

        next();
        // return res.status(200).json(post.toMap());

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
