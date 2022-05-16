/*
    SETUP
*/

// Express
var express = require('express');
var app = express();
PORT = 9124;

// Database
var db = require('./db-connector')

/*
    ROUTES
*/
app.get('/', function(req, res)
    {
        // Define our queries
        query1 = 'Select * from Cities;';

        // Execute every query in an asynchronous manner, we want each query to finish before the next one starts

        // DROP TABLE...
        db.pool.query(query1, function (err, results, fields){
            res.send(JSON.stringify(results));
        });
    });
/*
    LISTENER
*/
app.listen(PORT, function(){
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});