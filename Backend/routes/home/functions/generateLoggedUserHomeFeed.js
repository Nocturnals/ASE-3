//@ts-check

const postCRUD = require("../../../services/firestore/postCRUD");

const { PostfromFirestore } = require("../../../models/post");

const { getUserById } = require("../../auth/helper")

// Generating Feed for user
module.exports.refreshFeed = async (req, res) => {
    try {
        // get logged user following users list
        let following
        if (req.body.refersh)
            following = req.loggedUser.getFollowing();
        else
            following = req.body.following;

        console.log(following);
        
        // sort the users accordingly
        const sorted_users = following;

        // getting all post ids
        let following_posts = [];
        for (let i = 0; i < sorted_users.length; i++) {
            const user = await getUserById(sorted_users[i]);
            if (user) {
                // check the privacy status of the user
                if (
                    user.getPrivacy_status() 
                    && !user.getPublic_to().includes(req.loggedUser.getId())) 
                    continue;

                const post_ids = await user.getPost_ids();
                let posts = [];
                for (let j = 0; j < post_ids.length; j++) {
                    const postDoc = await postCRUD.getPostViaId(post_ids[j]);
                    if (postDoc) {
                        let post = await PostfromFirestore({mapData: postDoc.data(), docId: postDoc.id});

                        posts = [ ...posts, post.toMap() ];
                    } else
                        return res.status(400).json({message: "Error fetching feed"});
                }

                following_posts = [ ...following_posts, posts ];
            } else
                return res.status(400).json({message: "Error fetching feed"});
        }

        // sort post ids according to date_of_creation
        await following_posts.sort((post_a, post_b) => {
            return post_a.date_of_creation.getTime() - post_b.date_of_creation.getTime();     // ascending order
        })

        if (req.body.refersh) {
            // if there are more than 25 posts
            if (following_posts.length >= 25)
                return res.status(200).json({ posts: following_posts.slice(0, 25) });
            
            // if there are less than 25 posts
            return res.status(200).json({ posts: following_posts });
        }

        const scroll_number = req.body.scroll_number;
        if (scroll_number) {
            // if there are more than 5 posts
            if (following_posts.length >= scroll_number*5 + 25)
                return res.status(200).json({ posts: following_posts.slice((scroll_number-1)*5 + 25, scroll_number*5 + 25) });

            // if there are less than 5 posts
            return res.status(200).json({ posts: following_posts.slice((scroll_number-1)*5 + 25, following_posts.length -1) });
        }

        return res.json({message: "Couldn't update feed"});

    } catch (error) {
        console.log(error);
        return res.status(500).json({message: "Couldn't update feed."});
    }
};
