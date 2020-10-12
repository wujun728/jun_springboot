<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sy.util.base.SecurityUtil"%>
<%
	String contextPath = request.getContextPath();
	SecurityUtil securityUtil = new SecurityUtil(session);
%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<jsp:include page="../../inc.jsp"></jsp:include>
<script type="text/javascript">
	var grid;
	var addFun = function() {
		var dialog = parent.sy.modalDialog({
			title : '添加药品信息',
			url : sy.contextPath + '/securityJsp/app/DrugInfoForm.jsp',
			buttons : [ {
				text : '添加',
				handler : function() {
					dialog.find('iframe').get(0).contentWindow.submitForm(dialog, grid, parent.$);
				}
			} ]
		});
	};
	var showFun = function(id) {
		var dialog = parent.sy.modalDialog({
			title : '查看药品信息',
			url : sy.contextPath + '/securityJsp/app/DrugInfoForm.jsp?id=' + id
		});
	};
	var editFun = function(id) {
		var dialog = parent.sy.modalDialog({
			title : '编辑药品信息',
			url : sy.contextPath + '/securityJsp/app/DrugInfoForm.jsp?id=' + id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					dialog.find('iframe').get(0).contentWindow.submitForm(dialog, grid, parent.$);
				}
			} ]
		});
	};
	var removeFun = function(id) {
		parent.$.messager.confirm('询问', '您确定要删除此记录？', function(r) {
			if (r) {
				$.post(sy.contextPath + '/app/drug-record!delete.sy', {
					drugInfoId : id
				}, function() {
					grid.datagrid('reload');
				}, 'json');
			}
		});
	};
	  
	
	$(function() {
		grid = $('#grid').datagrid({
			title : '',
			url : sy.contextPath + '/app/drug-record!grid.sy',
			striped : true,
			rownumbers : true,
			pagination : true,
			singleSelect : true,
			idField : 'id',
			sortName : 'createTime',
			sortOrder : 'desc',
			pageSize : 50,
			pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
			frozenColumns : [ [{
				width : '50',
				title : '编号',
				field : 'id',
				sortable : true,
				hidden: true
			}, {
				width : '100',
				title : '药品名称',
				field : 'drugInfo',
				sortable : true,
				formatter : function(value, row, index) {
					 return value.drugName ;
				}
			}  ] ],
			columns : [ [ {
				width : '80',
				title : '操作类型',
				field : 'opType',
				sortable : true,
				formatter : function(value, row, index) {
					switch (value) {
					case 10:
						return '入库';
					case 20:
						return '消耗';
					case 30:
						return '盘点';
					case 40:
						return '出库';
					case 50:
						return '纠偏';
					}
					return '';
				}
			},{
				width : '80',
				title : '批次',
				field : 'drugTimes',
				sortable : true
			},{
				width : '80',
				title : '数量',
				field : 'num',
				sortable : true
			}, {
				width : '80',
				title : '规格',
				field : 'drugInfo.specification',
				sortable : true,
				formatter : function(value, row, index) {
					 //return value.specification ;
					 //console.log(row.drugInfo.specification)
					 //return value.specification;
					 return row.drugInfo.specification;
				}
			}  ,
			 {
				width : '80',
				title : '单价',
				field : 'price',
				sortable : true
			}  ,{
				width : '120',
				title : '操作时间',
				field : 'createTime',
				sortable : true
			}  ,{
				width : '100',
				title : '操作人',
				field : 'syuser',
				sortable : true,
				formatter : function(value, row, index) {
					 return value.name ;
				}
			}  ,
			{
				title : '操作',
				field : 'action',
				width : '100',
				formatter : function(value, row) {
					var str = '';
					<%if (securityUtil.havePermission("/app/drug-record!getById")) {%>
						var bt = systool.createFuncButton('ext-icon-note','查看','查看药品资料','showFun(\'{0}\');');
						str +=  sy.formatString(bt,row.drugInfo.drugCode);
					<%}%>
					<%-- <%if (securityUtil.havePermission("/app/drug-record!update")) {%>
						var bt = systool.createFuncButton('ext-icon-note_edit','编辑','编辑药品资料','editFun(\'{0}\');');
						str +=  sy.formatString(bt,row.drugCode);
					<%}%>
					<%if (securityUtil.havePermission("/app/drug-record!delete")) {%>
						var bt = systool.createFuncButton('ext-icon-note_delete','删除','删除药品','removeFun(\'{0}\');');
						str +=  sy.formatString(bt,row.drugCode);
					<%}%> --%>
					return str;
				}
			} ] ],
			toolbar : '#toolbar',
			onBeforeLoad : function(param) {
				parent.$.messager.progress({
					text : '数据加载中....'
				});
			},
			onLoadSuccess : function(data) {
				$('.iconImg').attr('src', sy.pixel_0);
				parent.$.messager.progress('close');
			}
		});
	});
</script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
	<div id="toolbar" style="display: none;">
		<table>
			<tr>
				<td>
					<form id="searchForm">
						<table>
							<tr>
								<td>药品名称</td>
								<td><input name="QUERY_t#drugInfo#drugName_S_LK" style="width: 180px;" /></td>
								<td>生产厂商</td>
								<td><input name="QUERY_t#drugInfo#produceComp_S_LK" style="width: 180px;" /></td>
								<td>创建时间</td>
								<td><input name="QUERY_t#createTime_D_GE" class="Wdate" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" readonly="readonly" style="width: 120px;" />-<input name="QUERY_t#createTime_D_LE" class="Wdate" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" readonly="readonly" style="width: 120px;" /></td>
								<td><a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'ext-icon-zoom',plain:true" onclick="grid.datagrid('load',sy.serializeObject($('#searchForm')));">过滤</a><a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'ext-icon-zoom_out',plain:true" onclick="$('#searchForm input').val('');grid.datagrid('load',{});">重置过滤</a></td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<%-- <%if (securityUtil.havePermission("/app/drug-info!save")) {%>
							<td><a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'ext-icon-note_add',plain:true" onclick="addFun();">添加</a></td>
							<%}%> --%>
							<td><div class="datagrid-btn-separator"></div></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	 
	<div data-options="region:'center',fit:true,border:false">
		<table id="grid" data-options="fit:true,border:false"></table>
	</div>
</body>
</html>