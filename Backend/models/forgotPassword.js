function ForgotPassword({ id, email, secret_code }) {
    // private variables
    let _id = id;
    const _email = email;
    const _secret_code = secret_code;
    let _deadline = new Date();
    _deadline.setDate(_deadline.getDate() + 1); // to get the next day date

    // getters here
    this.getid = () => {
        return _id;
    };
    this.getEmail = () => {
        return _email;
    };
    this.getSecret_code = () => {
        return _secret_code;
    };
    this.getDeadline = () => {
        return _deadline;
    };

    // setters here
    this.setDeadline = deadline => {
        _deadline = deadline;
    };

    // function to convert to map data
    this.toMap = () => {
        const map = {};
        if (_id) {
            map["id"] = _id;
        }
        map["email"] = _email;
        map["secret_code"] = _secret_code;
        map["deadline"] = _deadline;

        return map;
    };
}

// function to create instance from the firestore data
const ForgotPasswordFromFirestore = ({ mapData, docId }) => {
    let email_verification_instance = new ForgotPassword({
        id: docId,
        email: mapData["email"],
        secret_code: mapData["secret_code"]
    });

    email_verification_instance.setDeadline(mapData["deadline"]);
    return email_verification_instance;
};

module.exports = {
    ForgotPasswordModel: ForgotPassword,
    ForgotPasswordFromFirestore
};
