/**
 * Created by Administrator on 2015/9/14.
 */
var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var report = new Schema({
    date: {type: Date, default: Date.now()},
    status: Boolean,
    text: String
});
var userSchema = new Schema({
    name: {type: String, default: 'unknow user'},
    typeU: {type: String, default: '0'},
    age: {type: String},
    status: {type: String, default: '0'},
    password: {type: String},
    depart: {type: String},
    lastAdd: {type: Date, default: null},
    report: [{
        date: {type: Date, default: Date.now()},
        status: {type: Boolean, default: false},
        text: String,
        text2: String,
        text3: String,
        comment: String,
        submit: {type: Boolean, default:false}
    }]
});
user = mongoose.model('student', userSchema);


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
module.exports = user;










