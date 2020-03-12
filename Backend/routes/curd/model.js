const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);
const db = admin.firestore();
const {collectionName} = require('./config');

const addDoc = {
    tasks: (doc, newItem) => {
        newItem.id = ++doc.data.index;
        doc.data.list.push(newItem);
        return setFirebaseDoc(doc);
    },
    days: (doc, newItem) => {
        doc.data = Object.assign({}, doc.data, newItem)
        return setFirebaseDoc(doc);
    },
    users: (doc, newItem) => {
        if( ! doc.data.list ) {
            doc.data.list = [];
        }
        doc.data.list.push(newItem);
        return setFirebaseDoc(doc);
    }
}

const updateDoc = {
    tasks: (doc, updatedItem, id) => {
        delete updatedItem.id;
        doc.data.list = doc.data.list
            .map( task => ( task.id == id ) ? Object.assign({}, task, updatedItem) : task )
        return setFirebaseDoc(doc);
    },
    days: (doc, updatedItem, id) => {
        doc.data[id] = updatedItem;
        return setFirebaseDoc(doc);
    }
}

const deleteDoc = {
    tasks: (doc, id) => {
        doc.data.list = doc.data.list
            .filter( task => task.id != id )
        return setFirebaseDoc(doc);
    },
    days: (doc, id) => {
        delete doc.data[id];
        return setFirebaseDoc(doc);
    }
}

exports.checkLogin = pwd => 
    getFirebaseDoc('users')
        .then( data => {
            return data.data.list.some( doc => doc.pwd == pwd ) 
        });

exports.getDocNames = () => getAllFirebaseDocsIds();

exports.getDoc = docName => getFirebaseDoc(docName)

exports.createDoc = (doc, newItem) =>
    addDoc[doc.id](doc, newItem)

exports.updateDoc = (doc, updatedItem, id) => 
    updateDoc[doc.id](doc, updatedItem, id)

exports.deleteDoc = (doc, id) =>
    deleteDoc[doc.id](doc, id)

async function getAllFirebaseDocsIds() {
    let ids = [];
    let snapshot = await db.collection(collectionName).get();
    snapshot.forEach( doc => ids.push(doc.id) );
    return ids;
}

async function getFirebaseDoc(docName) {
    try {
        let res = {
            id: docName
        };
        let snapshot = await db.collection(collectionName).get();
        snapshot.forEach( doc => {
            if(doc.id == docName) {
                res.data = doc.data();
            }
        });
        return res;
    } catch(err) {
        throw err;
    }
};

async function setFirebaseDoc(updatedDoc) {
    try {
        let docRef = db.collection(collectionName).doc(updatedDoc.id);
        await docRef.set(updatedDoc.data);
        return updatedDoc;
    } catch(err) {
        throw err;
    }
}