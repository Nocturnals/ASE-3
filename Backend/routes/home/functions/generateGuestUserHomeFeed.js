// //@ts-check

const { PostfromFirestore } = require("../../../models/post");
const { PopularPostsfromFirestore } = require("../../../models/popularPost");

const postCRUD = require("../../../services/firestore/postCRUD");

const popularPostsCRUD = require("../../../services/firestore/popularPostsCRUD");

module.exports = async (req, res) => {
    try {
        const allPopularPostIdsDoc = await popularPostsCRUD.getPopularPostsViaId();
        
        if (allPopularPostIdsDoc) {
            let allPopularPostIds = await PopularPostsfromFirestore({ 
                mapData: allPopularPostIdsDoc.data(),
                docId: allPopularPostIdsDoc.id 
            });

            let post_ids = allPopularPostIds.getPost_ids();

            let guestUserHomeFeed = [];
            for (let index = 0; index < post_ids.length; index++) {
                const postDoc = await postCRUD.getPostViaId(post_ids[index]);
                // checking
                if (postDoc) {
                    let post = await PostfromFirestore({ mapData: postDoc.data(), docId: postDoc.id });

                    guestUserHomeFeed = [ ...guestUserHomeFeed, post.toMap() ];
                } else 
                    return res.status(400).json({message: "Error fetching feed"});
            }

            return res.status(200).json({ posts: guestUserHomeFeed });
        }
        return res.status(400).json({ message: "Error fetching feed" });

    } catch (error) {
        console.log(error);
        return res.status(500).json({message: "Couldn't update feed."});
    }
}