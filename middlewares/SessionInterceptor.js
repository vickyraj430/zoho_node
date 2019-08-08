var sessionBypassRoutes = ["/auth"];

module.exports = function (app) {
    app.use("/", function (req, res, next) {
        var url = req.url,
            queryStringIndex = req.url.indexOf("?"),
            url = queryStringIndex >= 0 ? url.substring(0, queryStringIndex) : url,
            urlIndex = sessionBypassRoutes.indexOf(url),
            session = req.session;
        if (!url
            || urlIndex >= 0
            || url == '/import'
            || url == '/contact'
            || url == '/export'
            || url == '/contact/contactImage') {
            return next();
        }

        if (!session.user) {
            return res.json({ success: true, session: false });
        }
        next();
    });
}