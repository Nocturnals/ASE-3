//@ts-check

function PopularPosts({
    id
}) {
    // private variables
    let _id = id;
    let _post_ids = [];
    let _last_modified_time = new Date(Date.now());

    // getters
    this.getId = () => {
        return _id;
    };
    this.getPost_ids = () => {
        return _post_ids;
    }
    this.getLast_modified_time = () => {
        return _last_modified_time;
    }

    // setters
    this.setId = (id) => {
        _id = id;
    };
    this.setPost_ids = (post_ids) => {
        _post_ids = post_ids;
    };
    this.setLast_modified_time = (last_modified_time) => {
        _last_modified_time = last_modified_time;
    }

    //function toconvert ot map
    this.toMap = () => {
        const map = {};
        if (_id) {
            map["id"] = _id;
        }

        map["post_ids"] = _post_ids;
        map["last_modified_time"] = _last_modified_time;

        return map;
    };
}

// function to create instance from the firestore data

const PopularPostsfromFirestore = ({ mapData, docId }) => {
    const popularPosts_instance = new PopularPosts({
        id: docId
    });

    popularPosts_instance.setPost_ids(mapData["post_ids"]);
    popularPosts_instance.setLast_modified_time(mapData["last_modified_time"]);

    return popularPosts_instance;
};

module.exports = { PopularPostsModel: PopularPosts, PopularPostsfromFirestore };
