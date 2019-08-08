var importservice = {};

var importmodel = require("../../models/import/Import.js");

importservice.insertContact = function(req, res) {
    console.log("Entering into import contact  in importservice");
    
    // var session = req.session;
    var session = true;
    var obj =req.body.contactsArray,
        count = 0,
        length = obj.length,
        manditoryFlag = true;
    while (count < length) {
        if ((!obj[count].firstname) || (!obj[count].lastname)  || (!obj[count].mobile_number) || (!obj[count].email_address) || (!obj[count].orgname) || (!obj[count].title)) {
            manditoryFlag == false;
            manditoryFlagCount = count + 2;
            return res.json({ success: false, data: null, session: false, message: "manditory fields are missing" , manditoryFlagCount: manditoryFlagCount });
        }
        count++;
    }
    if (manditoryFlag == true) {
        importmodel.insertContact(obj, session, req, res );
    }
};


module.exports = importservice;