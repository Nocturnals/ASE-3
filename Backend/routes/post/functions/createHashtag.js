//@ts-check

const { HashtagModel } = require("../../../models/hashtag");

const { catchError } = require("../helper");

const hashtagCRUD = require("../../../services/firestore/hashtagCRUD");

// create hashtag
module.exports = async (req, res, hashtag_name) => {
    try {
        const hashtag = await hashtagCRUD.getHashtagViaName(hashtag_name);

        if (!hashtag) {
            console.log("Creating hashtag");

            const hashtag = new HashtagModel({
                id: null,
                hashtag_name: hashtag_name,
            });

            const hashtagDoc = await hashtagCRUD.createHashtag(hashtag.toMap());
            await hashtag.setId(hashtagDoc.id);

            return hashtag;
        }
    } catch (error) {
        catchError(res, error);
    }
};
