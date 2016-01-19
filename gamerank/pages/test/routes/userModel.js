/**
 * Created by Administrator on 2015/9/17.
 */


//date:yyyy-MM-dd

var user = require('../enity/user');
var userList = require('../enity/userList');
exports.DBconnect = function () {
    var dbURL = 'mongodb://localhost/test1';
    var db = require('mongoose').connect(dbURL);
    return db;
};

exports.DBdisconnect = function (db) {
    db.disconnect();
};

exports.loginCheck = function (username, password, success, fail) {
    user.findOne({name: username}, function (err, record) {
        if (err) {
            fail();
            return;
        }
        if (!record) {
            fail();
            return;
        }
        if (record.password == password && record.status == '0') {
            success(record.typeU);
        } else {
            if (record.status != '0') {
                fail(2);
            }
            else {
                fail(1);
            }
        }
    });

};

exports.loginType = function (username, success, fail) {
    user.findOne({name: username}, function (err, record) {
        if (err) {
            fail();
            return;
        }
        if (!record) {
            fail();
            return;
        } else {
            console.log(record.typeU);
            if (record.typeU == '0') {
                success(0);
            } else {
                success(1);
            }
        }
    })
};

exports.getUserByName = function (username, success, fail) {
    user.findOne({name: username}, function (err, data) {
        if (err) {
            fail();
        } else {
            success(data.depart);
        }
    })
};

exports.register = function (username, password, depart, success, fail) {
    var instance = new user();
    instance.name = username;
    instance.password = password;
    instance.depart = depart;
    instance.status = '1';
    user.create(instance, function (err) {
        if (err) {
            fail();
            return;
        }
        else {
            success();
            return;
        }
    });
    var instanceU = new userList();
    instanceU.name = username;
    userList.create(instanceU, function (err) {
        if (err) {
            return;
        }
        return;
    });
};
//��������ʵ��
exports.changePassword = function (username, password, newPassword, success, fail) {

};

//usermanger
exports.aliveUser = function (username, success, fail) {
    console.log(username);
    user.update({_id: username}, {status: '0'}, function (err) {
        if (err) {
            fail();
        } else {
            user.findOne({name:username},function(err,data){
                console.log(data);

                success();
            });
        }
    })
};
exports.isAdmin = function (username, success, fail) {
    username = username.trim();
    user.findOne({name: username}, function (err, data) {
        if (err) {
            fail();
        } else {
            if (data==null||data.typeU == '0') {
                fail();
            } else {
                success();
            }
        }
    })
};


exports.stopUser = function (username, success, fail) {
    user.update({_id: username}, {status: '1'}, function (err) {
        if (err) {
            fail();
        }
        else {
            success();
        }
    })
};

exports.addAdmin = function (username, success, fail) {
    user.update({_id: username}, {typeU: '2'}, function (err) {
        if (err) {
            fail();
        } else {
            success();
        }
    })
};

exports.cancelAdmin = function (username, success, fail) {
    user.update({_id: username}, {typeU: '0'}, function (err) {
        if (err) {
            fail();
        } else {
            success();
        }
    })
};

exports.deleteUser = function (username, success, fail) {
    user.remove({_id: username}, function (err) {
        if (err) {
            fail();
        } else {
            success();
        }
    })
};

exports.getAllUser = function (depart, success, fail) {
    console.log(depart);
    user.find({depart: depart, typeU: '0'}, function (err, result) {
        if (err) {
            fail();
        } else {
            console.log(result);
            success(result);
        }
    })
};

exports.addReport = function (username, reportMsg, reportMsg2, reportMsg3, time, success, fail) {
    var report = {date: time, text: reportMsg, text2: reportMsg2, text3: reportMsg3, submit: true};
    console.log('report : ' + report);
    console.log(time);
    user.findOne({name: username}, function (err, result) {
        if (err) {
            fail();
            return;
        }
        if (result.lastAdd != null && result.lastAdd.getDate() == time.getDate() && result.lastAdd.getMonth() == time.getMonth()
            && result.lastAdd.getFullYear() == time.getFullYear()) {
            fail();
            return;
        }
        else {
            result.report.push(report);
            result.save();
            user.update({name: username}, {'lastAdd': time}, function (err, fu) {
                if (err) {
                    fail();
                    return;
                }
                success();
                return;
            });
        }
    })
};
//���ݿ�洢ΪendDate
exports.getReport = function (username, startDate, endDate, success, fail) {
    user.findOne({name: username}, function (err, result) {
        if (err) {
            fail();
            return;
        }
        console.log(result);
        if (result.report.length == 0) {
            fail();
            return;
        } else {
            var temp = -1;
            console.log(result);
            for (var i = 0; i < result.report.length; i++) {
                if (result.report.date == endDate) {
                    temp = i;
                    break;
                }
            }
            success(result.report[0]);
            return;
        }
    })
};


