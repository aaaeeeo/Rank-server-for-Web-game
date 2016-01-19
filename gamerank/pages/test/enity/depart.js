/**
 * Created by fanbaolin on 15/10/8.
 */
var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var departSchema = new Schema({
    name : {type : String,default:'unknow user'},

});
depart = mongoose.model('depart',departSchema);



module.exports = depart;










