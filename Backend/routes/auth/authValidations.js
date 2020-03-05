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

module.exports.EmailIDValidation = data => {
    const schema = Joi.object({
        email: Joi.string()
            .required()
            .email()
    });

    return schema.validate(data);
};

module.exports.passwordValidation = data => {
    const schema = Joi.object({
        password: Joi.string()
            .min(8)
            .pattern(/^[a-zA-Z0-9]{3,30}$/)
    });

    return schema.validate(data);
};

module.exports.findUserValidation = data => {
    const schema = Joi.object({
        name: Joi.string().required()
    });

    return schema.validate(data);
};

module.exports.verifyEmailValidation = data => {
    const schema = Joi.object({
        secret_code: Joi.number()
            .max(100000)
            .required()
    });

    return schema.validate(data);
};

module.exports.verifyForgotPasswordValidation = data => {
    const schema = Joi.object({
        secret_code: Joi.number()
            .max(100000)
            .required(),
        email: Joi.string()
            .email()
            .required(),
        new_password: Joi.string()
            .min(8)
            .pattern(/^[a-zA-Z0-9]{3,30}$/)
    });

    return schema.validate(data);
};