//getReport admin
//未使用
exports.getReportByDateBt = function (timeStart, timeEnd, success, fail) {
    // userList.find()
    timeStart = timeStart + "T00:00:00.510Z";
    timeEnd = timeEnd + "T11:59:59.510Z";
    console.log(timeStart + ':::' + timeEnd + "datnow:" + new Date());
    success();
};


//�����ܱ��б�(�����б�)��ָ���û���ָ����
//获取一个用户的所有周报
exports.getReportList = function (username, success, fail) {
    var query = {};
    if (username) {
        query = {name: username};
    }
    user.find(query, function (err, result) {
        if (result.length > 0) {
            success(result);
        } else {
            fail();
        }
    })
};


exports.comment = function (username, reportId, commentString, success, fail) {
    console.log(username + reportId + commentString);
    user.update({'name': username, 'report._id': reportId}, {
        '$set': {
            'report.$.comment': commentString,
            'report.$.status': true
        }
    }, function (err) {
        if (err) {
            fail();
        } else {
            success();
        }
    })
};

//测试用
exports.getReportByDate = function (date, success, fail) {
    user.find({'report.status': 0}, function (err, record) {
        success(record);
    })
};
//return date-->user set
exports.getUserLastDate = function (date, depart, success, fail) {
    var year = date.substring(0, 4);
    var month = date.substring(5, 7);
    var day = date.substring(8, 10);
    var monthInt = parseInt(month, 10);
    if (monthInt > 1) {
        monthInt -= 1;
    } else {
        monthInt = 12;
    }
    month = '' + monthInt;
    var now = new Date(year, month, day);
    var tom = new Date(year, month, day);
    tom.setDate(tom.getDate() + 1);
    user.find({typeU: '0', depart: depart, lastAdd: {"$gte": now, "$lt": tom}}, function (err, result) {
        if (err) {
            fail();
            return;
        }
        success(result);
    });
};

//获取某一个用户的确定日期周报
//传入参数:username,dateSelected
//返回:report instance
exports.getDetailLastDate = function (username, dateSelected, success, fail) {
    var year = dateSelected.substring(0, 4);
    var month = dateSelected.substring(5, 7);
    var day = dateSelected.substring(8, 10);
    var monthInt = parseInt(month, 10);
    if (monthInt > 1) {
        monthInt -= 1;
    } else {
        monthInt = 12;
    }
    month = '' + monthInt;
    var now = new Date(year, month, day);
    user.findOne({name: username}, function (err, result) {
        if (err || result.length == 0) {
            fail();
        }
        var report = result.report;
        //var LastDate = result.lastAdd;
        var lengthR = report.length;
        var tag = -1;
        for (var i = 0; i < lengthR; i++) {
            if (report[i].date.getDate() == now.getDate() && report[i].date.getMonth() == now.getMonth()
                && report[i].date.getFullYear() == now.getFullYear()) {
                tag = i;
                break;
            }
        }
        console.log(tag);
        if (tag > -1) {
            success(report[tag]);
        } else {
            fail();
        }
    })
};
//获取用户最后提交的report
exports.getDetailByNameLastDate = function (username, success, fail) {
    user.findOne({name: username}, function (err, result) {
        if (err || result.length == 0) {
            fail();
        }
        var report = result.report;
        var LastDate = result.lastAdd;
        var lengthR = report.length;
        var tag = -1;
        for (var i = 0; i < lengthR; i++) {
            if (report[i].date.getDate() == LastDate.getDate() && report[i].date.getMonth() == LastDate.getMonth()
                && report[i].date.getFullYear() == LastDate.getFullYear()) {
                tag = i;
                break;
            }
        }
        if (tag > 0) {
            success(report[tag]);
        } else {
            fail();
        }
    })
};

