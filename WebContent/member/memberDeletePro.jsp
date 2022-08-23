<%@page import="member.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴(삭제)</title>
</head>
<body>
	<%
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	
	MemberDAO memberDAO = MemberDAO.getInstance();
	int cnt = memberDAO.deleteMember(id, pwd);
	%>
	
	<script>
	<%if(cnt > 0){ %> <%-- cnt = 1, 탈퇴 성공 --%>
		alert('탈퇴에 성공하였습니다.');
		location='../logon/memberLoginForm.jsp';
	<%}else { %> <%-- cnt = 0, 탈퇴 실패 --%>
		alert('탈퇴에 실패하였습니다.');
		history.back();
	<%} %>
	</script>
</body>
</html>