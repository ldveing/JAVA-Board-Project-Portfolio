<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="board.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 삭제 처리</title>
</head>
<body>
<%request.setCharacterEncoding("utf-8");
String pageNum = request.getParameter("pageNum");
int num = Integer.parseInt(request.getParameter("num"));
String writer = request.getParameter("writer");
String pwd = request.getParameter("pwd");

BoardDAO boardDAO = BoardDAO.getInstance();
int cnt = boardDAO.deleteBoard(num, writer, pwd);

// cnt가 1인 경우 삭제 성공, 0인 경우 삭제 실패
%>

<script>
<%if(cnt > 0) {%>
	alert('글 삭제에 성공하였습니다.');
<%} else { %>
	alert(`비밀번호 오류!!!!!\n글 삭제에 실패하였습니다.`);
	history.back();
<%} %>
// 자바 스크립트 형식으로 작성해야 함.
location = 'boardList.jsp?pageNum=<%=pageNum %>'; 
</script>
</body>
</html>