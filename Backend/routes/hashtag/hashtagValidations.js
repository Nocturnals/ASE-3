//@ts-check

const Joi = require("@hapi/joi");

module.exports.hashtagsValidation = (data) => {
    const schema = Joi.object({
        hashtags: Joi.array().items(
            Joi.string()
                .min(2)
                .pattern(/^#[a-zA-Z0-9]/)
        ),
    });

    return schema.validate(data);
};

module.exports.hashtagValidation = (data) => {
    const schema = Joi.object({
        hashtags: Joi.string()
            .min(2)
            .pattern(/^#[a-zA-Z0-9]/),
    });

    return schema.validate(data);
};