const { PostModel, PostfromFirestore } = require("../../models/post");
const { HashtagModel, HashtagfromFirestore } = require("../../models/hashtag");

const { getUserById, getUserByUsername } = require("../auth/helper");
const { getPostDataWithHashtagsMentions } = require("./helper");
const {
    postValidation,
    hashtagValidation,
    mentionValidation
} = require("./postValidations");

const userCRUD = require("../../services/firestore/userCRUD");
const postCRUD = require("../../services/firestore/postCRUD");
const hashtagCRUD = require("../../services/firestore/hashtagCRUD");

// ----------------------------------------------CRUD OPERATIONS
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
            mentions: req.postHM.mentions
        })

        // checking if description is null
        if (req.body.description)
            await post.setDescription(req.body.description);

        // creating new post document
        const postDoc = await postCRUD.createPost(post.toMap());
        await post.setId(postDoc.id);
        
        let user = await getUserById(req.loggedUser.getId());
        let post_ids = await user.getPost_ids();
        await user.setPost_ids([ ...post_ids, postDoc.id ]);
        
        userDoc = await userCRUD.updateUser(user.toMap());

        console.log(userDoc.data());

        console.log("Post created sucessfully");

        req.newPostHM = { hashtags: req.postHM.hashtags, mentions: req.postHM.mentions };
        req.oldPostHM = { hashtags: [], mentions: [] };        

        req.post = post;
        next();
        // return res.status(200).json(post.toMap());
        
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
        // ePost -> existing post
        const ePost = await postCRUD.getPostViaId(req.body.post_id);
        if (ePost) {
            console.log("Updating post");

            // setting updated description
            if (ePost.getDescription() != req.body.description)
                await ePost.setDescription(uPost.description);

            // setting updated hashtags
            let new_hashtags = [];
            let old_hashtags = [];
            if (ePost.getHashtags() != req.postHM.hashtags) {
                // new/updated post hashtags and mentions
                new_hashtags = new_hashtags.push(req.postHM.hashtags.filter(x => !ePost.getHashtags().includes(x)))[0];
                // old post hashtags and mentions
                old_hashtags = old_hashtags.push(ePost.getHashtags().filter(x => !req.postHM.hashtags.includes(x)))[0];

                await ePost.setHashtags(req.postHM.hashtags);
            }

            // setting updated mentions
            let new_mentions = [];
            let old_mentions = [];
            if (ePost.getMentions() != req.postHM.mentions) {
                // new/updated post hashtags and mentions
                new_mentions = new_mentions.push(req.postHM.mentions.filter(x => !ePost.getMentions().includes(x)))[0];
                // old post hashtags and mentions
                old_mentions = old_mentions.push(ePost.getMentions().filter(x => !req.postHM.mentions.includes(x)))[0];

                await ePost.setMentions(req.postHM.mentions);
            }

            // updating the post
            const postDoc = await postCRUD.updatePost(ePost.toMap());
            await ePost.setId(postDoc.id);

            console.log("Post Updated");

            req.newPostHM = { hashtags: new_hashtags, mentions: new_mentions };
            req.oldPostHM = { hashtags: old_hashtags, mentions: old_mentions };

            req.post = ePost;
            next();

            // return res.status(200).json(ePost.toMap());
        }

        return res.status(400).json({ message: "Post couldn't be updated" });

    } catch (error) {
        return catchError(res, error);
    }
}

// deleting posts
// delete single post bby id
module.exports.deletePost = async (req, res, next) => {
    try {
        const post = await postCRUD.getPostViaId(req.body.post_id);
        if (post) {
            req.newPostHM = { hashtags: [], mentions: [] };
            req.oldPostHM = { hashtags: post.getHashtags(), mentions: post.getMentions() };
            // delete the post
            await postCRUD.deletePost(req.body.post_id);

            // remove post id from author post ids
            let post_ids = req.loggedUser.getPost_ids();
            await req.loggedUser.setPost_ids(post_ids.splice(post_ids.indexOf(req.body.post_id), 1));

            // return res.status(200).json({ message: "Post deleted sucessfully." });
            console.log("Post deleted sucessfully.");

            req.post = null;
            req.postDeleted = true;

            next();
        }
        return res.status(400).json({ error: "Error deleting the post." });

    } catch (error) {
        return catchError(res, error)
    }
}
// delete all the posts of logged user
module.exports.deleteAllPostsofLoggedUser = async (req, res) => {
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
                await req.loggedUser.setPost_ids(post_ids.splice(post_ids.indexOf(req.body.post_id), 1));

                console.log("Post deleted sucessfully.");
            }
        }
        console.log("All posts deleted sucessfully.");

        return res.status(200).json({ message: "All posts deleted sucessfully." });

    } catch (error) {
        catchError(res, error);
    }
}

