var express = require('express');
var router = express.Router();
var usersModel = require('../models/users.js');
require('dotenv').config();

/*
    Se cambia el estatus del usuario pasando de estatus 3 (Pendiente por verificación) a 1 (activo)
*/
router.post('/activate-user-account', async function(req, res, next) 
{

    let langId = req.query.langId; // Id del usuario el cual es una cadena varchar entre números y letras
    let userId = req.query.userId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let params = [userId, langId];
  
    let data = await usersModel.activateAccount(params);
    res.send(data);

});

/*
    Se revisa si el nobre de usuario está disponible
*/
router.get('/check-username', async function(req, res, next) 
{

    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let username = req.query.username; // Nombre de usuario, es una cadena que puede tener letras y números. Ejemplo: usuario101
    let params = [username, langId];
    let data = await usersModel.checkUsername(params);
    
    res.send(data);

});

/*
    Código que se utiliza en sustitución de la contraseña para poder
    acceder a los datos de la cuenta del usuario.
*/
router.get('/get-access-code', async function(req, res, next) {

    let email = req.query.email;   // Correo asociado a la cuenta de usuario. Ejemplo: correo@dominio.com
    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let params = [email, langId];
    let data = await usersModel.getUserAccessCode(params);

    res.send(data);

});

/*
    Método para dar acceso al usuario
*/
router.post('/sign-in', async function(req, res, next) {

    let accessCode = req.query.accessCode; // Código de acceso generado por la función /get-access-code
    let email = req.query.email; // Correo asociado a la cuenta de usuario
    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let params = [email, accessCode, langId];
    let data = await usersModel.signIn(params);

    res.send(data);

});

/*
    Método para crear una nueva cuenta de usuario
*/
router.post('/sign-up', async function(req, res, next) {

    let email = req.query.email; // Correo asociado a la cuenta de usuario
    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let username = req.query.username; // Nombre de usuario, es una cadena que puede tener letras y números. Ejemplo: usuario101
    let params = [email, username, langId];
    let data = await usersModel.signUp(params);

    res.send(data)

})

module.exports = router;
