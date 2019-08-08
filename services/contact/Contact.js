var contactservice = {};
var Q = require("q");
var contactmodel = require("../../models/contact/Contact.js");

contactservice.insertContact = function (req, res) {
    console.log("Entering into insertContact in contactService");
    // var session = req.session;
    var session = true;
    var obj = req.body;
    if ((!obj.firstname) || (!obj.lastname) || (!obj.firstname) || (!obj.mobile_number) || (!obj.email_address) || (!obj.orgname) || (!obj.title)) {
        return res.json({ success: false, data: null, session: false, message: "manditory fields are missing" });
    } else {
        //input parameters
        console.log("@@@@@@", obj);
        var promises = [];
        promises.push(contactmodel.insertContact(obj, session, req, res));
        Q.all(promises)
        .then(function (data) {
            console.log("AM in then", data);
            data.map((key) => {
                if (key.recordCreated == true) {
                    data = {
                        ddo_contact_id: key.ddo_contact_id
                    }
                    return res.status(200).json({ success: true, message: "Successfully Contact is created", data: data });
                } else {
                    data = {
                        duplicate: true
                    };
                    return res.status(200).json({ success: false, data: data, message: "Failed to create Contact" });
                }
            });
        });
    }
};

contactservice.getContact = function(req, res) {
    console.log("Entering into getContact in contactService");
    // var session = req.session;
    var session = true;

    // if (!session.useremail) {
    //     return res.json({success: false, data: null, session: false});
    // } else {
        var obj = req.body;
        contactmodel.getContact(obj,session, req, res);        
   // }
};

contactservice.updateContact = function(req, res) {
    console.log("Entering into updateContact in contactService");

    // var session = req.session;
    var session = true;
    var obj = req.body;
    // if (!session.useremail) {
    //     return res.json({success: false, data: null, session: false});
    // }else
     if((!obj.firstname)||  (!obj.lastname) ||  (!obj.firstname) || (!obj.mobile_number)|| (!obj.email_address) || (!obj.orgname) || (!obj.title)) {
        return res.json({success: false, data: null, session: false,message:"manditory fields are missing"});
    } else {
      

        contactmodel.updateContact(obj, session, req, res);        
    }
};

contactservice.deleteContact = function(req, res) {
    console.log("Entering into deleteContact in contactService");
    // var session = req.session;
    var session = true;

    // if (!session.useremail) {
    //     return res.json({success: false, data: null, session: false});
    // } else {
        var obj = {};

        //input parameters
        var reqBody = req.body;
        obj['ddo_contact_id'] = reqBody.ddo_contact_id;
        contactmodel.deleteContact(obj, session, req, res);        
   // }
};
contactservice.searchContact = function(req, res) {
    console.log("Entering into deleteContact in contactService");

    // var session = req.session;
    var session = true;
    var obj = req.body;
        
    contactmodel.searchContact(obj, session, req, res);        
};


module.exports = contactservice;