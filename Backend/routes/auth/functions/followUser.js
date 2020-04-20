//@ts-check

const { getUserByUsername } = require("../helper");

const userCRUD = require("../../../services/firestore/userCRUD");

module.exports = async (req, res) => {
    try {
        if (req.body.username) {
            let follow_user = await getUserByUsername(req.body.username);

            if (!follow_user)
                return res.status(401).json({error: "Error finding user"});

            // check if user is already following
            let followers = follow_user.getFollowers();
            let following = req.loggedUser.getFollowing();
            if (
                followers.includes(req.loggedUser.getId())
                &&
                following.includes(follow_user.getId())
            )
                return res.status(400).json({message: "Already Following"});

            // update user followed by
            if (!followers.includes(req.loggedUser.getId())) {
                await follow_user.setFollowers([ ...followers, req.loggedUser.getId() ]);

                await userCRUD.updateUser(follow_user.toMap());
            }

            // update folowed user
            if (!following.includes(follow_user.getId())) {
                await req.loggedUser.setFollowing([ ...following, follow_user.getId() ]);

                await userCRUD.updateUser(req.loggedUser.toMap());
            }
            
            return res.status(200).json({message: "Followed succesfully"});
        }

        return res.status(401).json({error: "No username found in request. Provide one to follow them."});

    } catch (error) {
        console.log(error);
        return res.status(500).json({error: "Internal server error"});
    }
}