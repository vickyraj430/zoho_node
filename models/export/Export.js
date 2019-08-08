var exportmodel = {};

var Q = require("q");

var Transaction = require('pg-transaction');

var Util = require('../../helpers/Util.js');
var db = require("../../helpers/db/Postgres.js");
var tables = require("../../helpers/Tables.json");

//var DDO_CONTACT_TABLE_NAME = tables["ddo_contact"];
var DDO_CONTACT_TABLE_NAME = "contact";

exportmodel.getContact = function (obj, session, req, res) {
    console.log("Entering into export in exportModellll");

    //logged session details
    var userInfo = session.userDetails;

    var ddo_org_id = 1000001;         //userInfo.ddo_org_id;
    var ddo_client_id = 11;       //userInfo.ddo_client_id;

    var ddo_employee_id = 1001231;          //userInfo.ddo_employee_id;
    console.log("@@@@", req.query);
    var searchParam = req.query.search,
        filter_by_name = req.query.filter_by_name;
    filter_by_comanyname = req.query.filter_by_comanyname;
    var condition = "DDO_Client_ID=$1 AND DDO_Org_ID=$2";

    // Add extra params here to search fields
    if (searchParam) {

        condition = condition + " AND (firstname LIKE '%" + searchParam + "%' OR lastname LIKE '%" + String(searchParam) + "%' OR orgname LIKE '%" + String(searchParam) + "%' )";
        condition = condition.replace(/"/g, "");
    }
    if (filter_by_name) {
        condition = condition + " AND (firstname ilike '%" + filter_by_name + "%' OR lastname ilike '%" + filter_by_name + "%' OR orgname ilike '%" + filter_by_name + "%' )";
        condition = condition.replace(/"/g, "");
    }
    if (filter_by_comanyname) {
        condition = condition + " AND orgname like '%" + filter_by_comanyname + "%'";
        condition = condition.replace(/"/g, "");
    }
    var contactSelectCOUNTQuery = "SELECT count(*) FROM " + DDO_CONTACT_TABLE_NAME + " WHERE " + condition;
    var contactSelectQuery = "SELECT * FROM " + DDO_CONTACT_TABLE_NAME + " WHERE " + condition;

    console.log("@@@@", contactSelectQuery);
    db.selectQuery(contactSelectCOUNTQuery, [ddo_client_id, ddo_org_id], function (err, datalen) {
        if (err) {
            console.log("err in getting Contact", err);
            return res.status(500).json({ success: false, data: err, message: 'Failed to get Contact records!' });
        } else {

            db.selectQuery(contactSelectQuery, [ddo_client_id, ddo_org_id], function (err, data) {
                if (err) {
                    console.log("err in getting Contact", err);
                    return res.status(500).json({ success: false, data: err, message: 'Failed to get Contact records!' });
                } else {
                    return res.json({ success: true, totalCount: data.length, data: data, total: datalen[0].count });
                }
            });
        }
    });
};

module.exports = exportmodel;