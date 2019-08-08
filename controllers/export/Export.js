var express = require('express');
var router = express.Router();
var multer = require('multer');
var bodyParser = require('body-parser');
var session = require('express-session');
var Keycloak = require('keycloak-connect');
var memoryStore = new session.MemoryStore();
var jwt = require('jsonwebtoken');
var cors = require('cors');
var app = new express();

app.use(bodyParser.json());


var path = require('path');
// var multer = require('multer');

var upload = multer({dest: './contactPics/'});

// var imports = multer({dest: './imports/'});


app.set('views', path.join(__dirname, 'views'));
var exportService = require("../../services/export/Export.js");

router.get("", function (req, res) {
    console.log('get contact API call in ExportController');
    exportService.getContact(req, res);
});

module.exports = router;