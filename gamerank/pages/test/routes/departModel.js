/**
 * Created by fanbaolin on 15/10/8.
 */
var depart = require('../enity/depart');

exports.getAllDepart = function(success,fail){
    depart.find({},function(err,data){
        if(err){
            fail();
        }else{
            success(data);
        }
    })
};

exports.addDepart = function(departName,success,fail){
    var depart = new depart();
    depart.name =departName;
    depart.create(depart,function(err){
        if(err){
            fail();
        }
        else{
            success();
        }
    })
};

exports.deleteDepart = function(departName,success,fail){
    depart.find({name:departName}).remove(function(err){
        if(err){
            fail();
        }
        else{
            success();
        }
    });
};

exports.rename = function(old,newName,success,fail){
  depart.findOne({name:old},function(err,data){
      if(err){
          fail();
      }else{
          data.name = newName;
          data.save();
          success();
      }
  })
};