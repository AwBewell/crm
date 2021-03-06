<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		//日期插件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		//	为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function (){
			//走后台,目的是查找信息
			$.ajax({
				url: "workbench/activity/getUserList.do", //从web.xml中拿
				data : {
					//从前端往后端传的数据，不用写
				},
				type : "get", //登录，与密码相关用post 其他取值用get
				dataType : "json",
				success : function (data){
					var html = "<option></option>"
					$.each(data,function (i,n){
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-owner").html(html)
					//取得当前用户的id
					//在js中使用el表达式，一定要在字符串中
					var id = "${user.id}"
					$("#create-owner").val(id)
					//展现模态窗口
					$("#createActivityModal").modal("show")

				}
			})

		})
		//执行添加操作
		$("#savaBtn").click(function (){
			$.ajax({
				url : "workbench/activity/save.do",
				data : {
					"owner" : $.trim($("#create-owner").val()),
					"name" : $.trim($("#create-name").val()),
					"startDate" : $.trim($("#create-startDate").val()),
					"endDate" : $.trim($("#create-endDate").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val())

				},
				type: "post", //添加修改删除 用post
				dataType: "json",
				success : function (data){
					/*
						data success true/false
					*/
					if (data.success) {
						//添加成功后
					//	刷新市场活动信息列表 局部
						//pageList(1,2);
						//$("#activityPage").bs_pagination('getOption', 'currentPage')   操作后停留在当前页
						//$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));  操作后维持已经设置好的每页展现的记录数
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					//	做完添加后应该维持每页展现的记录数，回到第一页
					//	清空模态窗口中的数据
						/*
							注意我们拿到form表单的jquery对象，对于表单jquery对象，提供了submit方法，但是没有提供reset方法
							jquery对象转换成dom对象
								jquery对象[下标]
							dom对象转换成jquery对象
								$(dom)
						*/
						$("#activityAddForm")[0].reset();//重置form表单
					//	关闭添加操作的模态窗口
						$("#createActivityModal").modal("hide");
					}else {
						alert("失败")
					}
				}
			})
		})

		//页面加载之后触发的方法 1页2个
		pageList(1,2);
		//为查询按钮绑定事件
		$("#searchBtn").click(function (){
			//点击查询按钮的时候，将搜索框中的信息保存到隐藏域当中
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-startDate").val($.trim($("#search-startDate").val()))
			$("#hidden-endDate").val($.trim($("#search-endDate").val()))
			pageList(1,2);
		})
		//为全选的复选框绑定事件
		$("#qx").click(function (){
			$("input[name=xz]").prop("checked",this.checked);
		})
		//动态生成的元素，是不能以普通绑定事件的形式来操作的。。。。需要用on
		//	语法：$(需要绑定元素的有效的外层元素).on(绑定的事件，需要绑定的jquery对象，回调函数)
		$("#activityBody").on("click",$("input[name=xz]"),function (){
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		//删除操作
		$("#deleteBtn").click(function (){
			var $xz = $("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择要删除的记录")
			}else {

				if(confirm("确定删除所选的记录吗")){
					// url:workbench/activity/delete.do
					var param = "";
					for(var i=0;i<$xz.length;i++){
						param+="id="+$($xz[i]).val();
						if(i<$xz.length-1){
							param+="&";
						}
					}
					$.ajax({
						url : "workbench/activity/delete.do",
						data : param,
						type : "post",
						dataType : "json",
						success : function (data){
							if(data.success){
								//删除成功后
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("删除失败")
							}
						}
					})
				}

			}
		})
		//修改操作
		$("#editBtn").click(function (){

			var $xz = $("input[name=xz]:checked");
			if($xz.length == 0){
				alert("请选择要修改的记录")
			}else if ($xz.length > 1){
				alert("请不要选择多个")
			}else {
				var id = $xz.val();
				$.ajax({
					url : "workbench/activity/getUserListAndActivity.do",
					data : {
						"id" : id
					},
					type : "get",
					dataType : "json",
					success : function (data){
						//处理所有者的下拉框
						var html = "<option></option>";
						$.each(data.uList,function (i,n){
							html+="<option value='"+n.id+"'>"+n.name+"</option>"
						})
						$("#edit-owner").html(html);
					//	处理单条activity
						$("#edit-id").val(data.a.id);
						$("#edit-name").val(data.a.name);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-description").val(data.a.description);
						$("#edit-cost").val(data.a.cost);
						$("#edit-owner").val(data.a.owner);
						$("#editActivityModal").modal("show");
					}
				})
			}

		})
		//	为更新按钮绑定事件
		$("#updateBtn").click(function (){
			$.ajax({
				url : "workbench/activity/update.do",
				data : {
					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"name" : $.trim($("#edit-name").val()),
					"startDate" : $.trim($("#edit-startDate").val()),
					"endDate" : $.trim($("#edit-endDate").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-description").val())

				},
				type: "post", //添加修改删除 用post
				dataType: "json",
				success : function (data){
					/*
						data success true/false
					*/
					if (data.success) {
						//	修改成功后
						//	刷新市场活动信息列表 局部
						// pageList(1,2);    维持在当前页，每页展现的记录数
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						//	关闭修复操作的模态窗口
						$("#editActivityModal").modal("hide");
					}else {
						alert("修改市场活动失败")
					}
				}
			})
		})
	});
	//分页函数
	function pageList(pageNo,pageSize){
		$("#qx").prop("checked",false);
		//查询前，将隐藏域当中的信息取出来，重新赋予到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()))
		$("#search-owner").val($.trim($("#hidden-owner").val()))
		$("#search-startDate").val($.trim($("#hidden-startDate").val()))
		$("#search-endDate").val($.trim($("#hidden-endDate").val()))
		//pageNo:页码
		//pageSize:个数
		$.ajax({
			url : "workbench/activity/pageList.do",
			data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : $.trim($("#search-name").val()),
				"owner" : $.trim($("#search-owner").val()),
				"startDate" : $.trim($("#search-startDate").val()),
				"endDate" : $.trim($("#search-endDate").val())
			},
			type : "get",
			dataType : "json",
			success : function (data){
				/*
					data{
						【{市场活动1},{2},{3}】
						个数total
				 */

				var html = "";
				$.each(data.dataList,function (i,n){
					html += '<tr class="active">'
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>'
					html += '<td>'+n.name+'</td>'
					html += '<td>'+n.startDate+'</td>'
					html += '<td>'+n.endDate+'</td>'
					html += '</tr>'
				})
				$("#activityBody").html(html);

				//分页
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;

				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
		})
	}
</script>
</head>
<body>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<%-- data-dismiss 关闭模态窗口--%>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="savaBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<%--文本域
									1.标签对形式呈现，一定要紧挨着
									虽然是标签对，但也是表单元素范围，对其取值和赋值操作，应该使用val（）来操作
								--%>
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">名称</div>
							<input class="form-control" type="text" id="search-name">
						</div>
					</div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">所有者</div>
							<input class="form-control" type="text" id="search-owner">
						</div>
					</div>


					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">开始日期</div>
							<input class="form-control time" type="text" id="search-startDate" />
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">结束日期</div>
							<input class="form-control time" type="text" id="search-endDate" />
						</div>
					</div>

					<button type="button" id="searchBtn" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--对于触发模态窗口的操作一定不要写在元素中，应该写到js代码中-->
				  <button type="button" class="btn btn-primary" id="addBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>


			</div>
			
		</div>
		
	</div>
</body>
</html>