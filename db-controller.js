/*
    SETUP
*/

// Express
var express = require('express');
var app = express();
app.use(express.json())
app.use(express.urlencoded({
    extended: true
}));
PORT = 3000;

// Database
var db = require('./db-connector')

/*
    ROUTES
*/
app.get('/GetCities', function(req, res)
    {
        // Define our queries
        query1 = 'Select * from Cities;';

        // Execute every query in an asynchronous manner, we want each query to finish before the next one starts

        // DROP TABLE...
        db.pool.query(query1, function (err, results, fields){
            console.log(results)
            res.status(201).json(results);
        });
    });
/*
    LISTENER
*/
app.listen(PORT, function(){
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});