//@ts-check

const {
    PopularPostsModel,
    PopularPostsfromFirestore
} = require("../../../models/popularPost");

const popularPostsCRUD = require("../../../services/firestore/popularPostsCRUD");
const postCRUD = require("../../../services/firestore/postCRUD");

const { maxPopularPosts } = require("../constants");

module.exports = async (req, res) => {
    try {
        // remove post id from popular posts if true
        let popularPostsDoc = await popularPostsCRUD.getPopularPosts();
        if (popularPostsDoc) {
            let popularPosts = await PopularPostsfromFirestore({
                mapData: popularPostsDoc.data(),
                docId: popularPostsDoc.id
            });
            if (popularPosts.getPost_ids().includes(req.post_id)) {
                let old_post_ids = popularPosts.getPost_ids();
                const post_index = old_post_ids.indexOf(req.post_id);
                let post_ids = [];
                for (let index = 0; index < old_post_ids.length; index++) {
                    if(index == post_index) continue;
                    post_ids = [ ...post_ids, old_post_ids[index] ];
                }
                popularPosts.setPost_ids(post_ids);
                await popularPostsCRUD.updatePopularPosts(popularPosts.toMap());
            }

            return true;
        }

        return false;
    } catch (error) {
        console.log(error);
        return res.status(500).json({message: "Couldn't update popular posts."});
    }
}