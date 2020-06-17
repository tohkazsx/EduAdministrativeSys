var express = require('express');
var router = express.Router();
var db = require('../utils/mysql-conn')

router.post('/', function (req, res, next) {
    // 调用procedure, 返回结果为数组, 数组元素为数组, 然后才是行数据
    let sql = "call reset_password_proc(?, ?)";
    db.query(sql, [req.body.username, req.body.password], function (err, result) {
        if (err) {
            console.log(err.message);
            return;
        }
        // console.log(result);
        // console.log(JSON.stringify(result[0][0]));
        // res.end(JSON.stringify(result[0][0]));
        res.end("Success");
    });
});


module.exports = router;