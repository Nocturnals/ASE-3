//@ts-check

const database = require("./database");

// reference to the collection
let coll_ref = database.collection("post");

module.exports.createPost = async (postMap) => {
    const new_post_ref = await coll_ref.add(postMap);
    return new_post_ref;
};

module.exports.updatePost = async (postMap) => {
    const post_doc = await coll_ref.doc(postMap["id"]).update(postMap);
    return post_doc;
};

module.exports.deletePost = async (id) => {
    return await coll_ref.doc(id).delete();
};

module.exports.getPostViaId = async (id) => {
    const post = await coll_ref.doc(id).get();
    return post;
};

module.exports.getAllPosts = async () => {
    const all_posts_doc = await coll_ref.get();
    let all_posts = [];
    all_posts_doc.docs.forEach((doc) => {
        all_posts.push({ id: doc.id, ...doc.data() });
    });

    if(all_posts.length == 0) return null;

    return all_posts;
}
