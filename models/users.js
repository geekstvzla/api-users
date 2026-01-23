require('dotenv').config()
let db = require('../config/database.js')

const activateAccount = (params) => {

    return new Promise(function(resolve, reject) { 

        let queryString = `CALL sp_activate_account_user(?,?,?,@response);`;
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error al tratar de ejecutar la consulta",
                        status: "error",
                        statusCode: 0
                    }
                });
    
            } else {

                db.query('SELECT @response as response', (err2, result2) => {

                    if(err2) {
    
                        reject({
                            response: {
                                message: "Error al tratar de ejecutar la consulta",
                                status: "error",
                                statusCode: 0
                            }
                        });
            
                    } else {
                    
                        let outputParam = JSON.parse(result2[0].response);

                        if(outputParam.response.avatar) {
                            outputParam.response.avatar = process.env.API_PUBLIC+"/images/users/"+outputParam.response.avatar
                        }

                        resolve(outputParam);
                        
                    }   

                });
    
            }
    
        });

    }).catch(function(error) {

        return(error);
      
    });

}

const checkUsername = (params) => {

    return new Promise(function(resolve, reject) { 

        let queryString = `SELECT IF(COUNT(1) > 0, false, true) username_available 
                           FROM users u
                           WHERE LOWER(u.username) = LOWER(?);`;
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error al tratar de ejecutar la consulta",
                        status: "error",
                        statusCode: 0
                    }
                });
    
            } else {
              
                resolve({
                    response: {
                        status: "success",
                        statusCode: 1,
                        usernameAvailable: result[0].username_available
                    }
                });
    
            }
    
        });

    }).catch(function(error) {

        return(error)
      
    });

}

const getUserAccessCode = (params) => {

    return new Promise(function(resolve, reject) { 

        let queryString = `CALL sp_get_user_access_code(?,?,@response);`;
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error executing stored procedure sp_get_user_access_code in line 101",
                        status: "error",
                        statusCode: 0,
                        error: err
                    }
                });
    
            } else {
                
                db.query('SELECT @response as response', (err2, result2) => {

                    if(err2) {
    
                        reject({
                            response: {
                                message: "Error when trying to execute the query in line 117",
                                status: "error",
                                statusCode: 0,
                                error: err2
                            }
                        });
            
                    } else {
                        
                        let outputParam = JSON.parse(result2[0].response);
                        resolve(outputParam)
                        
                    }   

                });
    
            }
    
        });

    }).catch(function(error) {

        reject(error);
      
    });

};

const getBloodTypes = (params) => {

    return new Promise(function(resolve, reject) { 
       
        let queryString = `SELECT blood_type_id,
                                  description blood_type 
                           FROM blood_type bt
                           ORDER BY description;`
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error executing view vw_users in line 159",
                        status: "error",
                        statusCode: 0,
                        error: err
                    }
                });
    
            } else {
                
                resolve({
                    response: {
                        status: "success",
                        statusCode: 1,
                        documentTypes: result
                    }
                });
    
            }
    
        });

    }).catch(function(error) {

        return(error);
      
    });


};

const getCountriesPhoneCodes = () => {

    return new Promise(function(resolve, reject) { 
       
        let queryString = `SELECT c.phone_number_code 
                           FROM countries c
                           WHERE c.status_id = 1
                           ORDER BY c.phone_number_code;`
        db.query(queryString, [], function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error executing view vw_users in line 195",
                        status: "error",
                        statusCode: 0,
                        error: err
                    }
                });
    
            } else {
                
                resolve({
                    response: {
                        status: "success",
                        statusCode: 1,
                        phoneCodes: result
                    }
                });
    
            }
    
        });

    }).catch(function(error) {

        return(error);
      
    });


};

const getDocumentTypes = (params) => {

    return new Promise(function(resolve, reject) { 
       
        let queryString = `SELECT dt.document_type_id,
                                  dt.document_type 
                           FROM vw_document_types dt 
                           WHERE dt.language_code = ?
                           AND dt.status_id = 1
                           ORDER BY document_type;`
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error executing view vw_users in line 199",
                        status: "error",
                        statusCode: 0,
                        error: err
                    }
                });
    
            } else {
                
                resolve({
                    response: {
                        status: "success",
                        statusCode: 1,
                        documentTypes: result
                    }
                });
    
            }
    
        });

    }).catch(function(error) {

        return(error);
      
    });

}

