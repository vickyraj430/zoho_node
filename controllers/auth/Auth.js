var express = require('express');
var router = express.Router();
var db = require("../../helpers/db/Postgres");
var authService = require("../../services/auth/Auth.js");

//Login Authentication
router.post("", function (req, res, next) {
    console.log("Entering Authentication api call");
    authService.login(req, res);
});

//To get UserDetails from session
router.get("/userdetails", function (req, res) {
    var session = req.session;
    if (session.useremail) {
        return res.json({success: true, data: session.userDetails, session: true});
    } else {
        return res.json({success: true, data: null, session: false});
    }
});

// Destroying existing session
router.post("/logout", function (req, res) {
    var session = req.session;
    if (session.user.email) {
        session.destroy(function (err) {
            if (err) {
                return res.json({success: true, data: "Unable to destroy session", session: true});
            }
            return res.json({success: true, data: null, session: false});
        });
    } else {
        return res.json({success: true, data: null, session: false});
    }
});

// Checking session if exist or not.
router.get("/checksession", function (req, res) {
    var session = req.session;
    if (session.useremail) {
        return res.json({success: true, data: null, session: true});
    } else {
        return res.json({success: true, data: null, session: false});
    }
});

module.exports = router;