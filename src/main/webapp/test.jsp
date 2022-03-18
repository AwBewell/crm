
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
    <script>
        $.ajax({
            url : "",
            data : {

            },
            type : "",
            dataType : "json",
            success : function (data){

            }
        })
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
        });
    //    String createTime = DateTimeUtil.getSysTime();
    //     String createBy = ((User)request.getSession().getAttribute("user")).getName();
    //
    </script>
</head>
<body>

//创建时间
String createTime = DateTimeUtil.getSysTime();
//创建人
String createBy = ((User) request.getSession().getAttribute("user")).getName();
</body>
</html>
