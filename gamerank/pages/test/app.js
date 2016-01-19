var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');
var routes = require('./routes/index');
//var users = require('./routes/users');
var user = require('./routes/user');
var userModel = require('./routes/userModel');
var app = express();
userModel.DBconnect();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use(session({
    secret: 'keyboard cat'
    //resave: false,
    //saveUninitialized: true,
    //cookie: { secure: true }
}));
/*app.use(function(req,res){
 //req.session.username = 0;
 })*/

app.get('/', check, showmain);
app.get('/login', showLogin);
app.get('/register', showRegister);
app.get('/mainpage', check, showMainPage);
app.get('/myreport', check, user.reportAll);
app.get('/loginout', user.logout, showLogin);
app.get('/adminMainpages', check, showAdmin);
app.get('/adminMainpage', check, showAdmin2);
app.get('/getreportAdmin', check, user.getReportAdmin);
app.get('/getDetailLastDate', check, user.getDetailLastDate);//
app.get('/getDetailu', check, user.getDetailU);
app.get('/getAllUser', check, user.getAllUser);
app.get('/getNoC', check, user.getNoCommentByDate);
app.get('/getDetail', check, user.getDetail);
app.get('/editReport', check, user.editReport);
app.get('/userManager', check, user.userManager);
//时间,获取提交人员列表
app.post('/getReportdad', check, user.getReportAdminbet);
//userManager:
app.get('/deleteUser', check, user.deleteUser);
app.get('/userAlive', check, user.aliveUser);
app.get('/userStop', check, user.stopUser);
app.get('/addAdmin', check, user.addAdmin);
app.get('/stopAdmin', check, user.cancelAdmin);

app.get('/submitReport', check, user.submitReport);//对于已经保存的周报的提交操作
//app.post('/getDetail',check,user.getDetail);
app.post('/login', user.login, addSession);
app.post('/register', user.register, addSession);
app.post('/addReport', check, user.addReport);
app.post('/saveReport', check, user.saveReport);
app.post('/editSave', check, user.editSaveReport);
app.post('/postComment', check, user.addComment);
app.post('/submitReport', check, user.submitReport);
app.post('/deleteReport', check, user.deleteReport);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function (err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function (err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});
function addSession(req, res) {
    req.session.username = req.body.username;
    if (req.session.typeU == '0') {
        res.redirect('mainpage');
    } else if (req.session.typeU == '1') {
        res.redirect('adminMainpages');
    } else if (req.session.typeU == '2') {
        res.redirect('adminMainpage');
    } else {
        res.redirect('login');
    }

}

function showLogin(req, res) {
    res.render('login');
}

function showRegister(req, res) {
    res.render('register');
}

function check(req, res, next) {
    if ('undefined' === (typeof req.session.username)) {
        res.redirect("/login");
    }
    else
        next();
}

function showMainPage(req, res) {
    res.render('mainpage');
}

function showAdmin(req, res) {
    console.log(req.session.typeU);
    if(req.session.typeU == '1'){
        res.render('adminMainpages');
    }
    else{
        var username = req.session.username;
        userModel.getUserByName(username, function (depart) {
            res.render('adminMainpages2', {depart: depart});
        })
    }
}

function showAdmin2(req, res) {
    console.log(req.session.typeU);
    if(req.session.typeU == '1'){
        res.render('adminMainpages');
    }
    else{
        var username = req.session.username;
        userModel.getUserByName(username, function (depart) {
            res.render('adminMainpages2', {depart: depart});
        })
    }

}

function showmain(req, res) {
    if (req.session.typeU == '0') {
        res.render('mainpage');
    } else if (req.session.typeU == '1') {
        res.render('adminMainpages');
    } else {
        res.render('adminMainpage');
    }
}

module.exports = app;
