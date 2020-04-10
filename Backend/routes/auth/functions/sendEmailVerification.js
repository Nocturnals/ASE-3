//@ts-check

const { sendEmailToVerifyEmail } = require("../helper");

module.exports = async (req, res) => {
    try {
        await sendEmailToVerifyEmail(req.loggedUser);
        return res.status(200).json({
            message:
                "Email verification sent successfully check your mail for code",
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({ message: "Internal server error" });
    }
};
