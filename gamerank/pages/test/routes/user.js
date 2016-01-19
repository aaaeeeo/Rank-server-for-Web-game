/**
 * Created by Administrator on 2015/9/15.
 */
//date:yyyy-MM-dd
var userModel = require('./userModel');

module.exports.login = function (req, res, next) {
    console.log('info : method login : ' + req.body.username);
    //next();
    var username = req.body.username;
    var password = req.body.password;
    userModel.loginCheck(username, password, function (isAdmin) {
        console.log(username);
        console.log(password);
        req.session.typeU = isAdmin;
        next();
        //res.render('mainpage');
    }, function (tag) {
        if (tag == 2) {
            //未激活用户
            res.render('statusNo');
        } else {
            //密码错误
            res.render('login');
        }
    })
};

module.exports.loginType = function (username) {
    userModel.loginType(username, function (isAdmin) {
        if (isAdmin) {
            return true;
        }
        else {
            return false;
        }
    })
};

module.exports.getAllUser = function (req, res) {
    var depart = req.query.depart;
    userModel.getAllUser(depart, function (result) {
        var length = result.length;
        var userArr = [];
        for (var i = 0; i < length; i++) {
            userArr.push(result[i].name);
        }
        res.send(userArr)
    }, function () {
        res.send([]);
    })
};

module.exports.register = function (req, res, next) {
    var username = req.body.username;
    var pwd = req.body.password;
    var depart = req.body.depart;
    userModel.register(username, pwd, depart, function () {
        //res.render('mainpage');
        next();
    }, function () {
        res.render('register', {title1: username});
    });
    //res.render('mainpage');
};

module.exports.deleteReport = function (req, res) {
    var username = req.session.username;

    var reportId = req.body.reportId;
    console.log(reportId);
    var msg = {isSuccess: false};
    userModel.deleteReport(username, reportId, function () {
        msg.isSuccess = true;
        res.send(msg);
    }, function () {
        res.send(msg);
    })
};

module.exports.addReport = function (req, res) {
    var username = req.session.username;
    var reportMsg = req.body.reportMsg;
    var reportMsg2 = req.body.reportMsg2;
    var reportMsg3 = req.body.reportMsg3;
    //data:���ڵ�ʱ��
    //var time = new Date().Format("yyyy-MM-dd");
    var time = new Date();
    userModel.addReport(username, reportMsg, reportMsg2, reportMsg3, time, function () {
        res.render('success', {infom: '添加周报成功', title: '添加周报成功'});
    }, function () {
        res.render('success', {infom: '添加周报失败,请检查本周周报是否已经提交', title: '添加失败'});
    });
};


module.exports.editSaveReport = function (req, res) {
    var username = req.session.username;
    var reportMsg = req.body.text1;
    var reportMsg2 = req.body.text2;
    var reportMsg3 = req.body.text3;
    var reportId = req.body.reportId;
    var msg = {isSuccess: false};
    userModel.editReport(username, reportId, reportMsg, reportMsg2, reportMsg3, function () {
        msg.isSuccess = true;
        res.send(msg);
    }, function () {
        res.send(msg);
    })
};

module.exports.saveReport = function (req, res) {
    var username = req.session.username;
    var reportMsg = req.body.text1;
    var reportMsg2 = req.body.text2;
    var reportMsg3 = req.body.text3;
    var time = new Date();
    userModel.saveReport(time, username, reportMsg, reportMsg2, reportMsg3, function () {
        res.render('success', {infom: '保存周报成功', title: '保存周报成功'});
    }, function () {
        res.render('success', {infom: '添加周报失败,请检查本周周报是否已经提交或者已经保存', title: '添加失败'});
    })
};
//对于已经保存的周报,可以选择提交
module.exports.submitReport = function (req, res) {
    var username = req.session.username;
    var reportId = req.query.reportId;
    var time = new Date();
    userModel.submitReport(username, reportId, time, function () {
        res.render('success', {infom: '提交周报成功', title: '提交周报成功'});
    }, function () {
        res.send('提交失败');
    })
};


//admin
module.exports.getReport = function (req, res) {
    var username = req.session.username;
    var startDate = req.body.startDate;
    var endDate = req.body.endDate;
    userModel.getReport(username, startDate, endDate, function (data) {
        res.render('myReport');
    }, function () {
        res.render('error');
    })
};
//userReport
module.exports.reportAll = function (req, res) {
    var username = req.session.username;
    userModel.getReportList(username, function (data) {
        var title = username + '的周报';
        res.render('myReport', {title1: title, supplies: data[0].report});
    }, function () {
        res.send('error');
    });
};

module.exports.getDetail = function (req, res) {
    var id = req.query.id;
    var username = req.session.username;
    userModel.getReportList(username, function (data) {
        var length = data[0].report.length;
        var tag = -1;
        for (var i = 0; i < length; i++) {
            if (data[0].report[i]._id == id) {
                tag = i;
                break;
            }
        }
        if (tag == -1) {
            res.send('no data');
        } else {
            res.render('myReportDetail', {
                title1: username,
                username: username,
                depart: data[0].depart,
                report: data[0].report[tag],
                rDate: data[0].report[tag].date.Format("yyyy-MM-dd")
            });
        }

    }, function () {
        res.send('no data');
    })
};

module.exports.editReport = function (req, res) {
    var id = req.query.id;
    var username = req.session.username;
    userModel.getReportList(username, function (data) {
        var length = data[0].report.length;
        var tag = -1;
        for (var i = 0; i < length; i++) {
            if (data[0].report[i]._id == id) {
                tag = i;
                break;
            }
        }
        if (tag == -1) {
            res.send('no data');
        } else {
            res.render('editReport', {
                title: username,
                username: username,
                report: data[0].report[tag],
                rDate: data[0].report[tag].date.Format("yyyy-MM-dd")
            });
        }
    })
};


