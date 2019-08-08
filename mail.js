var express = require('express');
var router = express.Router();
var hbs =require('nodemailer-express-handlebars'); 
var fs = require('fs');

var nodemailer = require('nodemailer');
var smtpTransport = require('nodemailer-smtp-transport');

router.get('', function(req, res, next) {
  	fs.readFile('./templates/email.css', 'utf8', function(err, contents) {
  		if (err) {
  			console.log("Error while reading file", err)
  		} else {
		  mailer.sendMail({
		    from: 'no-reply@walkingtree.tech',
		    to: 'yosadhara.pradhan@walkingtree.tech',
		    subject:'Testing Template',
		    template: 'email',
		    context: {
		    	style:contents,
		        username:"Suresh",
		        mail_from:"Shivani",
		        mail_content:"Our esteemed community seem to be missing you at EngazeWell.We haven't seen you participating in any discussion or activity since <<Date>>.We are on the course of creating an amazing high-performance team and it cannot be done without your active participation.Let me know what we can do to bring you back. Hope to see you soon."
		    }
		  }, function(err, response){
		    if (err) {
		        console.log(err)
		        res.send('Bad email');
		    } else {
		       res.send('Good email');  
		    }

		  });
		}
	});  
});
var mailer = nodemailer.createTransport(smtpTransport({
    host: 'smtp.gmail.com',
    port: 587,
    secure: true,
    service: 'Gmail',
    auth: {
        user: 'no-reply@walkingtree.tech',
        pass: 'w@lkingtree'
    }
}));

mailer.use('compile', hbs({
    viewPath: './templates',
    extName:'.hbs'
}));

module.exports = router;