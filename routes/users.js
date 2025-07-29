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
    Código que se utiliza para obtener los tipos de sangre.
*/
router.get('/get-blood-types', async function(req, res, next) {

    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let params = [langId];
 
    let data = await usersModel.getBloodTypes(params);
   
    res.send(data);

});

/*
    Código que se utiliza para obtener los códigos de teléfono asociado a los paises.
*/
router.get('/get-countries-phone-codes', async function(req, res, next) {

    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
 
    let data = await usersModel.getCountriesPhoneCodes();
   
    res.send(data);

});

/*
    Código que se utiliza para obtener los tipos de documento de identificación.
*/
router.get('/get-document-types', async function(req, res, next) {

    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let params = [langId];
 
    let data = await usersModel.getDocumentTypes(params);
   
    res.send(data);

});

/*
    Código que se utiliza para obtener los tipos de genero.
*/
router.get('/get-gender-types', async function(req, res, next) {

    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let params = [langId];
 
    let data = await usersModel.getGenderTypes(params);
   
    res.send(data);

});

/*
    Código que se utiliza obtener la información del usuario.
*/
router.get('/get-user-data', async function(req, res, next) {

    let userId = req.query.userId; // Id del usuario
    let langId = req.query.langId; // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    let params = [userId, langId];
 
    let data = await usersModel.getUserData(params);
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

    res.send(data);

});

/*
    Método para actualizar los datos del usuario
*/
router.post('/update-user-data', async function(req, res, next) {

    let params = [
        req.query.userId, // Id del usuario
        req.query.firstName, // Primer nombre del usuario
        req.query.middleName, // Segundo nombre del usuario
        req.query.lastName, // Primer apellido del usuario
        req.query.secondLastName, // Segundo apellido del usuario
        req.query.documentTypeId, // Id del tipo de documento. Ejemplo 1 => Cédula
        req.query.document, // Número de documento asociado al tipo de documento
        req.query.birthday, // Fecha de cumpleaños del usuario
        req.query.genderId, // Id del genero del usuario
        req.query.bloodTypeId, // Tipo de sangre del usuario. Ejemplo: 8 => O-
        req.query.countryPhoneCode, // Código telefonico del país
        req.query.phoneNumber, // Número de teléfono del usuario
        req.query.countryEmergencyPhoneCode, // Código telefonico del país
        req.query.emergencyPhoneNumber, // Número de teléfono de emergencia del usuario
        req.query.medicalCondition, // Condición médica del usuario
        req.query.langId // Id del idioma en la cual se traducirán los mensajes. Ejemplo: esp, eng
    ];
    console.log(params)
    let data = await usersModel.updateUserData(params);

    res.send(data);

});

module.exports = router;
