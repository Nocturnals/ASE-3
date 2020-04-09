const { getUserById } = require("../../auth/helper");
const { catchError } = require("../helper");

// get posts of a user by id
module.exports.getPostsByUserId = async (req, res) => {
    try {
        // get user and check privacy status
        let user = await getUserById(req.body.user_id);
        if (user.getPrivacy_status()) {
            if (!req.loggedUser) {
                return res
                    .status(200)
                    .json({
                        message:
                            "Post cannot be displayed! The user has a private account!!",
                    });
            }
            let public_to = await user.getPublic_to();
            if (!public_to.includes(req.loggedUser.id))
                return res
                    .status(200)
                    .json({
                        message:
                            "Post cannot be displayed! The user has a private account!!",
                    });
        }

        let posts = await retrievePosts(user);

        return res.json({ posts: posts });
    } catch (error) {
        return catchError(res, error);
    }
};
