
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
    </script>
</head>
<body>

//创建时间
String createTime = DateTimeUtil.getSysTime();
//创建人
String createBy = ((User) request.getSession().getAttribute("user")).getName();
</body>
</html>
