// ./database/db-connector.js
var secrets = require('./secrets.js')
// Get an instance of mysql we can use in the app
var mysql = require('mysql')

// Create a 'connection pool' using the provided credentials
var pool = mysql.createPool({
    connectionLimit : 10,
    host            : '127.0.0.1',
<<<<<<< HEAD
    user            : 'jahenner',
    password        : 'Superman24!',
    database        : 'NBA'
=======
    user            : 'root',
    password        : 'your_current_password',
    database        : 'nba'
>>>>>>> c829fb7563ec9334097b64d4bd15f3239c6f5093
})

// Export it for use in our applicaiton
module.exports.pool = pool;