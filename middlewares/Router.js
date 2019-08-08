var routes = require('../controllers/index');

/*Login route initialization*/
var authController = require("../controllers/auth/Auth.js");

/*  Genral utilty route items */
var generalUtilityController = require("../controllers/util/GeneralUtility.js");

//Decrypt JS file
var decrypter = require("./decrypt.js");

//Contacts
var contactController = require("../controllers/contact/Contact.js");
var exportController = require("../controllers/export/Export.js");
// Import controller
var importController = require("../controllers/import/Import.js");

module.exports = function(app) {
    app.use("/auth", authController);
    app.use("/contact",contactController);
    app.use("/export",exportController);
    app.use("/import",importController);
    app.use("/utility", generalUtilityController);
};
