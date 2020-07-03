//@ts-check

module.exports = async (req, res) => {
    if (req.loggedUser) {
        // await req.loggedUser.setPublic_to([req.loggedUser.getId()]);
        console.log(req.loggedUser.getId());

        return res.status(200).json(req.loggedUser.toMap());
    }
};
