function RequestForBabysitting({ id }) {
    let _request_for_babysitting_id = _id;
    let _request_user_id = null;
    let _request_for_babysitter_id = null;
    let _pet_type = null;
    let _extra_notes = null;
    let _food_types = null;
    let _no_of_days = 0;
    let _start_date = new Date();
    let _service_fee = 0;
    let _payment_details = [];

    // getters

    this.getId = () => {
        return _request_for_babysitting_id;
    };

    this.getRequest_for_babysitter_id = () => {
        return _request_for_babysitter_id;
    };
    this.getRequest_user_id = () => {
        return _request_user_id;
    };

    this.getPet_type = () => {
        return _pet_type;
    };

    this.getExtra_notes = () => {
        return _extra_notes;
    };
    this.getFood_types = () => {
        return _food_types;
    };
    this.getNo_of_days = () => {
        return _no_of_days;
    };
    this.getStart_date = () => {
        return _start_date;
    };
    this.getService_fee = () => {
        return _service_fee;
    };
    this.getPayment_details = () => {
        return _payment_details;
    };

    //setters

    this.setId = id => {
        _request_for_babysitting_id = id;
    };

    this.setRequest_user_id = user_id => {
        _request_user_id = user_id;
    };
    this.setRequest_for_babysitter_id = id => {
        _request_for_babysitter_id = id;
    };
    this.setPet_type = pet_type => {
        _pet_type = pet_type;
    };
    this.setExtra_notes = notes => {
        _extra_notes = notes;
    };
    this.setFood_types = types => {
        _food_types = types;
    };

    this.setNo_of_days = no_of_days => {
        _no_of_days = no_of_days;
    };
    this.setStart_date = date => {
        _start_date = date;
    };
    this.setService_fee = fee => {
        _service_fee = fee;
    };
    this.setPayment_details = payment_details => {
        _payment_details = payment_details;
    };
    //function toconvert ot map

    this.toMap = () => {
        const map = {};
        if (_request_for_babysitting_id) {
            map["request_for_babysitting_id"] = _request_for_babysitting_id;
        }

        map["_request_user_id"] = _request_user_id;
        map["_request_for_babysitter_id"] = _request_for_babysitter_id;
        map["pet_type"] = _pet_type;
        map["extra_notes"] = _extra_notes;
        map["food_types"] = _food_types;
        map["no_of_days"] = _no_of_days;
        map["start_date"] = _start_date;
        map["service_fee"] = _service_fee;
        map["payment_details"] = _payment_details;

        return map;
    };
}

// function to create instance from the firestore data
const RequestForBabysittingfromFirestore = ({ mapData, docId }) => {
    const request_for_babysitting_instance = new RequestForBabysitting({
        request_for_babysitting_id: docId
    });

    request_for_babysitting_instance.setExtra_notes(mapData["extra_notes"]);
    request_for_babysitting_instance.setFood_types(mapData["food_types"]);
    request_for_babysitting_instance.setNo_of_days(mapData["no_of_days"]);
    request_for_babysitting_instance.setPayment_details(
        mapData["payment_details"]
    );
    request_for_babysitting_instance.setPet_type(mapData["pet_type"]);
    request_for_babysitting_instance.setRequest_for_babysitter_id(
        mapData["request_for_babysitter_id"]
    );
    request_for_babysitting_instance.setRequest_user_id(
        mapData["request_user_id"]
    );
    request_for_babysitting_instance.setService_fee(mapData["service_fee"]);
    request_for_babysitting_instance.setStart_date(mapData["start_date"]);

    return request_for_babysitting_instance;
};

module.exports = {
    RequestForBabysittingModel: RequestForBabysitting,
    RequestForBabysittingfromFirestore
};
