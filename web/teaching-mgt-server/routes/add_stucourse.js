var express = require('express');
var router = express.Router();
var db = require('../utils/mysql-conn')

router.post('/', function (req, res) {
    let sql = `insert into score values (?,?,0)`
    db.query(sql, [req.body.user_no, req.body.course_no], function (err, result) {
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
