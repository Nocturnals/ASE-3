const jwt = require("jsonwebtoken");

const { UserfromFirestore } = require("../../models/user");
const { PostfromFirestore } = require("../../models/post");
const userFirestoreCRUD = require("../../services/firestore/userCRUD");

// Seperating hashtags from the description
const getPostDataWithHashtagsMentions = async (req, res, next) => {
    const description = req.body.description;
    if (description) {
        let hashtags = [];
        let mentions = [];
        for (let i = 0; i < description.length; i++) {
            // looping for hashtag
            if (description[i] == "#") {
                let hashtag = "#";
                let j = i + 1;
                for (j; j < description.length; j++) {
                    if (
                        description[j] === "#" ||
                        description[j] === " " ||
                        description[j] === "@"
                    ) {
                        break;
                    }
                    hashtag = hashtag.concat(description[j]);
                }
                hashtags.push(hashtag);

                i = j - 1;
            }
            // looping for mention
            if (description[i] == "@") {
                let mention = "@";
                let j = i + 1;
                for (j; j < description.length; j++) {
                    if (
                        description[j] === "@" ||
                        description[j] === " " ||
                        description[j] === "#"
                    ) {
                        break;
                    }
                    mention.concat(description[j]);
                }
                mentions.push(mention);

                i = j - 1;
            }
        }

        req.postHM = { hashtags: hashtags, mentions: mentions };
    }

    next();
};

// common catch error function
function catchError(res, error) {
    console.log(error);
    return res.status(500).json({ message: "Internal server error" });
}

module.exports = {
    getPostDataWithHashtagsMentions,
    catchError,
};
