function ShoppingItem({ id }) {
    let _shoppingitem_id = id;
    let _animal_types = [];
    let _price = 0;
    let _seller_id = null;
    let _payment_details = [];

    //getters

    this.getId = () => {
        return _shoppingitem_id;
    };

    this.getAnimaltypes = () => {
        return _animal_types;
    };
    this.getPrice = () => {
        return _price;
    };
    this.getSeller_id = () => {
        return _seller_id;
    };
    this.getPayment_details = () => {
        return _payment_details;
    };

    //setters

    // setters

    this.setId = id => {
        _shoppingitem_id = id;
    };

    this.setAnimal_types = animal_types => {
        _animal_types = animal_types;
    };

    this.setPrice = price => {
        _price = price;
    };

    this.setSeller_id = seller_id => {
        _seller_id = seller_id;
    };

    this.setPayment_details = payment_details => {
        _payment_details = payment_details;
    };

    //function toconvert ot map
    this.toMap = () => {
        const map = {};
        if (_shoppingitem_id) {
            map["shoppingitem_id"] = _shoppingitem_id;
        }

        map["seller_id"] = _seller_id;
        map["payment_details"] = _payment_details;
        map["animal_types"] = _animal_types;
        map["price"] = _price;

        return map;
    };
}

// function to create instance from the firestore data
const ShoppingItemfromFirestore = ({ mapData, docId }) => {
    const shoppingitem_instance = new ShoppingItem({
        shoppingitem_id: docId
    });

    shoppingitem_instance.setAnimal_types(mapData["animal_types"]);
    shoppingitem_instance.setPayment_details(mapData["payment_details"]);
    shoppingitem_instance.setPrice(mapData["price"]);
    shoppingitem_instance.setSeller_id(mapData["seller_id"]);

    return shoppingitem_instance;
};

module.exports = { ShoppingItemModel: ShoppingItem, ShoppingItemfromFirestore };
