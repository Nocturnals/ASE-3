//@ts-check

const database = require("./database");

// reference to the collection
let coll_ref = database.collection("popularposts");

module.exports.createPopularPosts = async (popularPostsMap) => {
    const new_popular_post_ref = await coll_ref.add(popularPostsMap);
    return new_popular_post_ref;
};

module.exports.updatePopularPosts = async (popularPostsMap) => {
    const popular_post_doc = await coll_ref.doc(popularPostsMap["id"]).update(popularPostsMap);
    return popular_post_doc;
};

module.exports.deletePopularPosts = async (id) => {
    return await coll_ref.doc(id).delete();
};

module.exports.getPopularPostsViaId = async (id) => {
    const popular_post = await coll_ref.doc(id).get();
    return popular_post;
};

module.exports.getPopularPosts = async () => {
    const popular_posts_snapshot = await coll_ref.get();
    if (popular_posts_snapshot) {
        for (let index = 0; index < popular_posts_snapshot.docs.length; index++)
            return popular_posts_snapshot.docs[0];
        return false;
    }
    return null;
}
