<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>订单单身</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name=viewportcontent="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no,minimal-ui">
	<link rel="stylesheet" href="${webRoot}/plug-in/element-ui/css/index.css">
	<link rel="stylesheet" href="${webRoot}/plug-in/element-ui/css/elementui-ext.css">
	<script src="${webRoot}/plug-in/vue/vue.js"></script>
	<script src="${webRoot}/plug-in/vue/vue-resource.js"></script>
	<script src="${webRoot}/plug-in/element-ui/index.js"></script>
	<!-- Jquery组件引用 -->
	<script src="${webRoot}/plug-in/jquery/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${webRoot}/plug-in/jquery-plugs/i18n/jquery.i18n.properties.js"></script>
	<script type="text/javascript" src="${webRoot}/plug-in/mutiLang/zh-cn.js"></script>
	<script type="text/javascript" src="${webRoot}/plug-in/lhgDialog/lhgdialog.min.js?skin=metrole"></script>
	<script type="text/javascript" src="${webRoot}/plug-in/tools/curdtools.js"></script>
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
	<div id="orderBodyList" v-cloak>
		<!--工具条-->
		<el-row style="margin-top: 15px;">
			<el-form :inline="true" :model="filters" size="mini" ref="filters">
<%--				<el-form-item>--%>
<%--			    	<el-button type="primary" icon="el-icon-search" v-on:click="getOrderBodys">查询</el-button>--%>
<%--			    </el-form-item>--%>
<%--			    <el-form-item>--%>
<%--			    	<el-button icon="el-icon-refresh" @click="resetForm('filters')">重置</el-button>--%>
<%--			    </el-form-item>--%>
<%--			    <el-form-item>--%>
<%--			    	<el-button type="primary" icon="el-icon-edit" @click="handleAdd">新增</el-button>--%>
<%--			    </el-form-item>--%>
<%--			    <el-form-item>--%>
<%--			    	<el-button type="primary" icon="el-icon-edit" @click="ImportXls">导入</el-button>--%>
<%--			    </el-form-item>--%>
			</el-form>
		</el-row>
		
		<!--列表-->
		<el-table :data="orderBodys" border stripe size="mini" highlight-current-row v-loading="listLoading" @sort-change="handleSortChange"  @selection-change="selsChange" style="width: 100%;">
			<el-table-column type="selection" width="55"></el-table-column>
			<el-table-column type="index" width="60"></el-table-column>
			<el-table-column prop="movieName" label="电影名称" min-width="120" sortable="custom" show-overflow-tooltip></el-table-column>
			<el-table-column prop="cinema" label="影院" min-width="120" sortable="custom" show-overflow-tooltip :formatter="formatCinemaDict"></el-table-column>
			<el-table-column prop="seatP" label="座位第几排" min-width="120" sortable="custom" show-overflow-tooltip :formatter="formatSeat_pDict"></el-table-column>
			<el-table-column prop="seatL" label="座位第几列" min-width="120" sortable="custom" show-overflow-tooltip :formatter="formatSeat_lDict"></el-table-column>
			<el-table-column prop="price" label="单价" min-width="120" sortable="custom" show-overflow-tooltip></el-table-column>
			<el-table-column label="操作" width="250">
				<template scope="scope">
					<el-button size="mini" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
					<el-button size="mini" @click="comment(scope.$index, scope.row)">评价</el-button>
					<el-button type="danger" size="mini" @click="handleDel(scope.$index, scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		
		<!--工具条-->
		<el-col :span="24" class="toolbar">
			<el-button type="danger" size="mini" @click="batchRemove" :disabled="this.sels.length===0">批量删除</el-button>
			 <el-pagination small background @current-change="handleCurrentChange" @size-change="handleSizeChange" :page-sizes="[10, 20, 50, 100]"
      			:page-size="pageSize" :total="total" layout="sizes, prev, pager, next"  style="float:right;"></el-pagination>
		</el-col>
		
		<!--新增界面-->
		<el-dialog :title="formTitle" fullscreen z-index="800" :visible.sync="formVisible" :close-on-click-modal="false">
			<el-form :model="form" label-width="80px" :rules="formRules" ref="form" size="mini">
					<el-form-item label="电影名称" prop="movieName">
						<el-input v-model="form.movieName" auto-complete="off" placeholder="请输入电影名称"></el-input>
					</el-form-item>
					<el-form-item label="影院">
						<el-select v-model="form.cinema" placeholder="请选择影院">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in cinemaOptions"></el-option>
					    </el-select>
					</el-form-item>
					<el-form-item label="座位第几排">
						<el-select v-model="form.seatP" placeholder="请选择座位第几排">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in seat_pOptions"></el-option>
					    </el-select>
					</el-form-item>
					<el-form-item label="座位第几列">
						<el-select v-model="form.seatL" placeholder="请选择座位第几列">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in seat_lOptions"></el-option>
					    </el-select>
					</el-form-item>
					<el-form-item label="单价" prop="price">
						<el-input v-model="form.price" auto-complete="off" placeholder="请输入单价"></el-input>
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
		el:"#orderBodyList",
		data() {
			return {
				filters: {
				},
				url:{
					list:'${webRoot}/orderBodyController.do?datagrid&orderId=${orderId}',
					del:'${webRoot}/orderBodyController.do?doDel',
					comment:'${webRoot}/orderBodyController.do?comment',
					batchDel:'${webRoot}/orderBodyController.do?doBatchDel',
					queryDict:'${webRoot}/systemController.do?typeListJson',
					save:'${webRoot}/orderBodyController.do?doAdd',
					edit:'${webRoot}/orderBodyController.do?doUpdate',
					upload:'${webRoot}/systemController/filedeal.do',
					downFile:'${webRoot}/img/server/',
					exportXls:'${webRoot}/orderBodyController.do?exportXls&id=',
					ImportXls:'${webRoot}/orderBodyController.do?upload'
				},
				orderBodys: [],
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
		   		seat_pOptions:[],
		   		seat_lOptions:[],
			}
		},
		methods: {
			handleSortChange(sort){
				this.sort={
					sort:sort.prop,
					order:sort.order=='ascending'?'asc':'desc'
				};
				this.getOrderBodys();
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
			formatSeat_pDict: function(row,column,cellValue, index){
				var names="";
				var values=cellValue;
				if(!Array.isArray(cellValue))values=cellValue.split(',');
				for (var i = 0; i < values.length; i++) {
					var value = values[i];
					if(i>0)names+=",";
					for(var j in this.seat_pOptions){
						var option=this.seat_pOptions[j];
						if(value==option.typecode){
							names+=option.typename;
						}
					}
				}
				return names;
			},
			formatSeat_lDict: function(row,column,cellValue, index){
				var names="";
				var values=cellValue;
				if(!Array.isArray(cellValue))values=cellValue.split(',');
				for (var i = 0; i < values.length; i++) {
					var value = values[i];
					if(i>0)names+=",";
					for(var j in this.seat_lOptions){
						var option=this.seat_lOptions[j];
						if(value==option.typecode){
							names+=option.typename;
						}
					}
				}
				return names;
			},
			handleCurrentChange(val) {
				this.page = val;
				this.getOrderBodys();
			},
			handleSizeChange(val) {
				this.pageSize = val;
				this.page = 1;
				this.getOrderBodys();
			},
			resetForm(formName) {
		        this.$refs[formName].resetFields();
		        this.getOrderBodys();
		    },
			comment(index,row) {
				this.$prompt('请输入评分;评语，中间使用分号隔开', '提示', {
					confirmButtonText: '确定',
					cancelButtonText: '取消',
				}).then(({ value }) => {
					this.listLoading = true;
					let para = { movieName: row.movieName,comments:value ,orderId:'${orderId}'};
					this.$http.post(this.url.comment,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						this.$message({
							message: '评论成功',
							type: 'success',
							duration:1500
						});
						this.getOrderBodys();
					});
				}).catch(() => {
					this.$message({
						type: 'info',
						message: '您取消了评价'
					});
				});


		    },
			//获取用户列表
			getOrderBodys() {
				var fields=[];
				fields.push('id');
				fields.push('id');
				fields.push('movieName');
				fields.push('cinema');
				fields.push('seatP');
				fields.push('seatL');
				fields.push('price');
				let para = {
					params: {
						page: this.page,
						rows: this.pageSize,
						//排序
						sort:this.sort.sort,
						order:this.sort.order,
						field:fields.join(',')
					}
				};
				this.listLoading = true;
				this.$http.get(this.url.list,para).then((res) => {
					this.total = res.data.total;
					var datas=res.data.rows;
					for (var i = 0; i < datas.length; i++) {
						var data = datas[i];
					}
					this.orderBodys = datas;
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
						this.getOrderBodys();
					});
				}).catch(() => {

				});
			},
			//显示编辑界面
			handleEdit: function (index, row) {
				this.formTitle='编辑';
				this.formVisible = true;
				this.form = Object.assign({}, row);
			},
			//显示新增界面
			handleAdd: function () {
				this.formTitle='新增';
				this.formVisible = true;
				this.form = {
					movieName:'',
					cinema:'',
					seatP:'',
					seatL:'',
					price:'',
				};
			},
			//新增
			formSubmit: function () {
				this.$refs.form.validate((valid) => {
					if (valid) {
						this.$confirm('确认提交吗？', '提示', {}).then(() => {
							this.formLoading = true;
							let para = Object.assign({}, this.form);
							
							
							
							this.$http.post(!!para.id?this.url.edit:this.url.save,para,{emulateJSON: true}).then((res) => {
								this.formLoading = false;
								this.$message({
									message: '提交成功',
									type: 'success',
									duration:1500
								});
								this.$refs['form'].resetFields();
								this.formVisible = false;
								this.getOrderBodys();
							});
						});
					}
				});
			},
			selsChange: function (sels) {
				this.sels = sels;
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
						this.getOrderBodys();
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
				openuploadwin('Excel导入',this.url.ImportXls, "orderBodyList");
			},
			//初始化数据字典
			initDictsData:function(){
	        	var _this = this;
		   		_this.initDictByCode('cinema',_this,'cinemaOptions');
		   		_this.initDictByCode('seat_p',_this,'seat_pOptions');
		   		_this.initDictByCode('seat_l',_this,'seat_lOptions');
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
			this.getOrderBodys();
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