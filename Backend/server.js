// main package imports here
const express = require("express");

// installed package imports here
const helmet = require("helmet");
const morgan = require("morgan");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");

// imports of routes made by us

// load the local environment varaibles
dotenv.config();

// instance of the main application
const app = express();

// CORS middlewares
var allowCrossDomain = function(req, res, next) {
    // website which can only access this backend server
    res.header("Access-Control-Allow-Origin", "*");

    // Request methods which are allowed to this backend server
    res.header("Access-Control-Allow-Methods", "GET,PUT,POST,DELETE");

    // Request headers which are allowed to this backend server
    res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");

    res.header("Access-Control-Expose-Headers", "*");

    // Pass to next layer
    next();
};

// APPLY MIDDLEWARE HERE
// for converting the json part of the request body
app.use(express.json());
app.use(bodyParser.json());

// for securing the routes with adding headers
app.use(helmet());

// for allowing requests from the frontend or other domains
app.use(allowCrossDomain);

if (process.env.Node_Env === "development") {
    // for logging the infomation
    app.use(morgan("tiny"));

    console.log("Logging the data using morgan");
}

// ROUTES HERE
app.get("/testing", (req, res, next) => {
    console.log("responding");
    res.json({ time: Date.now() });
});

const port = process.env.PORT || 3000; // get the port number from the dotenv file if not 3000
// The listening of the server
let server = app.listen(port, () => {
    console.log(`Server is up and running on port ${port}!!`);
});
