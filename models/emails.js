let transporter = require('../config/mail.js')
const Email = require('email-templates')

const activateUserAccount = (params) => 
{
    
    let locale = translation(params.langId)
    params.from = '"LOGISTICO" <contacto@logistico.com.ve>'
    params.template = 'activateUserAccount/' + locale
    sendEmailTemplate(params)

}

const sendEmailTemplate = (params) => 
{

    const email = new Email({
        message: {
            from: params.from
        },
        preview: true,
        send: true,
        transport: transporter
    })

    email
    .send({
        template: params.template,
        message: {
            to: params.email
        },
        locals: params
    })/*
    .then(console.log)
    .catch(console.error)*/

}

const newUserAccount = (params) => 
{

    let locale = translation(params.langId)
    params.from = '"LOGISTICO" <contacto@logistico.com.ve>'
    params.locals = { url: params.url }
    params.template = 'newUserAccount/' + locale
    sendEmailTemplate(params)

}

const recoverUserPassword = async (params) => 
{

    let locale = translation(params.langId)
    params.from = '"LOGISTICO" <contacto@logistico.com.ve>'
    params.locals = { password: params.password }
    params.template = 'recoverUserPassword/' + locale
    sendEmailTemplate(params)

}

const translation = (lang) => {

    lang = parseInt(lang)
    var text = {}

    switch (lang) {
        case 1:
            text = 'es'
            break
        case 2:
            text = 'en'
            break
        default:
            text = 'es'
            break
    }

    return text

}

module.exports = {
    activateUserAccount,
    newUserAccount,
    recoverUserPassword
}