//no comment
//获取指定日期的未审批用户
//传入参数:date,dapart(部门)
//返回:user对象数组
exports.getReportNoCommentByDate = function (date, depart, success, fail) {
    var year = date.substring(0, 4);
    var month = date.substring(5, 7);
    var day = date.substring(8, 10);
    var monthInt = parseInt(month, 10);
    if (monthInt > 1) {
        monthInt -= 1;
    } else {
        monthInt = 12;
    }
    month = '' + monthInt;
    var now = new Date(year, month, day);
    var tom = new Date(year, month, day);
    tom.setDate(tom.getDate() + 1);
    console.log(now);
    console.log(tom);
    console.log(depart);
    user.find({
        depart: depart,
        typeU: '0',
        'report.date': {"$gte": now, "$lt": tom},
        'report.status': false
    }, function (err, result) {
        if (err) {
            fail();
            return;
        }
        success(result);
    });
};
//返回name:name,type:usertype
exports.getUserListByDepart = function (username, success, fail) {
    console.log('getUserListByDepart :' + username);
    user.findOne({'name': username}, function (err, data) {
        if (err) {
            fail();
        } else {
            user.find({'depart': data.depart}, function (err, dataU) {
                if (err || dataU.length <= 0) {
                    fail();
                }
                else {
                    var userArray = [];
                    var userLength = dataU.length;
                    for (var i = 0; i < userLength; i++) {
                        if (dataU[i].name != username) {
                            userArray.push({
                                name: dataU[i].name,
                                status: dataU[i].status,
                                id: dataU[i]._id,
                                typeU: dataU[i].typeU
                            });
                        }
                    }
                    success(userArray, data.depart, data.typeU);
                }
            })
        }
    });
};


/*********************user manager****************/
//用户激活 status = '1'
exports.userAlive = function (username, success, fail) {
    user.findOne({name: username}, function (err, data) {
        if (err) {
            fail();
        }
        else {
            data.status = '1';
            data.save();
            success();
        }
    })
};

//离职 status = '2'
exports.userOut = function (username, success, fail) {
    user.update({name: username}, {status: '2'}, function (err) {
        if (err) {
            fail();
        } else {
            success();
        }
    });
};

/*********************report ****************/

exports.saveReport = function (time, username, text1, text2, text3, success, fail) {
    var report = {text: text1, text2: text2, text3: text3};
    user.findOne({name: username}, function (err, result) {
        if (err) {
            fail();
            return;
        }
        else {
            result.report.push(report);
            result.save();
            success();
        }
    })
};

exports.submitReport = function (username, reportId, time, success, fail) {
    user.update({'name': username, 'report._id': reportId}, {
        '$set': {
            'lastAdd': time,
            'report.$.submit': true,
            'report.$.date': time
        }
    }, function (err) {
        if (err) {
            fail();
        } else {
            success();
        }
    })
};

exports.editReport = function (username, reportId, text1, text2, text3, success, fail) {
    user.update({'name': username, 'report._id': reportId}, {
        '$set': {
            'report.$.text': text1,
            'report.$.text2': text2,
            'report.$.text3': text3
        }
    }, function (err) {
        if (err) {
            fail();
        } else {
            success();
        }
    })
};

exports.deleteReport = function (username, reportId, success, fail) {
    console.log(reportId);
    /*user.findOne({'name': username}, function (err, data) {
     if (err) {
     fail();
     } else {
     data.report.pull({'_id': reportId});
     success();
     }
     })*/
    user.update({'name': username},
        {$pull: {'report': {'_id': reportId}}}, function (err, val) {
            if (err) {
                console.log(err);
                fail();
            } else {
                success();
            }
        }
    )
};

exports.test = function (success, fail) {
    user.aggregate([
        {
            $group: {
                _id: '$depart',  //$region is the column name in collection
                count: {$sum: 1},
                user: {
                    $push: {
                        'name': '$name', 'status': '$status', 'typeU': '$typeU', '_id': '$_id'
                    }
                }
            }
        }
    ], function (err, result) {
        if (err) {
            console.log(err);
            fail();
        } else {
            success(result);
        }
    });
};
