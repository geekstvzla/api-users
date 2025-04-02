var mysql = require('mysql2');
require('dotenv').config();

let settings = {
    host    : process.env.DB_HOST,
    port    : process.env.DB_PORT,
    user    : process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE
};

let db = mysql.createConnection(settings);
  
module.exports = db;