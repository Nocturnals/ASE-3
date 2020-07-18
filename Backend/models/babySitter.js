//@ts-check

const { AddressModel, AddressFromFirestore } = require("./address");

/**
 * BabySitter model class
 * @param {object} object takes id as input 
 */
function BabySitter({ id }) {
    let _babysitter_id = id;
    let _address = new AddressModel();
    let _status = true;
    let _contact_no = null;
    let _list_of_pets_accepted_before = [];
    let _current_babysitting_pets = [];
    let _requests_list = [];
    let _payment_details = [];

    //getters
    /**Gets the id of the babysitter */
    this.getId = () => {
        return _babysitter_id;
    };

    /**
     * Gets the address of the babysitter
     * @returns Address model of the babysitter
     */
    this.getaddress = () => {
        return _address;
    };

    /**Gets the current status of the babysitter */
    this.getstatus = () => {
        return _status;
    };

    /**Gets the contact number of the baby sitter */
    this.getContact_no = () => {
        return _contact_no;
    };

    /**Gets the list of pets this babysitter has baby sitted with from the start of time */
    this.getList_of_pets_accepted_before = () => {
        return _list_of_pets_accepted_before;
    };

    /**Gets the current babysitting pets if any */
    this.getCurrent_babysitting_pets = () => {
        return _current_babysitting_pets;
    };

    /**Gets the list of baby sitter requests pending for now */
    this.getRequestsList = () => {
        return _requests_list;
    };

    /**
     * Gets the payment details of baby sitter
     */
    this.getPayment_details = () => {
        return _payment_details;
    };

    // setters

    /**
     * Sets the id of the baby sitter
     * @param {string} id - The id to which the babys sitter has to be changed
     */
    this.setId = (id) => {
        _babysitter_id = id;
    };

    /**
     * Sets the address of the baby sitter
     * @param {any} address 
     */
    this.setAddress = (address) => {
        _address = address;
    };

    /**
     * Sets the status of the baby sitter wheather the baby sitter is available or not
     * @param {boolean} status true means the baby sitter is available or else not
     */
    this.setStatus = (status) => {
        _status = status;
    };

    /**
     * Sets the contact number of the baby sitter 
     * @param {number} contact_no the number of the babysitter
     */
    this.setContact_no = (contact_no) => {
        _contact_no = contact_no;
    };

    /**
     * Sets the new list of list of pets accepted before
     * @param {object} list_of_pets_accepted_before 
     */
    this.setList_of_pets_accepted_before = (list_of_pets_accepted_before) => {
        _list_of_pets_accepted_before = list_of_pets_accepted_before;
    };

    /**
     * Sets the current pets baby sitting by the baby sitter
     * @param {object} current_babysitting_pets 
     */
    this.setCurrent_babysitting_pets = (current_babysitting_pets) => {
        _current_babysitting_pets = current_babysitting_pets;
    };

    /**
     * Sets the list of request came for the baby sitter
     * @param {object} requests_list 
     */
    this.setRequestsList = (requests_list) => {
        _requests_list = requests_list;
    };

    /**
     * Sets the payment details of the babysitter
     * @param {object} payment_details 
     */
    this.setPayment_details = (payment_details) => {
        _payment_details = payment_details;
    };

    //function toconvert ot map

    /**
     * Converts the model to map
     */
    this.toMap = () => {
        const map = {};
        if (_babysitter_id) {
            map["babysitter_id"] = _babysitter_id;
        }
        map["address"] = _address.toMap();
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
/**
 * Converts the mapdata to babysitter model 
 * @param {object} param0 object with mapData and docId
 */
const BabySitterfromFirestore = ({ mapData, docId }) => {
    const babysitter_instance = new BabySitter({
        id: docId,
    });

    babysitter_instance.setAddress(AddressFromFirestore(mapData["address"]));
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
