var exportservice = {};
var Q = require("q");
var exportmodel = require("../../models/export/Export.js");

exportservice.getContact = function(req, res) {
    console.log("Entering into getContact in exportservice");
    // var session = req.session;
        var session = true;
        var obj = req.body;
        exportmodel.getContact(obj,session, req, res);        
};

module.exports = exportservice;