const getGenderTypes = (params) => {

    return new Promise(function(resolve, reject) { 
       
        let queryString = `SELECT gender_type_id, gender FROM vw_gender_types WHERE language_code = ? ORDER BY gender;`
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error executing view vw_users in line 244",
                        status: "error",
                        statusCode: 0,
                        error: err
                    }
                });
    
            } else {
                
                resolve({
                    response: {
                        status: "success",
                        statusCode: 1,
                        genderTypes: result
                    }
                });
    
            }
    
        });

    }).catch(function(error) {

        return(error);
      
    });


};

const getUserData = (params) => {

    return new Promise(function(resolve, reject) { 
       
        let queryString = `SELECT * FROM vw_users u WHERE u.secure_id = ?;`
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error executing view vw_users in line 288",
                        status: "error",
                        statusCode: 0,
                        error: err
                    }
                });
    
            } else {
              
                resolve({
                    response: {
                        status: "success",
                        statusCode: 1,
                        userData: (result[0]) ? result[0] : {}
                    }
                });
    
            }
    
        });

    }).catch(function(error) {

        return(error);
      
    });

}

const signIn = (params) => {

    return new Promise(function(resolve, reject) { 

        let queryString = `CALL sp_sign_in(?,?,?,@response);`
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        message: "Error executing stored procedure sp_sign_in in line 328",
                        status: "error",
                        statusCode: 0,
                        error: err
                    }
                });
    
            } else {
                
                db.query('SELECT @response as response', (err2, result2) => {

                    if(err2) {
    
                        reject({
                            response: {
                                message: "Error when trying to execute the query in line 344",
                                status: "error",
                                statusCode: 0,
                                error: err2
                            }
                        });
            
                    } else {
                        
                        let outputParam = JSON.parse(result2[0].response);

                        if(outputParam.response.avatar) {
                            outputParam.response.avatar = process.env.API_PUBLIC+"/images/users/"+outputParam.response.avatar
                        }

                        resolve(outputParam)
                        
                    }   

                });
    
            }
    
        });

    }).catch(function(error) {

        return(error)
      
    });
    
}

const signUp = (params) => {

    return new Promise(function(resolve, reject) { 

        let queryString = `CALL sp_sign_up(?,?,?,@response);`
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        error: err,
                        message: "Error executing stored procedure sp_sign_up in line 387",
                        status: "error",
                        statusCode: 0
                    }
                });
    
            } else {

                db.query('SELECT @response as response', (err2, result2) => {

                    if(err2) {
    
                        reject({
                            response: {
                                error: err2,
                                message: "Error when trying to execute the query in line 403",
                                status: "error",
                                statusCode: 0
                            }
                        });
            
                    } else {
                    
                        let outputParam = JSON.parse(result2[0].response);

                        if(outputParam.response.userAvatar) {
                            outputParam.response.userAvatar = process.env.API_PUBLIC+"/images/users/"+outputParam.response.userAvatar
                        }
                        
                        resolve(outputParam);
                        
                    }   

                });
    
            }
    
        });

    }).catch(function(error) {

        return(error)
      
    });
    
}

const updateUserData = (params) => {

    return new Promise(function(resolve, reject) { 

        let queryString = `CALL sp_update_user_personal_data(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,@response);`
        db.query(queryString, params, function(err, result) {

            if(err) {
    
                reject({
                    response: {
                        error: err,
                        message: "Error executing stored procedure sp_sign_up in line 438",
                        status: "error",
                        statusCode: 0
                    }
                });
    
            } else {

                db.query('SELECT @response as response', (err2, result2) => {

                    if(err2) {
    
                        reject({
                            response: {
                                error: err2,
                                message: "Error when trying to execute the query in line 454",
                                status: "error",
                                statusCode: 0
                            }
                        });
            
                    } else {
                    
                        let outputParam = JSON.parse(result2[0].response);
                        resolve(outputParam);
                        
                    }   

                });
    
            }
    
        });

    }).catch(function(error) {

        return(error)
      
    });
    
}

module.exports = {
    activateAccount,
    checkUsername,
    getBloodTypes,
    getCountriesPhoneCodes,
    getDocumentTypes,
    getGenderTypes,
    getUserAccessCode,
    getUserData,
    signIn,
    signUp,
    updateUserData
}