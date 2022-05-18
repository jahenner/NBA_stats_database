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
            console.log(results, fields, err)
            res.status(201).json(results);
        });
    });

app.get('/GetGames', function(req, res)
    {
    // Define our queries
    query1 = 'SELECT Games.game_id as game_id, home.team_id as home_id, away.team_id as away_id, Games.date, home.name as home_team, away.name as away_team, Teams_has_Games.home_team_score, Teams_has_Games.away_team_score FROM Teams_has_Games LEFT JOIN Teams home ON Teams_has_Games.home_team_id=home.team_id LEFT JOIN Teams away ON Teams_has_Games.away_team_id=away.team_id JOIN Games ON Games.game_id=Teams_has_Games.game_id;';

    // Execute every query in an asynchronous manner, we want each query to finish before the next one starts

    // DROP TABLE...
    db.pool.query(query1, function (err, results, fields) {
        console.log(results, fields, err)
        res.status(201).json(results);
        })
    });

app.delete('/GetGames/:game_id', (req, res) => {
    games.deleteGame(req.params.game_id)
    .then(deletedCount => {
        if (deletedCount === 1) {
            res.status(204).send();
        } else {
            res.status(500).json({ Error: 'Resource not found!' });
        }
    })
    .catch(error => {
        console.error(error);
        res.status(500).send({ error: 'The request to delete by game_id has failed!' });
    });
});


/*
    LISTENER
*/
app.listen(PORT, function(){
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});