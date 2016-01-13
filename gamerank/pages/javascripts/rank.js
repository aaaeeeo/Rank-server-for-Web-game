/**
 * Created by fanbaolin on 16/1/10.
 */
function firstpage() {
    //alert(window.location.href);
    //window.location.href = "http://www.baidu.com"; pass
    //window.location.href = "http://www.weixingate.com/gate.php?back=http://www.baidu.com&force=1&info=none";
    window.location.href = "http://www.weixingate.com/gate.php?back=http://scut.win/views/second.html&force=1&info=force";
};

function login(){
    $.post()
}

function GetQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)","i");
    var r = window.location.search.substr(1).match(reg);
    if (r!=null) return (r[2]); return null;
}