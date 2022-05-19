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
        const query1 = 'Select * from Cities;';

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
    const query1 = 'SELECT Games.game_id as game_id, home.team_id as home_id, away.team_id as away_id, Games.date, home.name as home_team, away.name as away_team, Teams_has_Games.home_team_score, Teams_has_Games.away_team_score FROM Teams_has_Games LEFT JOIN Teams home ON Teams_has_Games.home_team_id=home.team_id LEFT JOIN Teams away ON Teams_has_Games.away_team_id=away.team_id JOIN Games ON Games.game_id=Teams_has_Games.game_id;';

    // Execute every query in an asynchronous manner, we want each query to finish before the next one starts

    // DROP TABLE...
    db.pool.query(query1, function (err, results, fields) {
        console.log(results, fields, err)
        res.status(201).json(results);
        })
    });

app.get('/GetTeams', function(req,res) {
    const query1 = 'SELECT Teams.team_id, Teams.name, Teams.mascot, Cities.name as location FROM Teams JOIN Cities on Cities.city_id=Teams.location;'

    db.pool.query(query1, function (err, results, fields) {
        // console.log(results, fields, err)
        res.status(201).json(results);

        })
})

app.get('/GetPlayers', function(req,res) {
    const query1 = 'SELECT Players.player_id, Players.first_name, Players.last_name, Players.age, Players.career_points, Players.career_steals, Players.career_blocks, Players.career_rebounds, Cities.name as hometown, Teams.name as curr_team FROM Players JOIN Cities ON Players.hometown = Cities.city_id LEFT JOIN Teams ON Players.current_team = Teams.team_id;'

    db.pool.query(query1, function (err, results, fields) {
        // console.log(results, fields, err)
        res.status(201).json(results);

        })
})

app.get('/GetStats', function(req,res) {
    const query1 = "SELECT CONCAT(Players.first_name, ' ', Players.last_name) AS player_name, Games.date, IF(Players.current_team=Teams_has_Games.home_team_id, Teams_has_Games.home_team_id, Teams_has_Games.away_team_id) as opposing_team, Players_has_Games.rebounds, Players_has_Games.blocks, Players_has_Games.steals, Players_has_Games.turnovers, Players_has_Games.minutes_played, Players_has_Games.started_game, Players_has_Games.freethrows_attempt, Players_has_Games.freethrows_made, Players_has_Games.field_goals_attempt, Players_has_Games.field_goals_made, Players_has_Games.3_points_attempt, Players_has_Games.3_points_made, Players_has_Games.assists, Players_has_Games.fouls FROM Players_has_Games JOIN Players ON Players_has_Games.player_id = Players.player_id JOIN Games ON Games.game_id=Players_has_Games.game_id JOIN Teams_has_Games ON Teams_has_Games.game_id=Games.game_id;"

    db.pool.query(query1, function (err, results, fields) {
        // console.log(results, fields, err)
        res.status(201).json(results);

        })
})

app.put("/UpdateGame/:_id", function(req,res) {
    const game_id = req.params._id;
    console.log(req.body)
    const query = `SELECT date from Games WHERE game_id=${game_id}`
    const query1 = `UPDATE Games SET date='${req.body.date}' WHERE game_id=${game_id}`
    const query2 = `UPDATE Teams_has_Games SET home_team_id=${req.body.home_id}, away_team_id=${req.body.away_id}, home_team_score=${req.body.home_team_score}, away_team_score=${req.body.away_team_score} WHERE game_id=${game_id}`

    db.pool.query(query, function (err, results, fields) {
        // console.log(results, fields, err)
        db.pool.query(query1, function (err, results, fields) {
                console.log(results);
                db.pool.query(query2, function (err, results, fields) {
                    console.log(results)
                    res.status(201).json(results);
                })
            })
        })
})

app.post("/addGame", function(req,res) {
    const query1 = `INSERT INTO Games (date) VALUES ('${req.body.date}');`
    const query2 = `INSERT INTO Teams_has_Games (home_team_id, away_team_id, game_id, home_team_score, away_team_score) VALUES (${req.body.homeTeam}, ${req.body.awayTeam}, (SELECT max(game_id) from Games), ${req.body.homeScore}, ${req.body.awayScore});`

    db.pool.query(query1, function (err, results, fields) {
        if (err != null) {
            res.status(500).json({ Error: 'New game failed'})
            
        } else {
            db.pool.query(query2, function (err, results, fields) {
                if (err == null) {
                    res.status(201).json(results)
                } else {
                    console.log(err)
                    res.status(500).json({ Error: 'Game details failed'})
                }
            })
        }
    })
})

app.delete('/GetGames/:_id', (req, res) => {
    const game_id = parseInt(req.params._id)
    const query1 = `DELETE FROM Teams_has_Games WHERE game_id=${game_id}`
    const query2 = `DELETE FROM Players_has_Games WHERE game_id=${game_id}`
    const query3 = `DELETE FROM Games WHERE game_id=${game_id}`

    db.pool.query(query1, function (err, results, fields){
        db.pool.query(query2, function (err, results, fields){
            db.pool.query(query3, function (err, results, fields){
                res.status(204).json(results);
            });
        });
    });
});


/*
    LISTENER
*/
app.listen(PORT, function(){
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});