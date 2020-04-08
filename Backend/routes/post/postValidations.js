const Joi = require("@hapi/joi");

module.exports.postValidation = data => {
    const schema = Joi.object({
        media_url: Joi.array()
            .items(Joi.string())
            .min(1)
            .required(),
        description: Joi.string()
            .min(0)
            .max(500),
        hashtags: Joi.array()
            .min(0)
            .max(30)
            .items(Joi.string().min(2).pattern(/^#[a-zA-Z0-9]{2}/)),
        mentions: Joi.array()
            .min(0)
            .items(Joi.string().min(2).pattern(/^@[a-zA-Z0-9]{2}/)),
    });

    return schema.validate(data);
}

module.exports.hashtagValidation = data => {
    const schema = Joi.object({
        hashtag: Joi.string()
            .min(2)
            .pattern(/^#[a-zA-Z0-9]{2}/)
    });

    return schema.validate(data);
}

module.exports.mentionValidation = data => {
    const schema = Joi.object({
        hashtag: Joi.string()
            .min(2)
            .pattern(/^#[a-zA-Z0-9]{2}/)
    });
    
    return schema.validate(data);
}