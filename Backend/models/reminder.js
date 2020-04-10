//@ts-check

function Reminder({ id }) {
    let _reminder_id = id;
    let _user_id = null;
    let _message = null;
    let _time = new Date();
    let _repetition = false;

    //getters

    this.getId = () => {
        return _reminder_id;
    };
    this.getUser_id = () => {
        return _user_id;
    };
    this.getMessage = () => {
        return _message;
    };
    this.getTime = () => {
        return _time;
    };
    this.getRepitition = () => {
        return _repetition;
    };

    //setters

    this.setId = (id) => {
        _reminder_id = id;
    };

    this.setUser_id = (user_id) => {
        _user_id = user_id;
    };

    this.setMessage = (message) => {
        _message = message;
    };

    this.setTime = (time) => {
        _time = time;
    };

    this.setRepitition = (repetition) => {
        _repetition = repetition;
    };

    //function toconvert ot map

    this.toMap = () => {
        const map = {};
        if (_reminder_id) {
            map["reminder_id"] = _reminder_id;
        }
        map["user_id"] = _user_id;
        map["message"] = _message;
        map["time"] = _time;
        map["repetition"] = _repetition;

        return map;
    };
}

// function to create instance from the firestore data

const ReminderfromFirestore = ({ mapData, docId }) => {
    const reminder_instance = new Reminder({
        id: docId,
    });

    reminder_instance.setMessage(mapData["message"]);
    reminder_instance.setRepitition(mapData["repetition"]);
    reminder_instance.setTime(mapData["time"]);
    reminder_instance.setUser_id(mapData["user_id"]);

    return reminder_instance;
};

module.exports = { ReminderModel: Reminder, ReminderfromFirestore };
