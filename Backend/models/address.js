//@ts-check

const { required } = require("@hapi/joi");

/**
 * The Address model class
 */
function Address() {
    let _lane = '';
    let _street = '';
    let _city = '';
    let _state = '';
    let _country = '';
    let _postalCode = '';

    // getters
    /**
     * Getter of address instance function
     * @returns lane value of the address instance
     */
    this.getLane = () => {
        return _lane;
    };

    /**
     * Getter of address instance function
     * @returns street value of the address instance
     */
    this.getStreet = () => {
        return _street;
    };

    /**
     * Getter of address instance function
     * @returns city value of the address instance
     */
    this.getCity = () => {
        return _city;
    };

    /**
     * Getter of address instance function
     * @returns state value of the address instance
     */
    this.getState = () => {
        return _state;
    };

    /**
     * Getter of address instance function
     * @returns country value of the address instance
     */
    this.getCountry = () => {
        return _country;
    };

    /**
     * Getter of address instance function
     * @returns postalCode value of the address instance
     */
    this.getPostalCode = () => {
        return _postalCode;
    };

    // setters here
    /**
     * Setter for the lane value of address instance
     * @param {string} lane 
     */
    this.setLane = (lane) => {
        _lane = lane;
    };

    /**
     * Setter for the lane value of address instance
     * @param {string} street 
     */
    this.setStreet = (street) => {
        _street = street;
    };

    /**
     * Setter for the lane value of address instance
     * @param {string} city 
     */
    this.setCity = (city) => {
        _city = city;
    };

    /**
     * Setter for the lane value of address instance
     * @param {string} state 
     */
    this.setState = (state) => {
        _state = state;
    };

    /**
     * Setter for the lane value of address instance
     * @param {string} country 
     */
    this.setCountry = (country) => {
        _country = country;
    };

    /**
     * Setter for the lane value of address instance
     * @param {string} postalCode 
     */
    this.setPostalCode = (postalCode) => {
        _postalCode = postalCode;
    };


    /**
     * function to convert to map
     * @requires map of the values of the address instance
     */
    this.toMap = () => {
        const map = {};
        map['lane'] = _lane;
        map['street'] = _street;
        map['city'] = _city;
        map['state'] = _state;
        map['country'] = _country;
        map['postal_code'] = _postalCode;

        return map;
    };
}

/**
 * function to create instance from the firestore data
 * @param {*} param0 
 * @returns the address instance created with the map data
 */
const AddressFromFirestore = ({ mapData }) => {
    const address_instance = new Address();
    address_instance.setLane(mapData['lane']);
    address_instance.setStreet(mapData['street']);
    address_instance.setCity(mapData['city']);
    address_instance.setState(mapData['state']);
    address_instance.setCountry(mapData['country']);
    address_instance.setPostalCode(mapData['postal_code']);

    return address_instance;
};

module.exports = { AddressModel: Address, AddressFromFirestore };
