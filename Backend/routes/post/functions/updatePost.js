//@ts-check

const { PostfromFirestore } = require("../../../models/post");

const postCRUD = require("../../../services/firestore/postCRUD");

const { getPostDataWithHashtagsMentions } = require("../helper");
const { postValidation } = require("../postValidations");

// updating post
module.exports = async (req, res, next) => {
  // validating the post details
  const validatedPostData = postValidation({ ...req.body, ...req.postHM });
  if (validatedPostData.error) {
    return res
      .status(400)
      .json({ message: validatedPostData.error.details[0].message });
  }

  try {
    // get post document from firestore using id
    const postDoc = await postCRUD.getPostViaId(req.body.post_id);

    if (!postDoc.data())
      return res.status(400).json({ message: "Post couldn't be updated" });

    console.log("Updating post");

    let post = await PostfromFirestore({
      mapData: postDoc.data(),
      docId: postDoc.id,
    });
    if (!post) return res.status(404).json({ message: 'Error in finding post' });

    // setting updated description
    if (post.getDescription() != req.body.description)
      await post.setDescription(req.body.description);

    // setting updated hashtags
    let new_hashtags = [];
    let old_hashtags = [];
    if (post.getHashtags() != req.postHM.hashtags) {
      // new/updated post hashtags and mentions
      new_hashtags = await req.postHM.hashtags.filter(
        (x) => !post.getHashtags().includes(x)
      );
      // old post hashtags and mentions
      old_hashtags = await post
        .getHashtags()
        .filter((x) => !req.postHM.hashtags.includes(x));

      await post.setHashtags(req.postHM.hashtags);
    }

    // setting updated mentions
    let new_mentions = [];
    let old_mentions = [];
    if (post.getMentions() != req.postHM.mentions) {
      // new/updated post hashtags and mentions
      new_mentions = req.postHM.mentions.filter(
        (x) => !post.getMentions().includes(x)
      );
      // old post hashtags and mentions
      old_mentions = post
        .getMentions()
        .filter((x) => !req.postHM.mentions.includes(x));

      await post.setMentions(req.postHM.mentions);
    }

    // updating the post
    await postCRUD.updatePost(post.toMap());

    console.log("Post Updated");

    req.newPostHM = { hashtags: new_hashtags, mentions: new_mentions };
    req.oldPostHM = { hashtags: old_hashtags, mentions: old_mentions };

    req.post = post;

    next();
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};
