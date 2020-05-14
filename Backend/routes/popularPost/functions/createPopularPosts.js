//@ts-check

const {
    PopularPostsModel,
    PopularPostsfromFirestore
} = require("../../../models/popularPost");

const popularPostsCRUD = require("../../../services/firestore/popularPostsCRUD");
const postCRUD = require("../../../services/firestore/postCRUD");

const { getUserByUsername } = require("../../auth/helper");
const { checkPrivacyStatus } = require("../../post/helper");

const { maxPopularPosts } = require("../constants");

module.exports = async (req, res, next) => {
    try {
        let popularPostIdsDoc = await popularPostsCRUD.getPopularPosts();
        if (popularPostIdsDoc && popularPostIdsDoc.data()["last_modified_time"].getTime() <= 86400000)
            next();

        if (popularPostIdsDoc != null) {
            let all_posts = await postCRUD.getAllPosts();
            all_posts = all_posts.sort(
                (post_a, post_b) => (post_a.getLikes_count() < post_b.getLikes_count()) ? 1 : -1);

            let updatedpopularPostIds = [];
            let max_no_of_posts = maxPopularPosts;
            for (let index = 0; index < max_no_of_posts; index++) {
                if (index < all_posts.length) {
                    let postDoc = await postCRUD.getPostViaId(all_posts[index].getId());

                    if (postDoc) {
                        let post_user = await getUserByUsername(postDoc.data()["author_name"]);

                        if (!checkPrivacyStatus(req, res, post_user))
                            updatedpopularPostIds.push(all_posts[index].getId());
                        else max_no_of_posts = max_no_of_posts + 1;

                    } else return res.status(400).json({message: "Couldn't fetch feed!!"});
                } else break;
            }

            if (!popularPostIdsDoc) {
                let popularPostsMap = new PopularPostsModel({
                    id: null
                });
                popularPostsMap.setPost_ids(updatedpopularPostIds);
                await popularPostsCRUD.createPopularPosts();
            } else {
                let popularPostIdsModel = await PopularPostsfromFirestore({
                    mapData: popularPostIdsDoc.data(),
                    docId: popularPostIdsDoc.id
                });
                popularPostIdsModel.setPost_ids(updatedpopularPostIds);
                popularPostIdsModel.setLast_modified_time(Date.now());

                await popularPostsCRUD.updatePopularPosts(popularPostIdsModel.toMap());
            }
        }

        next();

    } catch (error) {
        return res.status(400).json({message: error});
    }
}