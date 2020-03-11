function BabySitter({ id }) {
    let _babysitter_id = id;
    let _address = null;
    let _status = false;
    let _contact_no = 0;
    let _list_of_pets_accepted_before = [];
    let _current_babysitting_pets = [];
    let _requests_list = [];
    let _payment_details = [];

    //getters

    this.getId = () => {
        return _babysitter_id;
    };

    this.getaddress = () => {
        return _address;
    };

    this.getstatus = () => {
        return _status;
    };

    this.getContact_no = () => {
        return _contact_no;
    };

    this.getList_of_pets_accepted_before = () => {
        return _list_of_pets_accepted_before;
    };

    this.getCurrent_babysitting_pets = () => {
        return _current_babysitting_pets;
    };
    this.getRequestsList = () => {
        return _requests_list;
    };
    this.getPayment_details = () => {
        return _payment_details;
    };

    // setters

    this.setId = id => {
        _babysitter_id = id;
    };
    this.setAddress = address => {
        _address = address;
    };
    this.setStatus = status => {
        _status = status;
    };
    this.setContact_no = contact_no => {
        _contact_no = contact_no;
    };
    this.setList_of_pets_accepted_before = list_of_pets_accepted_before => {
        _list_of_pets_accepted_before = list_of_pets_accepted_before;
    };
    this.setCurrent_babysitting_pets = current_babysitting_pets => {
        _current_babysitting_pets = current_babysitting_pets;
    };
    this.setRequestsList = requests_list => {
        _requests_list = requests_list;
    };
    this.setPayment_details = payment_details => {
        _payment_details = payment_details;
    };

    //function toconvert ot map

    this.toMap = () => {
        const map = {};
        if (_babysitter_id) {
            map["babysitter_id"] = _babysitter_id;
        }
        map["address"] = _address;
        map["status"] = _status;
        map["contact_no"] = _contact_no;
        map["list_of_pets_accepted_before"] = _list_of_pets_accepted_before;
        map["current_babysitting_pets"] = _current_babysitting_pets;
        map["requests_list"] = _requests_list;
        map["payment_details"] = _payment_details;

        return map;
    };
}

// function to create instance from the firestore data

BabySitterfromFirestore = ({ mapData, docId }) => {
    babysitter_instance = new BabySitter({
        babysitter_id: docId
    });

    babysitter_instance.setAddress(mapData["address"]);
    babysitter_instance.setContact_no(mapData["contact_no"]);
    babysitter_instance.setCurrent_babysitting_pets(
        mapData["current_babysitting_pets"]
    );
    babysitter_instance.setList_of_pets_accepted_before(
        mapData["list_of_pets_accepted_before"]
    );
    babysitter_instance.setPayment_details(mapData["payment_details"]);
    babysitter_instance.setRequestsList(mapData["requests_list"]);
    babysitter_instance.setStatus(mapData["status"]);

    return babysitter_instance;
};

module.exports = { BabySitterModel: BabySitter, BabySitterfromFirestore };
