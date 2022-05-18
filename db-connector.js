// ./database/db-connector.js
var secrets = require('./secrets.js')
// Get an instance of mysql we can use in the app
var mysql = require('mysql')

// Create a 'connection pool' using the provided credentials
var pool = mysql.createPool({
    connectionLimit : 10,
    host            : '127.0.0.1',
    user            : 'jahenner',
    password        : 'Superman24!',
    database        : 'NBA'
})

// Export it for use in our applicaiton
module.exports.pool = pool;