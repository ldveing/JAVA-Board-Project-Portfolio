<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="board.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 수정 처리</title>
</head>
<body>
<%request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="board" class="board.BoardDTO"/>
<jsp:setProperty property="*" name="board"/>
<%
String pageNum = request.getParameter("pageNum");
BoardDAO boardDAO = BoardDAO.getInstance();
boardDAO.updateBoard(board);
response.sendRedirect("boardList.jsp?pageNum=" + pageNum);
%>
</body>
</html>