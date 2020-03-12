function DeliveryPerson({ id }) {
    // private variables/

    let _delivery_person_id = id;
    let _user_id = null;
    let _list_of_deliveries = [];
    let _completed_deliveries = [];
    let _ongoing_deliveries = [];
    let _payment_details = [];

    // getters

    this.getId = () => {
        return _delivery_person_id;
    };

    this.getUser_id = () => {
        return _user_id;
    };
    this.getList_of_deliveries = () => {
        return _list_of_deliveries;
    };
    this.getCompleted_deliveries = () => {
        return _completed_deliveries;
    };
    this.getOngoing_deliveries = () => {
        return _ongoing_deliveries;
    };

    this.getPayment_details = () => {
        return _payment_details;
    };

    //setters

    this.setId = id => {
        _delivery_person_id = id;
    };

    this.setPayment_details = payment_details => {
        _payment_details = payment_details;
    };

    this.setUser_id = user_id => {
        _user_id = user_id;
    };

    this.setOngoingDeliveries = ongoing_deliveries => {
        _ongoing_deliveries = ongoing_deliveries;
    };
    this.setCompleted_deliveries = completed_deliveries => {
        _completed_deliveries = completed_deliveries;
    };
    this.setList_of_deliveries = list_of_deliveries => {
        _list_of_deliveries = list_of_deliveries;
    };

    //function toconvert ot map

    this.toMap = () => {
        const map = {};
        if (_delivery_person_id) {
            map["delivery_person_id"] = _delivery_person_id;
        }

        map["list_of_deliveries"] = _list_of_deliveries;
        map["completed_deliveries"] = _completed_deliveries;
        map["ongoing_deliveries"] = _ongoing_deliveries;
        map["payment_details"] = _payment_details;

        return map;
    };
}

const DeliveryPersonfromFirestore = ({ mapData, docId }) => {
    const delivery_person_instance = new DeliveryPerson({
        deliveryPerson_id: docId
    });

    delivery_person_instance.setCompleted_deliveries(
        mapData["completed_deliveries"]
    );
    delivery_person_instance.setList_of_deliveries(
        mapData["list_of_deliveries"]
    );
    delivery_person_instance.setOngoingDeliveries(
        mapData["ongoing_deliveries"]
    );
    delivery_person_instance.setUser_id(mapData["user_id"]);
    delivery_person_instance.setPayment_details(mapData["payment_details"]);

    return delivery_person_instance;
};

module.exports = {
    DeliveryPersonModel: DeliveryPerson,
    DeliveryPersonfromFirestore
};
