var contactmodel = {};

var Q = require("q");

var Transaction = require('pg-transaction');

var Util = require('../../helpers/Util.js');
var db = require("../../helpers/db/Postgres.js");
var tables = require("../../helpers/Tables.json");

//var DDO_CONTACT_TABLE_NAME = tables["ddo_contact"];
var DDO_CONTACT_TABLE_NAME = "contact";


contactmodel.insertContact = function (obj, session, req, res) {
    console.log("Entering into insertContact in contactModel");
    //logged session details
    var userInfo = session.userDetails;
    var email = req.body.email_address || obj.email_address;
    var ddo_org_id = 1000001; //userInfo.ddo_org_id;
    var ddo_client_id = 11; //userInfo.ddo_client_id;
    var recordCreated;
    var contact_owner_id = 1001231; //userInfo.ddo_client_id;
    var ddo_employee_id = 1001231; //userInfo.ddo_employee_id;
    var ddoEmpColumns = "ddo_client_id, ddo_org_id, firstname,lastname,mobile_number,email_address,orgname,title ,industry,primary_business,website,employee_count,revenue,linkedin_id,address,city,state,country,notes,contact_profile_pic,contact_owner_id,createdby,updatedby,area_code,std_code,phone_1,phone_2,phone_3,phone_4,phone_5,phone_6";
    obj.contact_profile_pic = obj.contact_profile_pic;
    obj.title = obj.title;
    obj.state = obj.state;
    var revenue = obj.revenue, employeeCount = obj.employee_count;
    var firstName    = (obj.firstname).toLowerCase(),
    orgName          = (obj.orgname).toLowerCase(),
    title            = (obj.title).toLowerCase(),
    industry         = (obj.industry).toLowerCase(),
    primaryBusiness  = (obj.primary_business).toLowerCase(),
    city             = (obj.city).toLowerCase();
    // For any undefined/ empty field 
    for (var key in obj) {
        if (obj[key] == undefined) {
            obj[key] = '';
        }
    }
    if(revenue){
        revenue = obj.revenue;
    }else{
        revenue = 0;
    }

    if(employeeCount){
        employeeCount = obj.employee_count;
    }else{
        employeeCount = 0;
    }

    if (obj.country_code) {
        obj.mobile_number = '+' + obj.country_code + ' ' + obj.mobile_number;
    }

    var values = "(" + ddo_client_id + "," + ddo_org_id + ",'" + firstName + "','" + obj.lastname + "','" + obj.mobile_number + "','" + obj.email_address + "','" + orgName + "','" + title + "','" + industry + "','" + primaryBusiness + "','" + obj.website + "'," + employeeCount + "," + revenue + ",'" + obj.linkedin_id + "','" + obj.address + "','" + city + "','" + obj.state + "','" + obj.country + "','" + obj.notes + "','" + obj.contact_profile_pic + "','" + contact_owner_id + "','" + ddo_employee_id + "','" + ddo_employee_id + "','" + obj.area_code + "','" + obj.std_code + "','" + obj.phone_1 + "','" + obj.phone_2 + "','" + obj.phone_3 + "','" + obj.phone_4 + "','" + obj.phone_5 + "','" + obj.phone_6 + "')";
    //using select query

    var deferred = Q.defer();
    // promises.push(contactmodel.getAllContact(session, email, res));
    contactmodel.getAllContact(session, email, res)
        .then(function (data) {
            if (data.validContact) {
                var ddoContactInsertQuery = "INSERT INTO " + DDO_CONTACT_TABLE_NAME + " (" + ddoEmpColumns + ") VALUES " + values + "returning ddo_contact_id";
                console.log("query", ddoContactInsertQuery);
                db.selectQuery(ddoContactInsertQuery, [], function (err, data) {
                    if (err) {
                        console.log("query", ddoContactInsertQuery);
                        console.log("err in insert Contact", err);
                        console.log('error in insert record data' , data);
                        recordCreated = false;
                        console.log('recordCreated', recordCreated)
                        deferred.resolve({ recordCreated: false, rejectedRecords: ''});
                    } else {
                        recordCreated = true;
                        console.log('Record inserted');
                        deferred.resolve({ recordCreated: true, ddo_contact_id: data[0].ddo_contact_id});
                        console.log('Record insertedffffffffffff');
                    }
                });
            } else {
                console.log("err in validate email");
                recordCreated = false;
                deferred.resolve({ recordCreated: false, rejectedRecords: obj});
            }
        }).catch(function (err) {
            console.log(err); console.log("asdfsadf");
        });
    return deferred.promise;
};


contactmodel.getAllContact = function (session, email, res) {
    // console.log(req);
    var deferred = Q.defer();

    var ddo_org_id = 1000001; //userInfo.ddo_org_id;
    var ddo_client_id = 11; //userInfo.ddo_client_id;
    var ddo_employee_id = 1001231; //userInfo.ddo_employee_id;
    var condition = "DDO_Client_ID=$1 AND DDO_Org_ID=$2 AND email_address = '" + email + "'";
    var contactSelectQuery = "SELECT * FROM " + DDO_CONTACT_TABLE_NAME + " WHERE " + condition;

    console.log(contactSelectQuery);
    db.selectQuery(contactSelectQuery, [ddo_client_id, ddo_org_id], function (err, data) {
        if (err) {
            console.log("err in getting Contact", err);
            deferred.reject({ validContact: false });

        } else {

            if (data.length > 0) {
                deferred.resolve({ validContact: false });
            } else {
                deferred.resolve({ validContact: true });
            }

        }
    });
    return deferred.promise;
}

