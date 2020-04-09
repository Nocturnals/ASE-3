const { catchError } = require("../helper");

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
};
