<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>订单单头</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name=viewportcontent="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no,minimal-ui">
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
	<style>
		.toolbar {
		    padding: 10px;
		    margin: 10px 0;
		}
		.toolbar .el-form-item {
		    margin-bottom: 10px;
		}
		.el-table__header tr th{
			padding:3px 0px;
		}
		[v-cloak] { display: none }
	</style>
</head>

<body style="background-color: #FFFFFF;">
	<div id="orderHeadList" v-cloak>
		<!--工具条-->
		<el-row style="margin-top: 15px;">
<%--			<el-form :inline="true" :model="filters" size="mini" ref="filters">--%>
<%--				<el-form-item style="margin-bottom: 8px;" prop="userName">--%>
<%--					<el-input v-model="filters.userName" auto-complete="off" placeholder="请输入用户账户"></el-input>--%>
<%--				</el-form-item>--%>
<%--				<el-form-item style="margin-bottom: 8px;" prop="realName">--%>
<%--					<el-input v-model="filters.realName" auto-complete="off" placeholder="请输入用户名称"></el-input>--%>
<%--				</el-form-item>--%>
<%--				--%>
<%--				<el-form-item>--%>
<%--			    	<el-button type="primary" icon="el-icon-search" v-on:click="getOrderHeads">查询</el-button>--%>
<%--			    </el-form-item>--%>
<%--			    <el-form-item>--%>
<%--			    	<el-button icon="el-icon-refresh" @click="resetForm('filters')">重置</el-button>--%>
<%--			    </el-form-item>--%>
			    <!-- <el-form-item>
			    	<el-button type="primary" icon="el-icon-edit" @click="handleAdd">用户录入</el-button>
			    	<el-button type="primary" icon="el-icon-edit" @click="handleAdd2">用户录入</el-button>
			    </el-form-item> -->
			</el-form>
		</el-row>
		
		<!--列表-->
		<el-table :data="orderHeads" border stripe size="mini" highlight-current-row v-loading="listLoading" @sort-change="handleSortChange"  @selection-change="selsChange" style="width: 100%;">
			<el-table-column type="selection" width="55"></el-table-column>
			<el-table-column type="index" width="60"></el-table-column>
			<el-table-column prop="userName" label="用户账户" min-width="120" sortable="custom" show-overflow-tooltip></el-table-column>
			<el-table-column prop="realName" label="用户名称" min-width="120" sortable="custom" show-overflow-tooltip></el-table-column>
			<el-table-column prop="userKey" label="角色" min-width="120" sortable="custom" show-overflow-tooltip></el-table-column>
			<el-table-column prop="status" label="状态" min-width="120" sortable="custom" show-overflow-tooltip :formatter="stateFormat"></el-table-column>
			<el-table-column label="操作" width="500">
				<template scope="scope">
					<el-button size="mini" @click="handleEdit(scope.$index, scope.row)">用户编辑</el-button>
					<el-button size="mini" @click="showDetail(scope.$index, scope.row)">密码重置</el-button>
					<el-button type="danger" size="mini" @click="handleDel(scope.$index, scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		
		<!--新增界面-->
		<el-dialog :title="formTitle" fullscreen z-index="800" :visible.sync="formVisible" :close-on-click-modal="false">
			<el-form :model="form" label-width="80px" :rules="formRules" ref="form" size="mini">
					<el-form-item label="创建人名称" prop="createName">
						<el-input v-model="form.createName" auto-complete="off" placeholder="请输入创建人名称"></el-input>
					</el-form-item>
					<el-form-item label="创建人登录名称" prop="createBy">
						<el-input v-model="form.createBy" auto-complete="off" placeholder="请输入创建人登录名称"></el-input>
					</el-form-item>
					<el-form-item label="创建日期">
						<el-date-picker type="date" placeholder="选择创建日期" v-model="form.createDate"></el-date-picker>
					</el-form-item>
					<el-form-item label="订单单头" prop="orderId">
						<el-input v-model="form.orderId" auto-complete="off" placeholder="请输入订单单头"></el-input>
					</el-form-item>
					<el-form-item label="手机号" prop="phone">
						<el-input v-model="form.phone" auto-complete="off" placeholder="请输入手机号"></el-input>
					</el-form-item>
					<el-form-item label="购票昵称" prop="buyerName">
						<el-input v-model="form.buyerName" auto-complete="off" placeholder="请输入购票昵称"></el-input>
					</el-form-item>
					<el-form-item label="观看时间">
						 <el-date-picker type="datetime" placeholder="选择观看时间" v-model="form.watchTime"></el-date-picker>
					</el-form-item>
					<el-form-item label="影院地址">
						<el-select v-model="form.address" placeholder="请选择影院地址">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in cinemaOptions"></el-option>
					    </el-select>
					</el-form-item>
					<el-form-item label="总价" prop="totalPrice">
						<el-input v-model="form.totalPrice" auto-complete="off" placeholder="请输入总价"></el-input>
					</el-form-item>
					<el-form-item label="电影票状态">
						<el-select v-model="form.ticketState" placeholder="请选择电影票状态">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in ticket_stOptions"></el-option>
					    </el-select>
					</el-form-item>
			</el-form>

			<div slot="footer" class="dialog-footer">
				<el-button @click.native="formVisible = false">取消</el-button>
				<el-button type="primary" @click.native="formSubmit" :loading="formLoading">提交</el-button>
			</div>
		</el-dialog>

	</div>
