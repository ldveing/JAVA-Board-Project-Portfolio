<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="board.*, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 상세 보기</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Anton&family=Paytone+One&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap');
#container {width: 500px; margin: 0 auto;}
a{text-decoration: none; color: black;}
/* 상단 - 메인 & 서브 타이틀 */
.m_title {font-family: 'Paytone One', sans-serif; font-size: 3em; text-align: center;}
.s_title {font-family: 'Jua', sans-serif; font-size: 2em; text-align: center; margin-bottom: 20px;}
/* 본문 - 테이블 */
table { width: 100%; border: 1px solid black; border-collapse: collapse;}
tr {height: 40px;}
th, td { border: 1px solid black;}
th { background: #ced4da;}
td { padding: 5px;}
.content_row {height: 300px;}
.content_row td { vertical-align: baseline;}
/* 하단 - 버튼 */
.btns { text-align: center; margin-top: 20px;}
.btns input { width: 100px; height: 35px; border: none; background: black; color: white; 
font-weight: bold; cursor: pointer;}
</style>
<script>
	document.addEventListener("DOMContentLoaded", function(){
		let form = document.contentForm;
		let num = form.num.value;
		
		let btn_update = document.getElementById("btn_update");
		let btn_delete = document.getElementById("btn_delete");
		
		if(form.id.value != form.writer.value){
			btn_update.style.display = "none";
			btn_delete.style.display = "none";
		}
		
		// 로그인한 사람이 작성자와 일지하지 않으면 글 수정 버튼 & 글 삭제 버튼이 나타나지 않는다. 
		// 글 수정 버튼 클릭 시
		//let btn_update = document.getElementById("btn_update");
		btn_update.addEventListener("click", function(){
			// 로그인한 사람이 글 작성자인지를 파악하는 구문 -> 같지 않으면 이동 불가
			if(form.id.value == form.writer.value){
				// location = 'boardUpdateForm.jsp?num=' + num;
				form.action = 'boardUpdateForm.jsp';
				form.submit();
			}else{
				alert('작성자만 수정 가능');
				return;
			}
		})
		
		// 글 삭제 버튼 클릭 시
		//let btn_delete = document.getElementById("btn_delete");
		btn_delete.addEventListener("click", function(){
			// 로그인한 사람이 글 작성자인지를 파악하는 구문 -> 같지 않으면 이동 불가
			if(form.id.value == form.writer.value){
				// location = 'boardDeleteForm.jsp?num=' + num;
				form.action = 'boardDeleteForm.jsp';
				form.submit();
			}else{
				alert('작성자만 삭제 가능');
				return;
			}
		})
		
		// 댓글 쓰기 버튼 클릭 시
		let btn_review = document.getElementById("btn_review");
		btn_review.addEventListener("click", function(){
			form.submit();
		})
		
		// 목록 보기 버튼 클릭 시
		let pageNum = form.pageNum.value;
		let btn_boardList = document.getElementById("btn_boardList");
		btn_boardList.addEventListener("click", function(){
			location = 'boardList.jsp?pageNum=' + pageNum;
		})
	})
</script>
</head>
<body>
<%
String memberId = (String)session.getAttribute("memberId");

if(memberId == null){
	out.print("<script>location='../logon/memberLoginForm.jsp'</script>");
}

//날짜 형식 클래스
SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm");

String pageNum = request.getParameter("pageNum");
int num = Integer.parseInt(request.getParameter("num"));
BoardDAO boardDAO = BoardDAO.getInstance();
BoardDTO board = boardDAO.getBoard(num);

// 원글의 정보
int ref = board.getRef();
int re_step = board.getRe_step();
int re_level = board.getRe_level();

%>
<div id="container">
	<div class="m_title"><a href="boardList.jsp">BOARD</a></div>
	<div class="s_title">글 상세 보기</div>
	
	<form action="boardWriteForm.jsp" method="post" name="contentForm">
	<input type="hidden" name="pageNum" value="<%=pageNum %>" >
	<input type="hidden" name="num" value="<%=board.getNum() %>" >		 <%-- 수정과 삭제에서 사용 --%>
	<%-- id와 writer를 사용하여 로그인한 회원과 글 작성자의 일치 여부 확인 --%>
	<input type="hidden" name="id" value="<%=memberId %>" > 			 <%-- 로그인한 멤버 --%>
	<input type="hidden" name="writer" value="<%=board.getWriter() %>" > <%-- 작성자 --%>
	<%-- 댓글 처리: ref, re_step, re_level --%>
	<input type="hidden" name="ref" value="<%=ref %>" >
	<input type="hidden" name="re_step" value="<%=re_step %>" >
	<input type="hidden" name="re_level" value="<%=re_level %>" >
		<table>
			<tr>
				<th width="15%">글 번호</th>
				<td width="85%"><%=board.getNum() %></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><%=board.getWriter() %></td>
			</tr>
			<tr>
				<th>제목</th>
				<td><%=board.getSubject() %></td>
			</tr>
			<tr class="content_row">
				<th>내용</th>
				<td><%=board.getContent() %></td>
			</tr>
			<tr>
				<th>등록일</th>
				<td><%=sdf.format(board.getRegDate()) %></td>
			</tr>
			<tr>
				<th>조회수</th>
				<td><%=board.getReadcount() %></td>
			</tr>
		</table>
		<div class="btns">
			<input type="button" value="글 수정" id="btn_update">&ensp;
			<input type="button" value="글 삭제" id="btn_delete">&ensp;
			<input type="button" value="댓글 쓰기" id="btn_review">&ensp;
			<input type="button" value="목록 보기" id="btn_boardList">
		</div>
	</form>
</div>
</body>
</html>