contactmodel.getContact = function (obj, session, req, res) {
    console.log("Entering into getContact in contactModellll");

    //logged session details
    var userInfo = session.userDetails;

    var ddo_org_id = 1000001;         //userInfo.ddo_org_id;
    var ddo_client_id = 11;       //userInfo.ddo_client_id;

    var ddo_employee_id = 1001231;          //userInfo.ddo_employee_id;
    console.log("@@@@", req.query);
    var searchParam = req.query.search,
        filter_by_comanyname = req.query.filter_by_comanyname,
        filter_by_title = req.query.filter_by_title,
        filter_by_industry = req.query.filter_by_industry,
        filter_by_business = req.query.filter_by_business,
        filter_by_city  = req.query.filter_by_city;
    var start = req.query.start || 0;
    var limit = req.query.limit || 5;
    var condition = "DDO_Client_ID=$1 AND DDO_Org_ID=$2";

    // Add extra params here to search fields
    if (searchParam) {
        condition = condition + " AND (orgname LIKE '%" + String(searchParam) + "%' OR title LIKE '%" + String(searchParam) + "%' OR industry LIKE '%" + String(searchParam) + "%' OR primary_business LIKE '%" + String(searchParam) + "%' OR city LIKE '%" + String(searchParam) + "%')";
        condition = condition.replace(/"/g, "");
    }
  
    if (filter_by_comanyname) {
        condition = condition + " AND orgname like '%" + filter_by_comanyname + "%'";
        condition = condition.replace(/"/g, "");
    }if (filter_by_title) {
        condition = condition + " AND title like '%" + filter_by_title + "%'";
        condition = condition.replace(/"/g, "");
    }if (filter_by_industry) {
        condition = condition + " AND industry like '%" + filter_by_industry + "%'";
        condition = condition.replace(/"/g, "");
    }if (filter_by_business) {
        condition = condition + " AND primary_business like '%" + filter_by_business + "%'";
        condition = condition.replace(/"/g, "");
    }if (filter_by_city) {
        condition = condition + " AND city like '%" + filter_by_city + "%'";
        condition = condition.replace(/"/g, "");
    }
    
    var contactSelectCOUNTQuery = "SELECT count(*) FROM " + DDO_CONTACT_TABLE_NAME + " WHERE " + condition;
    if(searchParam || filter_by_business || filter_by_city || filter_by_comanyname || filter_by_industry || filter_by_title){
        condition = condition  + " " + " offset " + 1 + " limit " + limit;;
    }else{
        condition = condition + " " + " offset " + start + " limit " + limit;
    }
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

contactmodel.updateContact = function (obj, session, req, res) {
    console.log("Entering into updateContact in contactModel");
    console.log('objjjjj',obj);
    //logged session details
    var userInfo = session.userDetails;

    var ddo_org_id = 1000001;         //userInfo.ddo_org_id;
    var ddo_client_id = 11;       //userInfo.ddo_client_id;

    var ddo_employee_id = 1001231;          //userInfo.ddo_employee_id;

    var condition = "isactive = 'Y' AND ddo_contact_id=$1 AND ddo_client_id=$2 AND ddo_org_id=$3";

    var contactUpdateQuery = "UPDATE " + DDO_CONTACT_TABLE_NAME + " SET firstname = '" + obj.firstname + "',lastname = '" + obj.lastname + "',mobile_number = '" + obj.mobile_number + "',email_address = '" + obj.email_address + "', orgname = '" + obj.orgname + "', title = '" + obj.title + "',industry = '" + obj.industry + "',primary_business = '" + obj.primary_business + "',website ='" + obj.website + "',employee_count =" + obj.employee_count + ",revenue =" + obj.revenue + ",linkedin_id = '" + obj.linkedin_id + "',address = '" + obj.address + "',city = '" + obj.city + "',state = '" + obj.state + "',country = '" + obj.country + "',notes = '" + obj.notes + "',contact_profile_pic ='" + obj.contact_profile_pic + "',area_code ='" + obj.area_code + "',std_code ='" + obj.std_code + "',phone_1 ='" + obj.phone_1 + "',phone_2 ='" + obj.phone_2 + "',phone_3 ='" + obj.phone_3 + "',phone_4 ='" + obj.phone_4 + "',phone_5 ='" + obj.phone_5 + "',phone_6 ='" + obj.phone_6 + "', updatedby = " + ddo_employee_id + " WHERE " + condition;

    db.selectQuery(contactUpdateQuery, [obj.ddo_contact_id, ddo_client_id, ddo_org_id], function (err, data) {
        if (err) {
            console.log("err in updating Contact", err);
            return res.status(500).json({ success: false, data: err, message: 'Failed to update Contact record!' });
        } else {
            return res.json({ success: true, message: "Successfully Contact is updated!" });
        }
    });
};

contactmodel.deleteContact = function (obj, session, req, res) {
    console.log("Entering into deleteContact in contactModel");

    //logged session details
    var userInfo = session.userDetails;

    var ddo_org_id = 1000001;         //userInfo.ddo_org_id;
    var ddo_client_id = 11;       //userInfo.ddo_client_id;

    var ddo_employee_id = 1001231;          //userInfo.ddo_employee_id;

    var condition = "ddo_contact_id=$1 AND ddo_client_id=$2 AND ddo_org_id=$3";
    var contactDeleteQuery = "DELETE FROM " + DDO_CONTACT_TABLE_NAME + " WHERE " + condition;

    db.selectQuery(contactDeleteQuery, [obj.ddo_contact_id, ddo_client_id, ddo_org_id], function (err, data) {
        if (err) {
            console.log("err in deleting Contact", err);
            return res.status(500).json({ success: false, data: err, message: 'Failed to delete Contact record!' });
        } else {
            return res.json({ success: true, message: "Successfully Contact is deleted!" });
        }
    });
};



module.exports = contactmodel;
