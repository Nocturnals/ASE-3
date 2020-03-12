const functions = require('firebase-functions');
const express = require('express')
const {ctrlLogin, ctrlRead, ctrlCreate, ctrlUpdate, ctrlDelete} = require('./controller');