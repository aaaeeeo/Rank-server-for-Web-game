/**
 * Created by fanbaolin on 15/9/27.
 */
/**
 * Created by Administrator on 2015/9/14.
 */
var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var userSchema = new Schema({
    name : {type : String,default:'unknow user'}
});
userList = mongoose.model('userList',userSchema);

module.exports = userList;