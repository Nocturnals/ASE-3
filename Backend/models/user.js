function User({ username, email, password }) {
    const _username = username;
    const _email = email;
    let _password = password;

    // getters here
    this.get_username = () => {
        return _username;
    };
    this.get_email = () => {
        return _email;
    };

    // setters here
    this.set_password = password => {
        _password = password;
    };

    // function to convert tomap
    this.toMap = () => {
        const map = {};
        map["username"] = _username;
        map["email"] = _email;
        map["password"] = _password;

        return map;
    };
}

module.exports = User;
