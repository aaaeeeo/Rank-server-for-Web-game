/**
 * Created by fanbaolin on 16/1/27.
 */
var username;
var headimg;
var disable;
var wgateidTag;
var locationUrl;
function add(){
    locationUrl=location.href;
    $.mobile.loading("show");
    WgateJs = {};
    WgateJs.auto_auth=true;
    WgateJs.gate_options={force:1,info:"none"};
    WgateJs.ready=function(){
        var wgateid=WgateJs.getWgateid();
        wgateidTag = wgateid;
        //WgateJs.getWgateUser(function(user){alert(user)});
        //alert(wgateid);
        $.post('/login.lol',JSON.stringify({user_id: wgateid,game_token:1}),function(data){
            if(data.isexist){
                username = data.user_name;
                headimg = data.head_image;
                //alert(username);
                document.getElementById('headimg').src=headimg;
                document.getElementById('name').innerText = username;
                disable = data.disable;
            }else{
                WgateJs.getWgateUser(function(user){
                    if(user==null)
                        window.location.href = "http://www.weixingate.com/gate.php?back="+locationUrl+"&force=1&info=force";
                    document.getElementById('headimg').src=user.headimgurl;
                    document.getElementById('name').innerText = user.nickname;
                    $.post('/create_user.lol',JSON.stringify({user_id: wgateid,game_token:1,user_name:user.nickname,head_image:user.headimgurl}),function(data){
                        //if(data)
                    })
                })
            }
        });
    };
    var u=(("https:" == document.location.protocol) ? "https" : "http") + "://st.weixingate.com/";
    u=u+'st/1947';//注意每个site这里的数字不一样
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript';
    g.defer=true; g.async=true; g.src=u; s.parentNode.insertBefore(g,s);

    $.mobile.loading( "hide" );
}

function upScore(){
    var score = $("#score").text();
    alert(score);
    $.post('/upload_score.lol',JSON.stringify({user_id:wgateidTag,game_token:1,score:score}),function(data){
        if(data.success){
            alert('提交成功！');
        }else{
            alert('提交失败！');
        }
    })
}

function getRanklist(){
    $.get('/get_rank.lol',{user_id:wgateidTag,game_token:1},function(data){
        for(var i=0;i<data.length;i++){
            $('<div>'+data[i].user_name+'===='+data[i].rank+'</div>').insertAfter('#rankList');
        }
    })
}
function rankList(){

}
function load(){
    upScore();
    getRanklist();
}
    $(document).ready(function(){

        $("#dialog").load("/sys/rankDialog.html");
    });
$(window).load(function(){
    add();
});
//$('.new-game').on('click', rankList);
