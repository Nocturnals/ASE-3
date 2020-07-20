// @ts-check

const Joi = require("@hapi/joi");

module.exports.registerValidation = (data) => {
    const schema = Joi.object({
        lane: Joi.string().required(),
        street: Joi.string().required(),
        city: Joi.string().required(),
        state: Joi.string().required(),
        country: Joi.string().required(),
        postal_code: Joi.string().required(),
        contact_no: Joi.number().max(10000000000).min(5000000000).required(),
    });

    return schema.validate(data);
};
