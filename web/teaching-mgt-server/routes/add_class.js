var express = require('express');
var router = express.Router();
var db = require('../utils/mysql-conn')

router.post('/', function (req, res) {
    let sql = `insert into class values (?,?,?,?,?,0)`
    db.query(sql, [req.body.class_no, req.body.class_name, req.body.class_term, req.body.class_teach, req.body.class_depart], function (err, result) {
        if (err) {
            console.log(err.message);
            return;
        }
        // console.log(JSON.stringify(result[0]))
        res.end(JSON.stringify(result[0]));
        // res.end("Success");
    });
});

module.exports = router;
