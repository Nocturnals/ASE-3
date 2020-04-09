module.exports = async (req, res) => {
    if (req.loggedUser) {
        // await req.loggedUser.setPublic_to([req.loggedUser.getId()]);
        console.log(req.loggedUser.getId());

        res.status(200).json(req.loggedUser.toMap());
    }
};
