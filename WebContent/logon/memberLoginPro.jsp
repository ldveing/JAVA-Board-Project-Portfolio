<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="member.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 처리</title>
</head>
<body>
	<%
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	
	MemberDAO memberDAO = MemberDAO.getInstance();
	int cnt = memberDAO.login(id, pwd);
	
	// -1: 아이디 없음, 0: ID 일치 & PW 불일치, 1: ID & PW 둘 다 일치
	out.print("<script>");
	if(cnt == 1){// 1: ID & PW 둘 다 일치 -> 세션 생성!!
		session.setAttribute("memberId", id);
		out.print("alert('로그인 되었습니다.');");
		out.print("location='../board/boardList.jsp'");
	} else if(cnt == 0){ // 0: ID 일치 & PW 불일치
		out.print("alert('비밀번호가 일치하지 않습니다..');history.back();");
	} else if(cnt == -1){ // -1: 아이디 없음
		out.print("alert('아이디가 존재하지 않습니다.');history.back();");
	}
	out.print("</script>");
	%>
</body>
</html>