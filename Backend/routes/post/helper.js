const jwt = require("jsonwebtoken");

const { UserfromFirestore } = require("../../models/user");
const userFirestoreCRUD = require("../../services/firestore/userCRUD");

// Seperating hashtags from the description
const getPostDataWithHashtagsMentions = async postData => {
    const description = postData.description;
    if (description) {
        let hashtags = [];
        let mentions = [];
        for (let i = 0; i < description.length; i++) {
            // looping for hashtag
            if (description[i] == "#") {
                let j = i + 1;
                let hashtag = "#";
                for (j; j < description.length; j++) {
                    if (description[j] == "#" || description[j] == " ") {
                        break;
                    }
                    hashtag.concat(description[j]);
                }
                i = j - 1;
            }
            // looping for mention
            if (description[i] == "@") {
                let j = i + 1;
                let mention = "@";
                for (j; j < description.length; j++) {
                    if (description[j] == "@" || description[j] == " ") {
                        break;
                    }
                    mention.concat(description[j]);
                }
                i = j - 1;
            }
            hashtags.push(hashtag);
            mentions.push(mention);
        }
        var postDataWithHashtagsMentions = {...postData, hashtags: hashtags, mentions: mentions};
    
        return postDataWithHashtagsMentions;
    }

    return postData;
}

// Ckecking wether the post is private or public
const verifyPostPrivacy = async (req, res, next) => {

}