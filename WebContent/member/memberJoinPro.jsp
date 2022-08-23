<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="member.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입 처리</title>
</head>
<body>
	<% request.setCharacterEncoding("utf-8"); %>
	
	<!-- 액션 태그 사용 -->
	<jsp:useBean id="member" class="member.MemberDTO"></jsp:useBean>
	<jsp:setProperty property="*" name="member"/>
	
	<%
	String address2 = request.getParameter("address2");
	String address = member.getAddress() + " " + address2;
	
	MemberDAO memberDAO = MemberDAO.getInstance();
	int cnt = memberDAO.insertMember(member);
	
	/* out.print("<script>");
	if(cnt > 0){// 데이터 삽입 성공
		out.print("alert(`회원 가입에 성공하였습니다.`);");
		out.print("location='../logon/memberLoginForm.jsp'");
	}else{// 데이터 삽입 실패
		out.print("alert(`회원 가입에 실패하였습니다.\n회원가입을 다시 진행해 주세요.`);");
		out.print("history.back();");
	}
	out.print("</script>"); */	
	%>
	
	<script>
	<%if(cnt > 0){ %> <%-- cnt = 1, 데이터 추가 성공 --%>
		alert('회원가입에 성공하였습니다.');
		location='../logon/memberLoginForm.jsp';
	<%}else { %> <%-- cnt = 0, 데이터 추가 실패 --%>
		alert('회원가입에 실패하였습니다.');
		history.back();
	<%} %>
	</script>
</body>
</html>