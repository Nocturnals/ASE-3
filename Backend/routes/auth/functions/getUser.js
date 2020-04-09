module.exports = async (req, res) => {
    return res.json({ user: req.loggedUser.toMap() });
};
