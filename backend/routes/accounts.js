var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var jwt = require('jsonwebtoken');
// const { get } = require('./banboos');

function generateToken(user) {
  var payload = {
    id: user.id,
    username: user.username,
    fullname: user.fullname
  };

  return jwt.sign(payload, 'SECRET KEY');
}

var opt = {
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'banboo_app'
};

/* GET users listing. */
router.get('/get_email/google/:email', function (req, res, next) {
  var email = req.params.email;
  var connection = mysql.createConnection(opt);

  connection.connect();

  // QUERY
  connection.query("SELECT * FROM msaccount WHERE email = ?", [email], function (err, results) {
    connection.end();

    if (err) {
      return res.status(500).json(err); //Return Error dengan HTTP status 500
    }

    return res.status(200).json(results);
  });
});

router.post('/login', function (req, res, next) {
  var email = req.body.email;
  var password = req.body.password;
  var connection = mysql.createConnection(opt);
  connection.connect();

  // QUERY
  connection.query("SELECT * FROM msaccount WHERE email = ? AND password = ?", [email, password], function (err, results) {

    if (err) throw err;
    if (results.length === 0) {
      return res.status(403).send;
    } else {
      var user = results[0];
      var token = generateToken(user);

      connection.query("UPDATE msaccount SET token = ? WHERE id = ?", [token, user.id]);
      connection.end();
      var data = {
        id: user.id,
        username: user.username,
        fullname: user.fullname,
        token: token,
        role: user.role
      }
      return res.status(200).json(data);
    }
  });
});

router.post('/insert', function (req, res, next) {

  var { fullname, username, email, password, role } = req.body;

  var connection = mysql.createConnection(opt);

  connection.connect();

  // QUERY
  connection.query("INSERT INTO msaccount(fullname, username, email, password, role) VALUES(?, ?, ?, ?, ?)", [fullname, username, email, password, role], function (err, results) {
    connection.end();

    if (err) {
      return res.status(500).json(err); //Return Error dengan HTTP status 500
    }

    return res.status(200).json(results);
  });
});

module.exports = router;
