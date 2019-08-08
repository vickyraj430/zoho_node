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


var contactService = require("../../services/contact/Contact.js");


// var keycloakObject = {
//     "realm": "master",
//     "bearer-only": true,
//     "auth-server-url": "http://192.168.1.207:8180/auth",
//     "ssl-required": "external",
//     "resource": "ZOHO_Service",
//     "verify-token-audience": true,
//     "use-resource-role-mappings": true,
//     "confidential-port": 0
//   };

// var keycloak = new Keycloak({ store: memoryStore }, keycloakObject);
app.use(session({
    secret: "39e53116-4734-41d5-92e9-00a61d1b75b5",
    resave: false,
    saveUninitialized: true,
    store: memoryStore
}));

var keycloak = new Keycloak({ store: memoryStore });

app.use(keycloak.middleware());

/*API call for create a Contact*/

router.post("", function (req, res) {
    console.log('create Contact API call in ContactController');
     contactService.insertContact(req, res);
    //  return res.json({ success: true, message: "Successfully Contact is created", ddo_contact_id: data[0].ddo_contact_id });
});

/**
 * POST API call for user contactImage pic create/update 
 */
router.post("/contactImage", upload.single('contactImage'), function(req, res) {
    console.log("contactImage POST API call in ContactController");
    
    var imgPath = req.file.path;
    imgPath = imgPath.replace(/\\/g,"/");
    var domain = req.body.domain, 
    script = '<script type="text/javascript">document.domain = "' + domain + '";</script>';
    console.log(domain);
    bodyText = JSON.stringify({ success: true, imgPath: imgPath });
    bodyText = bodyText.replace(/\\/g, "/")

    body = '<body>' + bodyText + '</body>';
    res.setHeader('Content-Type', 'text/html');
    res.send('<html><head>' + script + '</head>' + body + '</html>');
    console.log('response is ' + res.body)
    return res;
    // return res.json({success: true, imgPath: imgPath});
});

/*API call for getting the contact*/

router.get("", function (req, res) {
    console.log('get contact API call in ContactController', req.headers);
    contactService.getContact(req, res);
});

router.get("", function (req, res) {
    console.log('get contact API call in ContactController', req.headers);
    contactService.getContact(req, res);
});

/*API call for update a Contact*/

router.put("", function (req, res) {
    console.log('update Contact API call in ContactController');
    contactService.updateContact(req, res);
});

/*API call for delete a Contact*/

router.delete("", function (req, res) {
    console.log('delete Contact API call in ContactController');
    contactService.deleteContact(req, res);
});

/*API call for create a Contact*/
router.post("/search_filter", function (req, res) {
    console.log('create Contact API call in ContactController');
    contactService.searchContact(req, res);
});

module.exports = router;