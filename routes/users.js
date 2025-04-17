var express = require('express');
var router = express.Router();
var usersModel = require('../models/users.js');
require('dotenv').config();

router.post('/activate-user-account', async function(req, res, next) 
{

    let langId = req.query.langId;
    let userId = encryption.decrypt(req.query.userId);
    let params = [userId, langId];
    let data = await usersModel.activateAccount(params);
    
    res.send(data);

});

router.get('/check-username', async function(req, res, next) 
{

    let langId = req.query.langId;
    let username = req.query.username;
    let params = [username, langId];
    let data = await usersModel.checkUsername(params);
    
    res.send(data);

});

router.get('/get-user-access-code', async function(req, res, next) {

    let email = req.query.email;
    let langId = req.query.langId;
    let params = [email];
    let data = await usersModel.getUserAccessCode(params);

    if(data.response.statusCode !== 1)
    {
        delete data.response.userId;
    };

    res.send(data);

});

router.post('/sign-in', async function(req, res, next) {

    let accessCode = req.query.accessCode;
    let email = req.query.email;
    let langId = req.query.langId;
    let params = [email, accessCode];
    let data = await usersModel.signIn(params);
   
    if(data.response.statusCode !== 1)
    {
        delete data.response.userId;
    };

    res.send(data);

});

router.post('/sign-up', async function(req, res, next) {

    let email = req.query.email;
    let langId = req.query.langId;
    let username = req.query.username;
    let params = [email, username];
    let data = await usersModel.signUp(params);

    res.send(data)

})

module.exports = router;
