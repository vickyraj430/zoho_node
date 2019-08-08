var express = require('express');
var router = express.Router();
var multer = require('multer');
var bodyParser = require('body-parser');

var app = new express();

app.use(bodyParser.json());

var path = require('path');
// var multer = require('multer');

var upload = multer({dest: './imports/'});

// var imports = multer({dest: './imports/'});


app.set('views', path.join(__dirname, 'views'));


var importService = require("../../services/import/Import.js");

/*API call for create a import*/

router.post("", function (req, res) {
    console.log('create import API call in importController');
    importService.insertContact(req, res);
});


/*API call for getting the contact*/

router.get("", function (req, res) {
    console.log('get contact API call in ContactController');
    importService.getContact(req, res);
});

/*API call for update a Contact*/

router.put("", function (req, res) {
    console.log('update Contact API call in ContactController');
    importService.updateContact(req, res);
});

/*API call for delete a Contact*/

router.delete("", function (req, res) {
    console.log('delete Contact API call in ContactController');
    importService.deleteContact(req, res);
});

/*API call for create a Contact*/
router.post("/search_filter", function (req, res) {
    console.log('create Contact API call in ContactController');
    importService.searchContact(req, res);
});

module.exports = router;