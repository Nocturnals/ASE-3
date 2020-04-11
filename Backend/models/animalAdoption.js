//@ts-check

function AnimalAdoption({ id }) {
    let _animal_adoption_id = id;
    let _animal_id = null;
    let _animal_type = null;
    let _age = 0;
    let _posts = [];
    let _adopted_by = null;
    let _adopted_from = null;
    let _date_of_adoption = new Date();

    // getters

    this.getId = () => {
        return _animal_adoption_id;
    };

    this.getAnimal_id = () => {
        return _animal_id;
    };

    this.getAnimal_type = () => {
        return _animal_type;
    };

    this.getAge = () => {
        return _age;
    };

    this.getPosts = () => {
        return _posts;
    };

    this.getAdopted_by = () => {
        return _adopted_by;
    };

    this.getAdopted_from = () => {
        return _adopted_from;
    };

    this.getDate_of_adoption = () => {
        return _date_of_adoption;
    };

    //setters

    this.setId = (id) => {
        _animal_adoption_id = id;
    };

    this.setAnimal_id = (animal_id) => {
        _animal_id = animal_id;
    };
    this.setAnimal_type = (animal_type) => {
        _animal_type = animal_type;
    };
    this.setAge = (age) => {
        _age = age;
    };
    this.setPosts = (posts) => {
        _posts = posts;
    };
    this.setAdopted_by = (adopted_by) => {
        _adopted_by = adopted_by;
    };
    this.setAdopted_from = (adopted_from) => {
        _adopted_from = adopted_from;
    };
    this.setDate_of_adoption = (date_of_adoption) => {
        _date_of_adoption = date_of_adoption;
    };

    //function toconvert ot map

    this.toMap = () => {
        const map = {};
        if (_animal_adoption_id) {
            map["animal_adoption_id"] = _animal_adoption_id;
        }
        map["animal_id"] = _animal_id;
        map["animal_type"] = _animal_type;
        map["age"] = _age;
        map["posts"] = _posts;
        map["adopted_by"] = _adopted_by;
        map["adopted_from"] = _adopted_from;
        map["date_of_adoption"] = _date_of_adoption;

        return map;
    };
}

// function to create instance from the firestore data
const AnimalAdoptionfromFirestore = ({ mapData, docId }) => {
    const animal_adoption_instance = new AnimalAdoption({
        id: docId,
    });

    animal_adoption_instance.setAdopted_by(mapData["adopted_by"]);
    animal_adoption_instance.setAdopted_from(mapData["adopted_from"]);
    animal_adoption_instance.setAge(mapData["age"]);
    animal_adoption_instance.setAnimal_id(mapData["animal_id"]);
    animal_adoption_instance.setAnimal_type(mapData["animal_type"]);
    animal_adoption_instance.setDate_of_adoption(mapData["date_of_adoption"]);
    animal_adoption_instance.setPosts(mapData["posts"]);

    return animal_adoption_instance;
};

module.exports = {
    AnimalAdoptionModel: AnimalAdoption,
    AnimalAdoptionfromFirestore,
};
