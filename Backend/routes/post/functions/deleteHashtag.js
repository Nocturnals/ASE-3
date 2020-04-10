//@ts-check

const { catchError } = require("../helper");

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// deleting hashtag
module.exports = async (req, res, hashtag_name) => {
    try {
        const hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);
        if (hashtag) {
            await hashtagCRUD.deleteHashtag(hashtag.id);
            console.log("Hashtag deleted.");
        }

        console.log("No hashtag found!");
    } catch (error) {
        catchError(res, error);
    }
};
