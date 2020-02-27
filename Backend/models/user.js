function User({ id, username, email }) {
    // private variables
    let _id = id;
    const _username = username;
    const _email = email;
    let _password = null;
    let _age = null;
    let _pets_count = 0;
    let _pet_ids = [];
    let _post_ids = [];
    let _followers = [];
    let _following = [];
    let _liked_post_ids = [];
    let _fav_animals_ids = [];
    let _order_ids = [];
    let _remainder_ids = [];

    // getters here
    this.getId = () => {
        return _id;
    };
    this.getUsername = () => {
        return _username;
    };
    this.getEmail = () => {
        return _email;
    };
    this.getAge = () => {
        return _age;
    };
    this.getPets_count = () => {
        return _pets_count;
    };
    this.getPet_ids = () => {
        return _pet_ids;
    };
    this.getPost_ids = () => {
        return _post_ids;
    };
    this.getFollowers = () => {
        return _followers;
    };
    this.getFollowing = () => {
        return _following;
    };
    this.getLiked_post_ids = () => {
        return _liked_post_ids;
    };
    this.getFav_animals_ids = () => {
        return _fav_animals_ids;
    };
    this.getOrder_ids = () => {
        return _order_ids;
    };
    this.getRemainder_ids = () => {
        return _remainder_ids;
    };

    // setters here
    this.setPassword = password => {
        _password = password;
    };
    this.setAge = age => {
        _age = age;
    };
    this.setPets_count = pets_count => {
        _pets_count = pets_count;
    };
    this.setPet_ids = pet_ids => {
        _pet_ids = pet_ids;
    };
    this.setPost_ids = post_ids => {
        _post_ids = post_ids;
    };
    this.setFollowers = followers => {
        _followers = followers;
    };
    this.setFollowing = following => {
        _following = following;
    };
    this.setLiked_post_ids = liked_post_ids => {
        _liked_post_ids = liked_post_ids;
    };
    this.setFav_animals_ids = fav_animals_ids => {
        _fav_animals_ids = fav_animals_ids;
    };
    this.setOrder_ids = order_ids => {
        _order_ids = order_ids;
    };
    this.setRemainder_ids = remainder_ids => {
        _remainder_ids = remainder_ids;
    };

    // function to convert tomap
    this.toMap = () => {
        const map = {};
        if (_id) {
            map["id"] = _id;
        }
        map["username"] = _username;
        map["email"] = _email;
        map["password"] = _password;
        if (_age) {
            map["age"] = _age;
        }
        map["pets_count"] = _pets_count;
        map["pet_ids"] = _pet_ids;
        map["post_ids"] = _post_ids;
        map["followers"] = _followers;
        map["following"] = _following;
        map["liked_post_ids"] = _liked_post_ids;
        map["fav_animals_ids"] = _fav_animals_ids;
        map["order_ids"] = _order_ids;
        map["remainder_ids"] = _remainder_ids;

        return map;
    };
}

// function to create instance from the firestore data
UserfromFirestore = ({ mapData, docId }) => {
    user_instance = new User({
        id: docId,
        username: mapData["username"],
        email: mapData["email"]
    });

    user_instance.setPassword(mapData["password"]);
    user_instance.setAge(mapData["age"]);
    user_instance.setPets_count(mapData["pets_count"]);
    user_instance.setPet_ids(mapData["pet_ids"]);
    user_instance.setPost_ids(mapData["post_ids"]);
    user_instance.setFollowers(mapData["followers"]);
    user_instance.setFollowing(mapData["following"]);
    user_instance.setLiked_post_ids(mapData["liked_post_ids"]);
    user_instance.setFav_animals_ids(mapData["fav_animals_ids"]);
    user_instance.setOrder_ids(mapData["order_ids"]);
    user_instance.setRemainder_ids(mapData["remainder_ids"]);

    return user_instance;
};

module.exports = { UserModel: User, UserfromFirestore };