</body>
<script>
	var vue = new Vue({			
		el:"#orderHeadList",
		data() {
			return {
				filters: {
					orderId:'',
					phone:'',
					watchTime:'',
					address:'',
					ticketState:'',
				},
				url:{
					list:'${webRoot}/userController.do?datagrid',
					del:'${webRoot}/userController.do?delete&deleteType=deleteTrue',
					pay:'${webRoot}/orderHeadController.do?optionOrder&option=pay',
					cancel:'${webRoot}/orderHeadController.do?optionOrder&option=cancel',
					view:'${webRoot}/orderHeadController.do?optionOrder&option=view',
					batchDel:'${webRoot}/orderHeadController.do?doBatchDel',
					queryDict:'${webRoot}/systemController.do?typeListJson',
					save:'${webRoot}/orderHeadController.do?doAdd',
					edit:'${webRoot}/orderHeadController.do?doUpdate',
					upload:'${webRoot}/systemController/filedeal.do',
					downFile:'${webRoot}/img/server/',
					exportXls:'${webRoot}/orderHeadController.do?exportXls&id=',
					ImportXls:'${webRoot}/orderHeadController.do?upload'
				},
				orderHeads: [],
				total: 0,
				page: 1,
				pageSize:10,
				sort:{
					sort:'id',
					order:'desc'
				},
				listLoading: false,
				sels: [],//列表选中列
				
				formTitle:'新增',
				formVisible: false,//表单界面是否显示
				formLoading: false,
				formRules: {
				},
				//表单界面数据
				form: {},

				//数据字典 
		   		cinemaOptions:[],
		   		ticket_stOptions:[],
				drawer: false,
				direction: 'ltr',
			}
		},
		methods: {
			handleSortChange(sort){
				this.sort={
					sort:sort.prop,
					order:sort.order=='ascending'?'asc':'desc'
				};
				this.getOrderHeads();
			},showDetail(index,row){
				// console.log(row)
				// console.log(row.orderId)
				//location.href="orderBodyController.do?list&orderId="+row.orderId;
				add('密码重置','userController.do?changepasswordforuser&id='+row.id,'',550,200);
			},
			handleDownFile(type,filePath){
				var downUrl=this.url.downFile+ filePath +"?down=true";
				window.open(downUrl);
			},
			formatDate: function(row,column,cellValue, index){
				return !!cellValue?utilFormatDate(new Date(cellValue), 'yyyy-MM-dd'):'';
			},
			formatDateTime: function(row,column,cellValue, index){
				return !!cellValue?utilFormatDate(new Date(cellValue), 'yyyy-MM-dd hh:mm:ss'):'';
			},
			formatCinemaDict: function(row,column,cellValue, index){
				var names="";
				var values=cellValue;
				if(!Array.isArray(cellValue))values=cellValue.split(',');
				for (var i = 0; i < values.length; i++) {
					var value = values[i];
					if(i>0)names+=",";
					for(var j in this.cinemaOptions){
						var option=this.cinemaOptions[j];
						if(value==option.typecode){
							names+=option.typename;
						}
					}
				}
				return names;
			},
			formatTicket_stDict: function(row,column,cellValue, index){
				var names="";
				var values=cellValue;
				if(!Array.isArray(cellValue))values=cellValue.split(',');
				for (var i = 0; i < values.length; i++) {
					var value = values[i];
					if(i>0)names+=",";
					for(var j in this.ticket_stOptions){
						var option=this.ticket_stOptions[j];
						if(value==option.typecode){
							names+=option.typename;
						}
					}
				}
				return names;
			},
			handleCurrentChange(val) {
				this.page = val;
				this.getOrderHeads();
			},
			handleSizeChange(val) {
				this.pageSize = val;
				this.page = 1;
				this.getOrderHeads();
			},
			resetForm(formName) {
		        this.$refs[formName].resetFields();
		        this.getOrderHeads();
		    },
			//获取用户列表
			getOrderHeads() {
				var fields=[];
				fields.push('id');
				//fields.push('id');
				//fields.push('createName');
				fields.push('userName');
				fields.push('realName');
				fields.push('userKey');
				fields.push('status');
				/* fields.push('phone');
				fields.push('buyerName');
				fields.push('watchTime');
				fields.push('address');
				fields.push('totalPrice');
				fields.push('ticketState'); */
				let para = {
					params: {
						page: this.page,
						rows: this.pageSize,
						//排序
						sort:this.sort.sort,
						order:this.sort.order,
						userName:this.filters.userName,
						realName:this.filters.realName,
					 	watchTime: !this.filters.watchTime ? '' : utilFormatDate(new Date(this.filters.watchTime ), 'yyyy-MM-dd hh:mm:ss'),
					 	address:this.filters.address,
					 	ticketState:this.filters.ticketState,
						field:fields.join(',')
					}
				};
				this.listLoading = true;
				this.$http.get(this.url.list,para).then((res) => {
					
					this.total = res.data.total;
					var datas=res.data.rows;
					for (var i = 0; i < datas.length; i++) {
						var data = datas[i];
						//alert(JSON.stringify(data));
					}
					this.orderHeads = datas;
					this.listLoading = false;
				});
			},
			//删除
			handleDel: function (index, row) {
				this.$confirm('确认删除该记录吗?', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { id: row.id };
					this.$http.post(this.url.del,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						this.$message({
							message: '删除成功',
							type: 'success',
							duration:1500
						});
						this.getOrderHeads();
					});
				}).catch(() => {

				});
			},
			pay: function (index, row) {
				this.$confirm('您确认付款吗?', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { id: row.id };
					this.$http.post(this.url.pay+"&orderId="+row.orderId,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						this.$message({
							message: '付款成功',
							type: 'success',
							duration:1500
						});
						this.getOrderHeads();
					});
				}).catch(() => {

				});
			},
			cancel: function (index, row) {
				this.$confirm('您确认取消订单吗?', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { id: row.id };
					this.$http.post(this.url.cancel+"&orderId="+row.orderId,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						this.$message({
							message: '取消成功',
							type: 'success',
							duration:1500
						});
						this.getOrderHeads();
					});
				}).catch(() => {

				});
			},
			view: function (index, row) {
				this.$confirm('您使用该电影票吗?', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { id: row.id };
					this.$http.post(this.url.view+"&orderId="+row.orderId,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						this.$message({
							message: '使用成功',
							type: 'success',
							duration:1500
						});
						this.getOrderHeads();
					});
				}).catch(() => {

				});
			},
			//显示编辑界面
			handleEdit: function (index, row) {
				/* this.formTitle='编辑';
				this.formVisible = true;
				this.form = Object.assign({}, row); */
				
				add('用户编辑','userController.do?edit&id='+row.id,'',550,200);
			},
			//显示新增界面
			handleAdd: function () {
				this.formTitle='新增';
				this.formVisible = true;
				this.form = {
					createName:'',
					createBy:'',
					createDate:'',
					orderId:'',
					phone:'',
					buyerName:'',
					watchTime:'',
					address:'',
					totalPrice:'',
					ticketState:'',
				};
			},
			//显示新增界面
			handleAdd2: function () {
				add('个人信息','userController.do?userinfo','',550,250);
			},
			//新增
			formSubmit: function () {
				this.$refs.form.validate((valid) => {
					if (valid) {
						this.$confirm('确认提交吗？', '提示', {}).then(() => {
							this.formLoading = true;
							let para = Object.assign({}, this.form);
							
							para.createDate = !para.createDate ? '' : utilFormatDate(new Date(para.createDate), 'yyyy-MM-dd');
							para.watchTime = !para.watchTime ? '' : utilFormatDate(new Date(para.watchTime), 'yyyy-MM-dd hh:mm:ss');
							
							
							this.$http.post(!!para.id?this.url.edit:this.url.save,para,{emulateJSON: true}).then((res) => {
								this.formLoading = false;
								this.$message({
									message: '提交成功',
									type: 'success',
									duration:1500
								});
								this.$refs['form'].resetFields();
								this.formVisible = false;
								this.getOrderHeads();
							});
						});
					}
				});
			},
			selsChange: function (sels) {
				this.sels = sels;
			},
			handleClose(done) {
				this.$confirm('确认关闭？')
						.then(_ => {
							done();
						})
						.catch(_ => {});
			},
			//批量删除
			batchRemove: function () {
				var ids = this.sels.map(item => item.id).toString();
				this.$confirm('确认删除选中记录吗？', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { ids: ids };
					this.$http.post(this.url.batchDel,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						this.$message({
							message: '删除成功',
							type: 'success',
							duration:1500
						});
						this.getOrderHeads();
					});
				}).catch(() => {
				});
			},
			//导出
			ExportXls: function() {
					var ids = this.sels.map(item => item.id).toString();
					window.location.href = this.url.exportXls+ids;
			},
			//导入
			ImportXls: function(){
				openuploadwin('Excel导入',this.url.ImportXls, "orderHeadList");
			},
			//初始化数据字典
			initDictsData:function(){
	        	var _this = this;
		   		_this.initDictByCode('cinema',_this,'cinemaOptions');
		   		_this.initDictByCode('ticket_st',_this,'ticket_stOptions');
	        },
	        stateFormat(row, column) {
	        	return '激活';
	        },
	        initDictByCode:function(code,_this,dictOptionsName){
	        	if(!code || !_this[dictOptionsName] || _this[dictOptionsName].length>0)
	        		return;
	        	this.$http.get(this.url.queryDict,{params: {typeGroupName:code}}).then((res) => {
	        		var data=res.data;
					if(data.success){
					  _this[dictOptionsName] = data.obj;
					  _this[dictOptionsName].splice(0, 1);//去掉请选择
					}
				});
	        }
		},
		mounted() {
			this.initDictsData();
			this.getOrderHeads();
		}
	});
	
	function utilFormatDate(date, pattern) {
        pattern = pattern || "yyyy-MM-dd";
        return pattern.replace(/([yMdhsm])(\1*)/g, function ($0) {
            switch ($0.charAt(0)) {
                case 'y': return padding(date.getFullYear(), $0.length);
                case 'M': return padding(date.getMonth() + 1, $0.length);
                case 'd': return padding(date.getDate(), $0.length);
                case 'w': return date.getDay() + 1;
                case 'h': return padding(date.getHours(), $0.length);
                case 'm': return padding(date.getMinutes(), $0.length);
                case 's': return padding(date.getSeconds(), $0.length);
            }
        });
    };
	function padding(s, len) {
	    var len = len - (s + '').length;
	    for (var i = 0; i < len; i++) { s = '0' + s; }
	    return s;
	};
	function reloadTable(){
		
	}
</script>
</html>