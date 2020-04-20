//@ts-check

const postCRUD = require("../../../services/firestore/postCRUD");

const { PostfromFirestore } = require("../../../models/post");

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
            // check the privacy status of the user
            if (
                sorted_users[i].getPrivacy_status() 
                &&
                !sorted_users[i].getPublic_to().includes(req.loggedUser.getId())) 
                continue;

            const post_ids = await sorted_users[i].getPos_ids();
            let posts = [];
            for (let j = 0; j < post_ids.length; j++) {
                const postDoc = await postCRUD.getPostViaId(post_ids[j]);
                let post = await PostfromFirestore({mapData: postDoc.data(), docId: postDoc.id});

                posts = [ ...posts, post.toMap() ];
            }

            following_posts = [ ...following_posts, posts ];
        }

        // sort post ids according to date_of_creation
        await following_posts.sort((post_a, post_b) => {
            return post_a.date_of_creation.getTime() - post_b.date_of_creation.getTime();     // ascending order
        })

        if (req.body.refersh) {
            // if there are more than 25 posts
            if (following_posts.length >= 25)
                res.status(200).json({ posts: following_posts.slice(0, 25) });
            
            // if there are less than 25 posts
            res.status(200).json({ posts: following_posts });
        }

        const scroll_number = req.body.scroll_number;
        if (scroll_number) {
            // if there are more than 5 posts
            if (following_posts.length >= scroll_number*5 + 25)
                res.status(200).json({ posts: following_posts.slice((scroll_number-1)*5 + 25, scroll_number*5 + 25) });

            // if there are less than 5 posts
            res.status(200).json({ posts: following_posts.slice((scroll_number-1)*5 + 25, following_posts.length -1) });
        }

        res.json({error: "Couldn't update feed"})

    } catch (error) {
        console.log(error);
        res.status(500).json({error: "Couldn't update feed."});
    }
};
