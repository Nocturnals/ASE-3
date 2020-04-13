//@ts-check

const Joi = require("@hapi/joi");

module.exports.postValidation = (data) => {
    const schema = Joi.object({
        media_urls: Joi.array().items(Joi.string()).min(1).required(),
        description: Joi.string().min(0).max(1500),
        hashtags: Joi.array()
            .min(0)
            .max(30)
            .items(
                Joi.string()
                    .min(2)
                    .pattern(/^#[a-zA-Z0-9]/)
            ),
        mentions: Joi.array()
            .min(0)
            .items(
                Joi.string()
                    .min(2)
                    .pattern(/^@[a-zA-Z0-9]/)
            ),
    });

    return schema.validate(data);
};

module.exports.mentionValidation = (data) => {
    const schema = Joi.object({
        mentions: Joi.string()
            .min(2)
            .pattern(/^#[a-zA-Z0-9]/),
    });

    return schema.validate(data);
};
