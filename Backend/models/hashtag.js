function Hashtag({ id, hashtag_name }) {
    // private variables
    let _id = id;
    let _hashtag_name = hashtag_name;
    let _post_ids = [];

    // getters

    this.getId = () => {
        return _id;
    };

    this.getHashtag_name = () => {
        return _hashtag_name;
    };

    this.getPost_ids = () => {
        return _post_ids;
    };

    // setters

    this.setId = id => {
        _id = id;
    };

    this.setHashtag_name = hashtag_name => {
        _hashtag_name = hashtag_name;
    }

    this.setPost_ids = post_ids => {
        _post_ids = post_ids;
    }

    //function to convert ot map

    this.toMap = () => {
        const map = {};
        if (_id) {
            map["id"] = _id;
        }
        map["hashtag_name"] = _hashtag_name;
        map["post_ids"] = _post_ids;

        return map;
    };
}

// function to create instance from the firestore data

const HashtagfromFirestore = ({ mapData, docId }) => {
    const hashtag_instance = new Hashtag({
        id: docId,
        hashtag_name: mapData["hashtag_name"]
    });

    hashtag_instance.setPost_ids(mapData["post_ids"]);

    return hashtag_instance;
};

module.exports = { HashtagModel: Hashtag, HashtagfromFirestore };
