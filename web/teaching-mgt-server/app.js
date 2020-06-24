var createError = require('http-errors')
var express = require('express')
var path = require('path')
var cookieParser = require('cookie-parser')
var logger = require('morgan')

var app = express()

// view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')

// CORS config here
app.all('/*', function (req, res, next) {
  // CORS headers
  res.header("Access-Control-Allow-Origin", "*") // restrict it to the required domain
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
  // Set custom headers for CORS
  res.header('Access-Control-Allow-Headers', 'Content-type,Accept,X-Access-Token,X-Key')
  if (req.method == 'OPTIONS') {
    res.status(200).end()
  } else {
    next()
  }
})

app.use(logger('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(express.static(path.join(__dirname, 'public')))

// routers
app.use('/resetpass', require('./routes/reset_pass'))
app.use('/login', require('./routes/login'))
app.use('/getuserinfo', require('./routes/get_userinfo'))
app.use('/getadminsinfo', require('./routes/get_admins'))
app.use('/getteachersinfo', require('./routes/get_teachers'))
app.use('/getstudentsinfo', require('./routes/get_students'))
app.use('/getdepartmentinfo', require('./routes/get_depart'))
app.use('/getclassinfo', require('./routes/get_class'))
app.use('/getcourse', require('./routes/get_course'))
app.use('/getstucourse', require('./routes/get_stu_course'))
app.use('/getteachcourse', require('./routes/get_teach_course'))
app.use('/addnewadmin', require("./routes/add_admin"))
app.use('/addnewteacher', require("./routes/add_teacher"))
app.use('/addnewstudent', require("./routes/add_student"))
app.use('/addnewdepart', require('./routes/add_depart'))
app.use('/addnewclass', require('./routes/add_class'))
app.use('/addnewcourse', require('./routes/add_course'))
app.use('/getoptioncourse', require('./routes/get_stuoptioncourse'))
app.use('/addstucourse', require('./routes/add_stucourse'))
app.use('/addstuscore', require('./routes/update_stuscore'))

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404))
})

// error handler
app.use(function(err, req, res) {
  // set locals, only providing error in development
  res.locals.message = err.message
  res.locals.error = req.app.get('env') === 'development' ? err : {}

  // render the error page
  res.status(err.status || 500)
  res.render('error')
})

module.exports = app
