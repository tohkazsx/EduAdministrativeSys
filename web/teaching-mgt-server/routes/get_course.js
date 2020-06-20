var express = require('express');
var router = express.Router();
var db = require('../utils/mysql-conn')

router.post('/', function (req, res) {
    let sql = `call get_course_proc()`
    db.query(sql, [], function (err, result) {
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
