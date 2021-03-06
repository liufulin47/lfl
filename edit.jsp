<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>用户信息</title>

	<link rel="stylesheet" href="plug-in/element-ui/css/index.css">
	<link rel="stylesheet" href="plug-in/element-ui/css/elementui-ext.css">
    <link rel="stylesheet" href="plug-in/bootstrap/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="plug-in/bootstrap-table/dist/bootstrap-table.min.css">
	<script src="plug-in/vue/vue.js"></script>
	<script src="plug-in/vue/vue-resource.js"></script>
	<script src="plug-in/element-ui/index.js"></script>
	<!-- Jquery组件引用 -->
	<script src="plug-in/jquery/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="plug-in/jquery-plugs/i18n/jquery.i18n.properties.js"></script>
	<script type="text/javascript" src="plug-in/mutiLang/zh-cn.js"></script>
	<script type="text/javascript" src="plug-in/lhgDialog/lhgdialog.min.js?skin=metrole"></script>
	<script type="text/javascript" src="plug-in/tools/curdtools.js"></script>
	<script type="text/javascript" src="webpage/movie/layui/layui.js"></script>
    <link rel="stylesheet" href="webpage/movie/layui/css/layui.css">

<style type="text/css">
body {
	font-family: '微软雅黑', "宋体",12px;
    color: #333333;
}
table {
    border-collapse: separate;
    border-spacing: 1px;
}
td {
    display: table-cell;
    vertical-align: inherit;
    border:0px solid #333333;
}
input{
	padding: 5px 0px 5px 3px;
	background: #fff8f8;
}
.value {
    background-color: #FFFFFF;
    padding: 5px;
}
.filedzt{
	font-size: 12px;
	color: #333333;
}
.Validform_checktip{
	font-size: 12px;
	color: #999999;
}
</style>

</head>
<body style="overflow-y: hidden" scroll="no">
	<form id="formobj" refresh="false" dialog="true" action="javascript:submit();" usePlugin="password" layout="table">
		<input id="id" type="hidden" value="${user.id }">
		<table cellpadding="0" cellspacing="1" class="formtable">
			<tbody>
			<tr>
				<td align="right" width="30%" class="value">
					<span class="filedzt">用户账号:</span>
				</td>
				<td class="value" width="70%">
					<input id="userName" type="text" name="userName" class="inputxt" datatype="*" value="${user.userName }" disabled="disabled" /> 
				</td>
			</tr>
			<tr>
				<td align="right">
					<span class="filedzt">用户名称:</span>
				</td>
				<td class="value">
					<input id="realName" type="text" name="realName" class="inputxt" datatype="*6-18" value="${user.realName }" /> 
				</td>
			</tr>
			<tr>
				<td align="right">
					<span class="filedzt">手机号码:</span>
				</td>
				<td class="value">
					<input id="mobilePhone" type="text" name="mobilePhone" class="inputxt" datatype="*6-18" value="${user.mobilePhone }" > 
				</td>
			</tr>
			<tr>
				<td align="right">
					<span class="filedzt">办公电话:</span>
				</td>
				<td class="value">
					<input id="officePhone" type="text" name="officePhone" class="inputxt" datatype="*6-18" value="${user.officePhone }" > 
				</td>
			</tr>
			<tr>
				<td align="right">
					<span class="filedzt">邮箱地址:</span>
				</td>
				<td class="value">
					<input id="email" type="text" name="email" class="inputxt" datatype="*6-18" value="${user.email}" > 
				</td>
			</tr>
			</tbody>
		</table>
		<button type="submit" id ="btn_sub" style="display:none;"></button>
</form>

<script type="text/javascript">
layui.use('layer', function() { //独立版的layer无需执行这一句
    var $ = layui.jquery, layer = layui.layer; //独立版的layer无需执行这一句
})

	function submit(){
		var id = $("#id").val();
		if(id == null || id == ""){
			layer.alert("页面加载错误")
			return false;
		}
		
		var userName = $("#userName").val()||"";
		if(userName == null || userName == ""){
			layer.alert("页面加载错误")
			return false;
		}
		
		var realName = $("#realName").val()||"";
		if(realName == null || realName == ""){
			layer.alert("姓名不能为空")
			return false;
		}
		
		var mobilePhone = $("#mobilePhone").val()||"";
		
		var officePhone = $("#officePhone").val()||"";
		
		var email = $("#email").val()||"";
		
		var savenewpwd="userController.do?update";//验证路径
		
		var data = {id:id,userName:userName,realName:realName,mobilePhone:mobilePhone,officePhone:officePhone,email:email};
		
		$.ajax({
            async : false,
            cache : false,
            type : 'POST',
            url : savenewpwd,// 请求的action路径
            data : data,
            error : function() {// 请求失败处理函数
            },
            success : function(data) {

                var infoObj=   JSON.parse(data)
                if(infoObj.msg=="操作成功"){
                    layer.alert("修改成功", {
                    	icon: 1,
                    	end: function () {
                    		frameElement.api.close();
                    	}
                    });
                }else{
                    layer.alert(infoObj.msg, {
                    	icon: 1,
                    	end: function () {
                    		frameElement.api.close();
                    	}
                    });
                }
            }
        });
		
		return true;
	}
</script>
</body>