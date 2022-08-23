<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>logout</title>
</head>
<body>
	<%
	/*
	1. 세션 삭제 방법 2가지
	- session.invalidate(); - 모든 세션 무효화(삭제)
	
	- session.removeAttribute(세션명); - 세션명에 해당하는 세션만 무효화
	*/
	session.removeAttribute("memberId");
	%>
	<script>
		alert('로그아웃 되었습니다.');
		location='memberLoginForm.jsp';
	</script>
</body>
</html>