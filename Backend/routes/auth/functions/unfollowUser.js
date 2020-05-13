//@ts-check

const { getUserByUsername } = require("../helper");

const userCRUD = require("../../../services/firestore/userCRUD");

module.exports = async (req, res) => {
    try {
        if (req.body.username) {
            let unfollow_user = await getUserByUsername(req.body.username);

            if (!unfollow_user)
                return res.status(401).json({message: "Error finding user"});

            // check if user is not following
            let followers = unfollow_user.getFollowers();
            let following = req.loggedUser.getFollowing();
            if (
                !followers.includes(req.loggedUser.getId())
                &&
                !following.includes(unfollow_user.getId())
            )
                return res.status(400).json({message: "Not yet following"});

            // update user followed by
            if (followers.includes(req.loggedUser.getId())) {
                let new_followers = [];
                for (let i = 0; i < followers.length; i++) {
                    if (followers[i] != req.loggedUser.getId()) {
                        new_followers = [ ...new_followers, followers[i] ];
                    }
                }
                await unfollow_user.setFollowers(new_followers);
                
                await userCRUD.updateUser(unfollow_user.toMap());
            }

            // update followed user
            if (following.includes(unfollow_user.getId())) {
                let new_following = [];
                for (let i = 0; i < following.length; i++) {
                    if (following[i] != unfollow_user.getId()) {
                        new_following = [ ...new_following, following[i] ];
                    }
                }
                await req.loggedUser.setFollowing(new_following);

                await userCRUD.updateUser(req.loggedUser.toMap());
            }

            return res.status(200).json({message: "Unfollowed succesfully"});
        }

        return res.status(401).json({message: "No username found in request. Provide one to unfollow them."});

    } catch (error) {
        console.log(error);
        return res.status(500).json({message: "Internal server error"});
    }
}