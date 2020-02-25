const Joi = require("@hapi/joi");

module.exports.registerValidation = data => {
    const schema = Joi.object({
        username: Joi.string()
            .min(4)
            .max(255)
            .required(),
        email: Joi.string()
            .min(5)
            .max(255)
            .required()
            .email(),
        password: Joi.string()
            .min(8)
            .max(1024)
            .required()
    });

    return schema.validate(data);
};

module.exports.loginValidation = data => {
    const schema = Joi.object({
        username: Joi.string()
            .min(4)
            .max(255)
            .required(),
        password: Joi.string()
            .min(8)
            .max(1024)
            .required()
    });

    return schema.validate(data);
};
