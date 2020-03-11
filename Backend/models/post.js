function Post({ id }) {
    // private variables
    let _post_id = id;
    let _media_url = null;
    let _author_id = null;
    let _date_of_creation = Date.now();
    let _likes_count = 0;
    let _liked_by = [];

    // getters

    this.getId = () => {
        return _post_id;
    };

    this.getMedia_url = () => {
        return _media_url;
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

    this.setId = id => {
        _post_id = id;
    };

    this.setMedia_url = media_url => {
        _media_url = media_url;
    };

    this.setAuthor_id = author_id => {
        _author_id = author_id;
    };

    this.setLikes_count = likes_count => {
        _likes_count = likes_count;
    };

    this.setliked_by = liked_by => {
        _liked_by = liked_by;
    };

    this.setDate_of_creation = date_of_creation => {
        _date_of_creation = date_of_creation;
    };

    //function toconvert ot map

    this.toMap = () => {
        const map = {};
        if (_post_id) {
            map["post_id"] = _post_id;
        }

        map["media_url"] = _media_url;
        map["author_id"] = _author_id;
        map["likes_count"] = _likes_count;
        map["liked_by"] = _liked_by;
        map["date_of_creation"] = _date_of_creation;

        return map;
    };
}

// function to create instance from the firestore data

PostfromFirestore = ({ mapData, docId }) => {
    post_instance = new Post({
        post_id: docId
    });

    post_instance.setAuthor_id(mapData["author_id"]);
    post_instance.setDate_of_creation(mapData["date_of_creation"]);
    post_instance.setLikes_count(mapData["likes_count"]);
    post_instance.setMedia_url(mapData["media_url"]);
    post_instance.setliked_by(mapData["liked_by"]);

    return post_instance;
};

module.exports = { PostModel: Post, PostfromFirestore };
