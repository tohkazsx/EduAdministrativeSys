var mysql = require('mysql');

var connection = mysql.createConnection({
    host: '127.0.0.1',
    port: 3306,
    user: 'root',
    password: 'root123',
    database: 'teaching_mgt'
});

connection.connect(function (err) {
    if (err) throw err;
});

module.exports = connection;
