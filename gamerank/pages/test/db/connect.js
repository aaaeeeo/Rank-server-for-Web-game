/**
 * Created by Administrator on 2015/9/14.
 */
var mongoose = require('mongoose');
var db = 'mongodb://localhost/test1';
var conn = mongoose.connect(db);
var Schema = mongoose.schema;
var ObjectId = schema.ObjectId;

mongoose.connection.on('connected',function(){
    console.log('Mongoose connected to '  + db);
});

mongoose.connection.on('error',function(err){
    console.log('Mongoose connection error ' + err );
});

mongoose.connection.on('disconnected',function(){
    console.log('Mongoose disconnected');
});

process.on('SIGINT',function(){
    mongoose.connect.close(function(){
        console.log('Mongoose disconnected through app termnation ');
        process.exit(0);
    });
});

exports.mongoose = mongoose;


var person = new Schema({
    name : {type : String,default:'unknow user'},
    age : {type :  Int32 },
    status : String,
    pwd : String,
    depart : String,
    report :[{date : String},
        {status : Boolean},
        {text : String}
    ]

})