// getting post
module.exports.getPostById = async (req, res) => {
    try {
        const post = await postCRUD.getPostViaId(req.body.post_id);
        if (post){
            post = PostfromFirestore({mapData: post.data(), docId: post.id});
            // get user by id and ckeck privacy status of account
            let user = getUserById(post.author_id);
            if (!user.getPublic_to().includes(req.loggedUser.id))
                return res.status(200).json({message: "Post cannot be displayed! The user has a private account!!"});
            else
                return res.status(200).json(post.toMap());
        }
        return res.status(400).json({message: "Unkown error ocurred!"});

    } catch (error) {
        return catchError(res, error);
    }
}



// ----------------------------------------------SORTING POSTS
// get posts of a user by id
module.exports.getPostsByUserId = async (req, res) => {
    try {
        // get user and check privacy status
        let user = await getUserById(req.body.user_id);
        if (user.getPrivacy_status()) {
            if (!req.loggedUser) {
                return res.status(200).json({message: "Post cannot be displayed! The user has a private account!!"});
            }
            let public_to = await user.getPublic_to();
            if (!public_to.includes(req.loggedUser.id))
                return res.status(200).json({message: "Post cannot be displayed! The user has a private account!!"});
        }

        let posts = await retrievePosts(user);

        return res.json({posts: posts});

    } catch (error) {
        return catchError(res, error);
    }
}

// get posts of a user by username
module.exports.getPostsByUsername = async (req, res) => {
    try {
        // get user and check privacy status
        let user = await getUserByUsername(req.body.username);
        if (user.getPrivacy_status()) {
            if (!req.loggedUser) {
                return res.status(200).json({message: "Post cannot be displayed! The user has a private account!!"});
            }
            let public_to = await user.getPublic_to();
            if (!public_to.includes(req.loggedUser.id))
                return res.status(200).json({message: "Post cannot be displayed! The user has a private account!!"});
        }

        let posts = await retrievePosts(user);
        console.log(posts);

        return res.status(200).json(posts);

    } catch (error) {
        return catchError(res, error);
    }
}

// get liked posts of a user
module.exports.getLikedPostsByUserId = async (req, res) => {
    try {
        let user = getUserById(req.body.user_id);
        if (!user.getPublic_to().includes(req.loggedUser.id))
            return res.status(200).json({message: "Post cannot be displayed! The user has a private account!!"});

        let liked_posts = [];
        // get post ids of posts of a user
        let liked_post_ids = await req.user.getLiked_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < liked_post_ids.length; i++){
            let post = postCRUD.getPostViaId(liked_post_ids[i]);
            if (post) {
                post = PostfromFirestore({mapData: post.data(), docId: post.id});
                liked_posts.push(post.toMap());
            }
        }

        return res.json(liked_posts);

    } catch (error) {
        return catchError(res, error);
    }
}

// get specific user mentioned posts
module.exports.getPostsByMentionedUser = async (req, res) => {
    // validating mentions
    const validatedData = mentionValidation(req.body.mention);
    if (validatedData.error) {
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });
    }

    try {
        let mentioned_posts = [];
        // get mentioned user by username
        let user = getUserByUsername(req.body.mention);
        if (!user.getPublic_to().includes(req.loggedUser.id))
            return res.status(200).json({message: "Post cannot be displayed! The user has a private account!!"});

        // get mentioned post ids
        let mentioned_post_ids = await user.getMentioned_post_ids();
        // Looping through all the post ids
        for (let i = 0; i < mentioned_post_ids.length; i++) {
            let post = postCRUD.getPostViaId(mentioned_post_ids[i]);
            if (post) {
                post = PostfromFirestore({mapData: post, docId: post.id});
                mentioned_posts.push(post.toMap());
            }
        }

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

                console.log("Like added");

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

                console.log("Like removed");

                const postDoc = await postCRUD.updatePost(ePost.toMap());
            }
        }

    } catch (error) {
        return catchError(error);
    }
}



// Generating Feed for a guest
module.exports.generateGuestUserHomeFeed = async (req, res) => {
    
}

// Generating Feed for user
module.exports.generateLoggedUserHomeFeed = async (req, res) => {
    try {
        let following = req.loggedUser.getFollowing();
        for (let i = 0; i < following.length; i++) {
            const element = following[i];
            
        }
    } catch (error) {
        catchError(res, error);
    }
}



// Managing hashtags
// create hashtag
module.exports.createHashtag = async (req, res, hashtag_name) => {
    try {
        const hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);

        if (!hashtag) {
            console.log("Creating hashtag");
            
            const hashtag = new HashtagModel({
                id: null,
                hashtag_name: hashtag_name
            });

            const hashtagDoc = await hashtagCRUD.createHashtag(hashtag.toMap());
            await hashtag.setId(hashtagDoc.id);
            
            return hashtag;

        }
    } catch (error) {
        catchError(res, error);
    }
}

