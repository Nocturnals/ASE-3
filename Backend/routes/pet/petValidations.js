//@ts-check

const Joi = require("@hapi/joi");

module.exports.registerValidation = (data) => {
	const schema = Joi.object({
		petName: Joi.string().required(),
		animalType: Joi.string().required(),
		dob: Joi.date(),
	});

	return schema.validate(data);
};
