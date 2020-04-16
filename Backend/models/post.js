//@ts-check

function Post({
    id,
    author_id = null,
    media_urls = null
}) {
    // private variables
    let _post_id = id;
    let _media_urls = media_urls;
    let _description = null;
    let _hashtags = [];
    let _mentions = [];
    let _author_id = author_id;
    let _date_of_creation = Date.now();
    let _likes_count = 0;
    let _liked_by = [];

    // getters
    this.getId = () => {
        return _post_id;
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
    this.getAuthor_id = () => {
        return _author_id;
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
        _post_id = id;
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
    this.setAuthor_id = (author_id) => {
        _author_id = author_id;
    };

    this.setLikes_count = (likes_count) => {
        _likes_count = likes_count;
    };

    this.setLiked_by = (liked_by) => {
        _liked_by = liked_by;
    };
    // this.removeLiked_by = unliked_by => {
    //     _liked_by.splice(_liked_by.indexOf(unliked_by), 1);
    // };

    this.setDate_of_creation = (date_of_creation) => {
        _date_of_creation = date_of_creation;
    };

    //function toconvert ot map

    this.toMap = () => {
        const map = {};
        if (_post_id) {
            map["post_id"] = _post_id;
        }

        map["description"] = _description;
        map["media_urls"] = _media_urls;
        map["author_id"] = _author_id;
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
    });

    post_instance.setAuthor_id(mapData["author_id"]);
    post_instance.setDate_of_creation(mapData["date_of_creation"]);
    post_instance.setLikes_count(mapData["likes_count"]);
    post_instance.setMedia_url(mapData["media_urls"]);
    post_instance.setDescription(mapData["description"]);
    post_instance.setHashtags(mapData["hashtags"]);
    post_instance.setMentions(mapData["mentions"]);
    post_instance.setLiked_by(mapData["liked_by"]);

    return post_instance;
};

module.exports = { PostModel: Post, PostfromFirestore };
