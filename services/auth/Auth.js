//an object being exported
var authService = {};

var tables = require("../../helpers/Tables.json");

var authmodel = require("../../models/auth/Auth.js");

//authService.loginFn(req, res);
authService.login = function(req, res) {

    console.log("login in AuthService");  

    var reqBody = req.body;
    var obj = {};
    obj.useremail = reqBody.username;
    obj.password = reqBody.password;

    //Calling Auth Model.
    authmodel.login(obj, req, res);
};

module.exports = authService;
