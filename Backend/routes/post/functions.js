const { PostModel, PostfromFirestore } = require("../../models/post");

const { getPostDataWithHashtagsMentions } = require("./helper");
const {
    postValidation,
    hashtagValidation,
    mentionValidation
} = require("./postValidations");

const userCRUD = require("../../services/firestore/userCRUD");
const postCRUD = require("../../services/firestore/postCRUD");

// ----------------------------------------------CRUD OPERATIONS
// creating post
module.exports.createPost = async (req, res) => {
    // get post data with hashtags seperated from description
    postData = await getPostDataWithHashtagsMentions(req.body);

    // validate post data
    const validatedPostData = postValidation(postData);
    if (validatedPostData.error) {
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });
    }
    try {
        const post = new PostModel({
            id: null,
            media_urls: req.body.media_urls,
            hashtags: postData.hashtags,
            mentions: postData.mentions
        })

        // checking if description is null
        if (req.body.description)
            await post.setDescription(req.body.description);

        // creating new post document
        const postDoc = await postCRUD.createPost(post.toMap());
        await post.setId(postDoc.id);

        return res.status(200).json(post.toMap());
        
    } catch (error) {
        return catchError(res, error);
    }
}

// getting post
module.exports.getPostById = async (req, res) => {
    try {
        const post = await postCRUD.getPostViaId(req.body.post_id);
        if (post)
            return res.status(200).json(post.toMap());

    } catch (error) {
        return catchError(res, error);
    }
}

// updating post
module.exports.updatePost = async (req, res) => {
    const uPost = await getPostDataWithHashtagsMentions(req.body);
    
    // validating the post details
    const validatedPostData = postValidation(uPost);
    if (validatedPostData.error) {
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });
    }

    try {
        // ePost -> existing post | uPost -> updating post
        const ePost = await postCRUD.getPostViaId(req.body.post_id);
        if (ePost) {
            const uPost = await getPostDataWithHashtagsMentions(req.body);
            // setting updated description
            if (ePost.description != uPost.description)
                await ePost.setDescription(uPost.description);
            // setting updated hashtags
            if (ePost.hashtags != uPost.hashtags) 
                await ePost.setHashtags(uPost.hashtags);
            // setting updated mentions
            if (ePost.mentions != uPost.mentions)
                await ePost.setMentions(uPost.mentions);

            // updating the post
            const postDoc = await postCRUD.updatePost(ePost.toMap());
            await ePost.setId(postDoc.id);

            return res.status(200).json(ePost.toMap());
        }

        return res.status(400).json({ message: "Post couldn't be updated" });

    } catch (error) {
        return catchError(res, error);
    }
}

// deleting post
module.exports.deletePost = async (req, res) => {
    try {
        const post = await postCRUD.getPostViaId(req.body.post_id);
        if (post) {
            // delete the post
            await postCRUD.deletePost(req.body.post_id);
            return res.status(200).json({ message: "Post deleted sucessfully." });
        }
        return res.status(400).json({ error: "Error deleting the post." });

    } catch (error) {
        return catchError(res, error)
    }
}



// ----------------------------------------------SORTING POSTS
// get posts of a user
module.exports.getPostsByUserId = async (req, res) => {
    try {
        let posts = [];
        // get post ids of posts of a user
        let post_ids = await req.loggedUser.getPost_ids();
        // Looping through all the post ids
        for (let i = 0; i < post_ids.length; i++)
            posts.push(postCRUD.getPostViaId(post_ids[i]));

        return res.json(posts.toMap());

    } catch (error) {
        return catchError(res, error);
    }
}

// get liked posts of a user
module.exports.getLikedPostsByUserId = async (req, res) => {
    try {
        let liked_posts = [];
        // get post ids of posts of a user
        let liked_post_ids = await req.loggedUser.getLiked_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < liked_post_ids.length; i++)
            liked_posts.push(postCRUD.getPostViaId(liked_post_ids[i]));

        return res.json(liked_posts.toMap());

    } catch (error) {
        return catchError(res, error);
    }
}

// get specific user mentioned posts
module.exports.getPostsByUserMentioned = async (req, res) => {
    // validating hashtag
    const validatedData = mentionValidation(req.body.mention);
    if (validatedData.error) {
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });
    }

    try {
        let mentioned_posts = [];
        // get mentioned user by username
        let user = await userCRUD.getUserViaUsername(req.body.mention);
        // get mentioned post ids
        let mentioned_post_ids = await user.getMentioned_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < mentioned_post_ids.length; i++)
            mentioned_posts.push(postCRUD.getPostViaId(mentioned_post_ids[i]));

        return res.json(mentioned_posts);

    } catch (error) {
        return catchError(res, error)
    }
}



// ----------------------------------------------UPDATING LIKES
// adding like
module.exports.addLike = async (req, res) => {
    try {
        // ePost -> existing post
        const ePost = await postCRUD.getPostViaId(req.body.post_id);
        if (ePost) {
            // check if user already liked this post and update liked by users
            if (!ePost.getLiked_by().includes(req.body.liked_user_id)) {
                await ePost.setLiked_by(ePost.getLiked_by().push(req.body.liked_user_id));
                await ePost.setLikes_count();

                const postDoc = await postCRUD.updatePost(ePost.toMap());
            }
        }

    } catch (error) {
        return catchError(res, error);
    }
}

// removing like
module.exports.removeLike = async (req, res) => {
    try {
        // ePost -> existing post
        const ePost = await postCRUD.getPostViaId(req.body.post_id);
        if (ePost) {
            // check if user already liked this post and update liked by users
            if (ePost.getLiked_by().includes(req.body.unliked_user_id)) {
                await ePost.setLiked_by(
                    ePost.liked_by.splice(
                        ePost.getLiked_by().indexOf(req.body.unliked_user_id), 1
                    )
                );
                await ePost.setLikes_count();

                const postDoc = await postCRUD.updatePost(ePost.toMap());
            }
        }

    } catch (error) {
        return catchError(error);
    }
}



// Generating Feed for user
module.exports.generateLoggedUserHomeFeed = async (req, res) => {
    
}




// common catch error function
function catchError(res, error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
}