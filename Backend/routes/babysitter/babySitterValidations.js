// @ts-check

const Joi = require("@hapi/joi");

module.exports.registerValidation = (data) => {
    const schema = Joi.object({
        address: Joi.object().required(),
        contact_no: Joi.number().max(10000000000).min(5000000000).required(),
    });

    return schema.validate(data);
};
