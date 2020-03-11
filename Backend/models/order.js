function Order({ id }) {
    //private variables

    let _order_id = id;
    let _item_id = null;
    let _date_of_booking = Date.now();
    let _order_status = null;
    let _ordered_by_user = null;
    let _seller_id = null;
    let _payment_details = [];

    // getters

    this.getId = () => {
        return _order_id;
    };

    this.getItem_id = () => {
        return _item_id;
    };

    this.getDate_of_booking = () => {
        return _date_of_booking;
    };

    this.getSeller_id = () => {
        return _seller_id;
    };

    this.getPayment_details = () => {
        return _payment_details;
    };

    this.getOrder_status = () => {
        return _order_status;
    };
    this.getOrdered_by_user = () => {
        return _ordered_by_user;
    };

    // setters

    this.setId = id => {
        _order_id = id;
    };
    this.setOrder_satus = order_status => {
        _order_status = order_status;
    };

    this.setOrdered_by_user = ordered_by_user => {
        _ordered_by_user = ordered_by_user;
    };

    this.setItem_id = item_id => {
        _item_id = item_id;
    };

    this.setPayment_details = payment_details => {
        _payment_details = payment_details;
    };

    this.setSeller_id = seller_id => {
        _seller_id = seller_id;
    };

    this.setDate_of_booking = date_of_booking => {
        _date_of_booking = date_of_booking;
    };

    //function toconvert ot map

    this.toMap = () => {
        const map = {};
        if (_order_id) {
            map["order_id"] = _order_id;
        }
        map["seller_id"] = _seller_id;
        map["payment_details"] = _payment_details;
        map["date_of_booking"] = _date_of_booking;
        map["item_id"] = _item_id;
        map["order_status"] = _order_status;
        map["ordered_by_user"] = _ordered_by_user;

        return map;
    };
}

// function to create instance from the firestore data

OrderfromFirestore = ({ mapData, docId }) => {
    order_instance = new Order({
        order_id: docId
    });

    order_instance.setItem_id(mapData["item_id"]);
    order_instance.setDate_of_booking(mapData["date_of_booking"]);
    order_instance.setOrder_satus(mapData["order_status"]);
    order_instance.setOrdered_by_user(mapData["ordered_by_user"]);
    order_instance.setPayment_details(mapData["payment_details"]);
    order_instance.setSeller_id(mapData["seller_id"]);

    return order_instance;
};

module.exports = { OrderModel: Order, OrderfromFirestore };
