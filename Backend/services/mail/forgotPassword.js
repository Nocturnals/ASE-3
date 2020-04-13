//@ts-check

const nodemailer = require("nodemailer");

let transporter = nodemailer.createTransport({
    service: "Gmail",
    auth: {
        user: process.env.MAIL_ID,
        pass: process.env.MAIL_PASSWORD,
    },
    tls: {
        rejectUnauthorized: false,
    },
});

module.exports = (email, code) => {
    var mailOptions = {
        from: process.env.MAIL_ID,
        to: email,
        subject: "Password reset request for PetS account",
        text: `Your secret code is: ${code}`,
    };

    transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
            console.log(error);
        } else {
            console.log("Email sent: " + info.response);
        }
    });
};