// updating hashtag
module.exports.updateHashtag = async (req, res, hashtag) => {
    try {
        console.log("Updating Hahstag");
        
        const hashtagDoc = await hashtagCRUD.updateHashtag(hashtag.toMap());

    } catch (error) {
        catchError(res, error);
    }
}

// deleting hashtag
module.exports.deleteHashtag = async (req, res, hashtag_name) => {
    try {
        const hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);
        if (hashtag) {
            await hashtagCRUD.deleteHashtag(hashtag.id);
            console.log("Hashtag deleted.");
        }

        console.log("No hashtag found!");
        
    } catch (error) {
        catchError(res, error);
    }
}

// adding post to hashtag immediately after creation
module.exports.managePostHashtags = async (req, res) => {
    // Validaing the hashtags
    const validatedNewHashtags = await hashtagValidation({ hashtags: req.newPostHM.hashtags });
    const validatedOldHashtags = await hashtagValidation({ hashtags: req.oldPostHM.hashtags });
    if (validatedNewHashtags.error) {
        return res
            .status(400)
            .json({ message: validatedNewHashtags.error.details[0].message });
    }
    if (validatedOldHashtags.error) {
        return res
            .status(400)
            .json({ message: validatedOldHashtags.error.details[0].message });
    }

    try {
        // removing the post from hashtags which are deleted from the description
        if (req.oldPostHM.hashtags.length != 0) {
            console.log("Updating old hashtags");

            const old_hashtags = req.oldPostHM.hashtags;
            for (let i = 0; i < old_hashtags.length; i++) {
                // removing post id from hashtag
                await this.removePostFromHashtag(req, res, old_hashtags[i]);

                // check if hashtag has 0 posts
                hashtag_posts = await hashtag.getPost_ids();
                if (hashtag_posts.length == 0)
                    await this.deleteHashtag(req, res, old_hashtags[i]);
            }
        }
        
        // adding the post to hashtags which are added in the description
        if (req.newPostHM.hashtags.length != 0) {
            console.log("Updating new hashtags");

            const new_hashtags = req.newPostHM.hashtags;
            for (let i = 0; i < new_hashtags.length; i++)
                await this.addPostToHashtag(req, res, new_hashtags[i]);
        }

        if (req.postDeleted) {
            return res.status(200).json({message: "Post deleted succesfully"});
        }
        return res.status(200).json(req.post.toMap());

    } catch (error) {
        catchError(res, error);
    }
}
// adding post to hashtag
module.exports.addPostToHashtag = async (req, res, hashtag_name) => {
    try {
        let hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);

        // check if hashtag already exists
        if (hashtag) {
            hashtag = await HashtagfromFirestore({mapData: hashtag.data(), docId: hashtag.id});
        }
        if (!hashtag) {
            console.log("Creating hashtag");
            
            hashtag = new HashtagModel({
                id: null,
                hashtag_name: hashtag_name
            });

            const hashtagDoc = await hashtagCRUD.createHashtag(hashtag.toMap());
            await hashtag.setId(hashtagDoc.id);
        }

        // add post id to hashtag post ids
        let hashtag_post_ids = await hashtag.getPost_ids();
        console.log(hashtag.getHashtag_name());
        
        if (!hashtag_post_ids.includes(req.post.getId())) {
            await hashtag_post_ids.push(req.post.getId());
            console.log(hashtag_post_ids);
            await hashtag.setPost_ids(hashtag_post_ids)
            console.log(hashtag.getPost_ids());
            await hashtagCRUD.updateHashtag(hashtag.toMap());
        }
        
    } catch (error) {
        catchError(res, error);
    }
}
// removing post from hashtag
module.exports.removePostFromHashtag = async (req, res, hashtag_name) => {
    try {
        const hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);

        if (hashtag) {
            hashtag = await HashtagfromFirestore({mapData: hashtag.data(), docId: hashtag.id});
            // remove post id from hashtag post ids
            const hashtag_post_ids = await hashtag.getPost_ids();
            if (hashtag_post_ids.includes(req.post.id)) {
                await hashtag.setPost_ids(
                    hashtag_post_ids.splice(
                        hashtag_post_ids.indexOf(req.post.id), 1))
                await this.updateHashtag(req, res, hashtag);
            }
        }

        console.log("Hashtag Not found!!");
        
    } catch (error) {
        catchError(res, error);
    }
}




// common catch error function
function catchError(res, error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
}

const retrievePosts = async user => {
    let posts = [];
    // get post ids of posts of a user
    let post_ids = await user.getPost_ids();
    console.log(post_ids);
    // Looping through all the post ids
    for (let i = 0; i < post_ids.length; i++){
        let post = await postCRUD.getPostViaId(post_ids[i]);
        if (post) {
            post = await PostfromFirestore({mapData: post.data(), docId: post.id});
            posts.push(post);
        }
    }

    return posts;
}