//admin
module.exports.getDetailU = function (req, res) {
    var username = req.query.username;
    var dateSelected = req.query.timeSelected;
    userModel.getDetailLastDate(username, dateSelected, function (data) {
        res.render('DetailReportAdmin', {username: username, report: data, selectedDate: dateSelected});
    }, function () {
        res.send('error');
    })
};
//admin
module.exports.getReportAdmin = function (req, res) {
    var time = new Date().Format("yyyy-MM-dd");
    userModel.getReportByDate(time, function (data) {
        res.send(data);
    }, function () {
        res.send('error');
    })
};

//admin
//根据admin的部门来获取下属用户列表
module.exports.userManager = function (req, res) {
    var username = req.session.username;
    userModel.getUserListByDepart(username, function (data, depart, typeU) {
        //console.log(data[1]);
        //console.log(data[0]);
        //typeU: type of optr
        if (typeU == '1') {
            userModel.test(function (dataT) {
                var dataLength = dataT.length;
                for (var i = 0; i < dataLength; i++) {
                    var itemLength = dataT[i].count;
                    dataT[i].user.sort(function (a, b) {
                        return parseFloat(b.typeU) - parseFloat(a.typeU);
                    });
                }
                res.render('userMangerAll', {'data': dataT, 'typeU': typeU, 'name': username});
                //res.send(data);
            }, function () {
                res.render('error');
            });
        } else {
            res.render('userManager', {'supplies': data, 'depart': depart, 'typeU': typeU});
        }
    }, function () {
        res.render('error');
    });
};

//admin
module.exports.addAdmin = function (req, res) {
    var optUser = req.session.username;
    var id = req.query.id;
    var isSuccess = {isSuccess: false};
    userModel.isAdmin(optUser, function () {
        userModel.addAdmin(id, function () {
            isSuccess.isSuccess = true;
            res.send(isSuccess);
        }, function () {
            res.send(isSuccess);
        })
    }, function () {
        res.send(isSuccess);
    })
};

module.exports.cancelAdmin = function (req, res) {
    var optUser = req.session.username;
    var id = req.query.id;
    var isSuccess = {isSuccess: false};
    userModel.isAdmin(optUser, function () {
        userModel.cancelAdmin(id, function () {
            isSuccess.isSuccess = true;
            res.send(isSuccess);
        }, function () {
            res.send(isSuccess);
        })
    }, function () {
        res.send(isSuccess);
    })
};

module.exports.aliveUser = function (req, res) {
    var optUser = req.session.username;
    var id = req.query.id;
    console.log(optUser);
    var isSuccess = {isSuccess: false};
    userModel.isAdmin(optUser, function () {
        userModel.aliveUser(id, function () {
            isSuccess.isSuccess = true;
            console.log(isSuccess);
            res.send(isSuccess);
        }, function () {
            console.log(isSuccess);
            res.send(isSuccess);
        })
    }, function () {
        res.send(isSuccess);
    })
};

module.exports.stopUser = function (req, res) {
    var optUser = req.session.username;
    var id = req.query.id;
    var isSuccess = {isSuccess: false};
    userModel.isAdmin(optUser, function () {
        userModel.stopUser(id, function () {
            isSuccess.isSuccess = true;
            res.send(isSuccess);
        }, function () {
            res.send(isSuccess);
        })
    }, function () {
        res.send(isSuccess);
    })
};

module.exports.deleteUser = function (req, res) {
    var optUser = req.session.username;
    var id = req.query.id;
    var isSuccess = {isSuccess: false};
    userModel.isAdmin(optUser, function () {
        userModel.deleteUser(id, function () {
            isSuccess.isSuccess = true;
            res.send(isSuccess);
        }, function () {
            res.send(isSuccess);
        })
    }, function () {
        res.send(isSuccess);
    })
};

//获取选择时间的提交人员
module.exports.getReportAdminbet = function (req, res) {
    var timeStart = req.body.timeSelect;
    var depart = req.body.depart;
    userModel.getUserLastDate(timeStart, depart, function (result) {
        var userSubmit = [];
        var resultLen = result.length;
        for (var i = 0; i < resultLen; i++) {
            userSubmit.push(result[i].name);
        }
        res.send(userSubmit);
    }, function () {
        res.send('error');
    })

};

module.exports.getNoCommentByDate = function (req, res) {
    console.log(depart);
    var depart = req.query.depart;
    var timeSe = req.query.timeSelect;
    userModel.getReportNoCommentByDate(timeSe, depart, function (result) {
        var userNoSubmit = [];
        var resultLen = result.length;
        for (var i = 0; i < resultLen; i++) {
            userNoSubmit.push(result[i].name);
        }
        console.log(userNoSubmit);
        res.send(userNoSubmit);
    })

};

module.exports.getDetailLastDate = function (req, res) {
    var username = req.query.username;
    userModel.getUserLastDate(username, function (data) {
        res.send(data);
    }, function () {
        res.send('error');
    })
};

module.exports.addComment = function (req, res) {
    var username = req.body.username;
    var id = req.body.reportId;
    var commentStr = req.body.commentStr;
    userModel.comment(username, id, commentStr, function () {
        res.send({msg: '1'});
    }, function () {
        res.send({msg: '0'});
    })
};

//
module.exports.logout = function (req, res, next) {

    req.session.destroy();
    next();
};

Date.prototype.Format = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1, //�·�
        "d+": this.getDate(), //��
        "h+": this.getHours(), //Сʱ
        "m+": this.getMinutes(), //��
        "s+": this.getSeconds(), //��
        "q+": Math.floor((this.getMonth() + 3) / 3), //����
        "S": this.getMilliseconds() //����
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};
