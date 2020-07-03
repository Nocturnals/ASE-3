//@ts-check

function Post({
    id,
    author_name = "",
    media_urls = []
}) {
    // private variables
    let _id = id;
    let _media_urls = media_urls;
    let _description = "";
    let _hashtags = [];
    let _mentions = [];
    let _author_name = author_name;
    let _date_of_creation = Date.now();
    let _likes_count = 0;
    let _liked_by = [];

    // getters
    this.getId = () => {
        return _id;
    };
    this.getMedia_url = () => {
        return _media_urls;
    };
    this.getDescription = () => {
        return _description;
    };
    this.getHashtags = () => {
        return _hashtags;
    };
    this.getMentions = () => {
        return _mentions;
    };
    this.getAuthor_name = () => {
        return _author_name;
    };
    this.getLikes_count = () => {
        return _likes_count;
    };
    this.getLiked_by = () => {
        return _liked_by;
    };
    this.getDate_of_creation = () => {
        return _date_of_creation;
    };

    // setters
    this.setId = (id) => {
        _id = id;
    };
    this.setMedia_url = (media_urls) => {
        _media_urls = media_urls;
    };
    this.setDescription = (description) => {
        _description = description;
    };
    this.setHashtags = (hashtags) => {
        _hashtags = hashtags;
    };
    this.setMentions = (mentions) => {
        _mentions = mentions;
    };
    this.setAuthor_name = (author_name) => {
        _author_name = author_name;
    };

    this.setLikes_count = (likes_count) => {
        _likes_count = likes_count;
    };

    this.setLiked_by = (liked_by) => {
        _liked_by = liked_by;
    };

    this.setDate_of_creation = (date_of_creation) => {
        _date_of_creation = date_of_creation;
    };

    //function toconvert ot map
    this.toMap = () => {
        const map = {};
        if (_id) {
            map["id"] = _id;
        }

        map["description"] = _description;
        map["media_urls"] = _media_urls;
        map["author_name"] = _author_name;
        map["likes_count"] = _likes_count;
        map["liked_by"] = _liked_by;
        map["date_of_creation"] = _date_of_creation;

        return map;
    };
}

// function to create instance from the firestore data

const PostfromFirestore = ({ mapData, docId }) => {
    const post_instance = new Post({
        id: docId,
        author_name: mapData["author_name"],
        media_urls: mapData["media_urls"]
    });

    post_instance.setDate_of_creation(mapData["date_of_creation"]);
    post_instance.setLikes_count(mapData["likes_count"]);
    post_instance.setDescription(mapData["description"]);
    post_instance.setHashtags(mapData["hashtags"]);
    post_instance.setMentions(mapData["mentions"]);
    post_instance.setLiked_by(mapData["liked_by"]);

    return post_instance;
};

module.exports = { PostModel: Post, PostfromFirestore };
