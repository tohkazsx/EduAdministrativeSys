var express = require('express');
var router = express.Router();
var db = require('../utils/mysql-conn')

router.post('/', function (req, res) {
    let sql = `insert into teacher values (?,?,?,?,?)`
    db.query(sql, [req.body.user_no, req.body.user_name, req.body.user_sex, req.body.user_depart, req.body.user_phone], function (err, result) {
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
