var importmodel = {};
var Q = require("q");
var contactmodel = require("../contact/Contact.js");

importmodel.insertContact = function (obj, session, req, res ) {
    console.log("Entering into import contact in import model ");
    var successCount = 0,
        failureCount = 0,
        promises = [],
        rejectedRecords = [],
        onlyOne;
    // obj is the array of objects coming from the file that is being imported
    obj.map((importedData) => {
        for (i = (obj.length - 1); i >= 0; i--) {
            if (obj[i].email_address == importedData.email_address) {
                onlyOne = obj[i];
                obj.splice(i, 1);
            }
        }
        obj.push(onlyOne);
    });

    obj.map((importedData) => {
        promises.push(contactmodel.insertContact(importedData, session, req, res));
    });

    Q.all(promises)
        .then(function (data) {
            // console.log("AM in then", data[0].rejectedRecords);
            data.map((key) => {
                console.log('kkyyyyyy',key)
                if (key.recordCreated == true) {
                    successCount++;
                } else {
                    failureCount++;
                    rejectedRecords.push(key.rejectedRecords);
                    console.log('rejected record',key.rejectedRecords);
                }
            });
            // console.log(rejectedRecords);
            return res.status(200).json({ success: true, recordsCreated: successCount, recordsfailed: failureCount, rejectedRecords: rejectedRecords});
        })
};

module.exports = importmodel;
