var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var jwt = require('jsonwebtoken');

var opt = {
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'banboo_app'
};

// middleware
function verifyToken(req, res, next){
  var token = req.headers.token;
  if(!token){
    return res.status(401).send('Unauthorized access!');
  }
  try {
    jwt.verify(token, 'SECRET KEY');
    next();
  }catch (e) {
    return res.status(401).send('Unauthorized access!');
  }
}

router.get('/', verifyToken, function (req, res, next) {

    var connection = mysql.createConnection(opt);
  
    connection.connect();
  
    // QUERY
    connection.query("SELECT * FROM msbanboo", function (err, results) {
      connection.end();
  
      if (err) {
        return res.status(500).json(err); //Return Error dengan HTTP status 500
      }

      results.forEach(result => {
        if(result.banboo_image){
          result.banboo_image = Buffer.from(result.banboo_image).toString('base64');
        }
      });
  
      return res.status(200).json(results);
    });
});

router.get('/:banboo_id', function (req, res, next) {

  var banboo_id = req.params.banboo_id
  var connection = mysql.createConnection(opt);

  connection.connect();

  // QUERY
  connection.query("SELECT * FROM msbanboo JOIN elements WHERE msbanboo.element_id = elements.element_id AND msbanboo.banboo_id = ?", [banboo_id],function (err, results) {
    connection.end();

    if (err) {
      return res.status(500).json(err); //Return Error dengan HTTP status 500
    }

    results.forEach(result => {
      if(result.banboo_image){
        result.banboo_image = Buffer.from(result.banboo_image).toString('base64');
      }
    });

    return res.status(200).json(results);
  });
});

router.get('/search/:prefix', verifyToken, function (req, res, next) {

  var prefix = req.params.prefix
  var connection = mysql.createConnection(opt);

  connection.connect();

  // QUERY
  connection.query("SELECT * FROM msbanboo WHERE banboo_name LIKE ?", [`%${prefix}%`],function (err, results) {
    connection.end();

    if (err) {
      return res.status(500).json(err); //Return Error dengan HTTP status 500
    }

    results.forEach(result => {
      if(result.banboo_image){
        result.banboo_image = Buffer.from(result.banboo_image).toString('base64');
      }
    });

    return res.status(200).json(results);
  });
});

router.get('/search-by-rank/:rank', verifyToken, function (req, res, next) {

  var rank = req.params.rank
  var connection = mysql.createConnection(opt);

  connection.connect();

  // QUERY
  connection.query("SELECT * FROM msbanboo WHERE rank LIKE ?", [rank],function (err, results) {
    connection.end();

    if (err) {
      return res.status(500).json(err); //Return Error dengan HTTP status 500
    }

    results.forEach(result => {
      if(result.banboo_image){
        result.banboo_image = Buffer.from(result.banboo_image).toString('base64');
      }
    });

    return res.status(200).json(results);
  });
});

router.post('/insert', verifyToken, function (req, res, next) {
  var connection = mysql.createConnection(opt);

  connection.connect();
  var { banboo_name, price, rank, level, hp, atk, def, impact, crit_rate, crit_dmg, pen_ratio, anomaly_mastery, element_id, banboo_desc, banboo_image } = req.body;
  const imageBuffer = banboo_image ? Buffer.from(banboo_image, 'base64') : null;
  connection.query(
    "INSERT INTO msbanboo(banboo_name, price, rank, level, hp, atk, def, impact, crit_rate, crit_dmg, pen_ratio, anomaly_mastery, element_id, banboo_desc, banboo_image) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    [banboo_name, price, rank, level, hp, atk, def, impact, crit_rate, crit_dmg, pen_ratio, anomaly_mastery, element_id, banboo_desc, imageBuffer], function (err, results) {
      connection.end();

      if (err) {
        return res.status(500).json(err); //Return Error dengan HTTP status 500
      }

      return res.status(200).json(results);
    });
});

router.post('/update/:banboo_id', function(req, res, next){
  var connection = mysql.createConnection(opt);
  var banboo_id = req.params.banboo_id;
  
  connection.connect();
  var {banboo_name, price, rank, level, hp, atk, def, impact, crit_rate, crit_dmg, pen_ratio, anomaly_mastery, banboo_desc, banboo_image} = req.body;
  const imageBuffer = banboo_image ? Buffer.from(banboo_image, 'base64') : null;
  connection.query(
      "UPDATE msbanboo SET banboo_name = ?, price = ?, rank = ?, level = ?, hp = ?, atk = ?, def = ?, impact = ?, crit_rate = ?, crit_dmg = ?, pen_ratio = ?, anomaly_mastery = ?, banboo_desc = ?, banboo_image = ? WHERE banboo_id = ?", 
      [banboo_name, price, rank, level, hp, atk, def, impact, crit_rate, crit_dmg, pen_ratio, anomaly_mastery, banboo_desc, imageBuffer, banboo_id], function (err, results) {
      connection.end();
  
      if (err) {
        return res.status(500).json(err); //Return Error dengan HTTP status 500
      }
  
      return res.status(200).json(results);
    });
});

router.delete('/delete/:banboo_id', function(req, res, next){
  var banboo_id = req.params.banboo_id;
  var connection = mysql.createConnection(opt);

  connection.connect();

  connection.query(
      "DELETE FROM msbanboo WHERE banboo_id = ?",
      [banboo_id], function (err, results) {
      connection.end();
  
      if (err) {
        return res.status(500).json(err); //Return Error dengan HTTP status 500
      }
  
      return res.status(200).json(results);
    });
});

module.exports = router;