//@ts-check

const { mentionValidation } = require("../postValidations");

const { getUserByUsername } = require("../../auth/helper");

const userCRUD = require("../../../services/firestore/userCRUD");

// update post mentions
module.exports = async (req, res, next) => {
    // mentions validations
    let validatedData = await mentionValidation({ 
        mentions: req.newPostHM.mentions 
    });
    if (validatedData.error) {
        return res.status(400).json({ message: validatedData.error.details[0].message });
    }
    validatedData = await mentionValidation({ 
        mentions: req.oldPostHM.mentions 
    });
    if (validatedData.error) {
        return res.status(400).json({ message: validatedData.error.details[0].message });
    }

    try {
        // removing old mentions from the post description
        if (req.oldPostHM.mentions.length != 0) {
            console.log("Removing old mentions");
            
            const oldMentions = req.oldPostHM.mentions;
            for (let i = 0; i < oldMentions.length; i++) {
                let user = await getUserByUsername(oldMentions[i]);

                if (!user)
                    continue;

                // updated mentioned post ids in user
                let user_mentioned = user.getMentioned_post_ids();
                let new_user_mentioned = [];
                for (let j = 0; j < user_mentioned.length; j++)
                    if (user_mentioned[j] != req.post.getId())
                        new_user_mentioned.push(user_mentioned[j]);
                
                await user.setMentioned_post_ids(new_user_mentioned);
                await userCRUD.updateUser(user.toMap());
            }
        }

        // adding new mentions added to the post description
        if (req.newPostHM.mentions.length != 0) {
            console.log("Adding newly added mentions");
            
            const newMentions = req.newPostHM.mentions;
            for (let i = 0; i < newMentions.length; i++) {
                let user = await getUserByUsername(newMentions[i]);

                if (!user)
                    continue;

                // updated mentioned post ids in user
                let user_mentioned = user.getMentioned_post_ids();
                await user.setMentioned_post_ids([ ...user_mentioned, req.post.getId() ]);

                await userCRUD.updateUser(user.toMap());
            }
        }

        next();

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
}
