const database = require("./database");

// reference to the collection
let coll_ref = database.collection("reminder");

module.exports.createReminder = async reminderMap => {
    const new_reminder_ref = await coll_ref.add(reminderMap);
    return new_reminder_ref;
};

module.exports.updateReminder = async reminderMap =>{
    const update_reminder_ref = await coll_ref.doc(reminderMap["reminder_id"]).update(reminderMap);
    return update_reminder_ref;
};

module.exports.deleteReminder = async id =>{
    return await coll_ref.doc(id).delete();
};

module.exports.getReminderViaId = async id =>{
    const get_reminder = await coll_ref.doc(id).get();
    return get_reminder;
};

module.exports.getReminderViaUserId = async id =>{
    const get_reminder = await coll_ref.where("user_id", "==", id).get();
    if (get_reminder) return false;

    return get_reminder
}