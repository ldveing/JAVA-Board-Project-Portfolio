<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.*" %>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보확인</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Anton&family=Paytone+One&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap');
#container {width: 500px; margin: 0 auto;}
a { text-decoration: none; color: black;}
input[type="text"], input[type="password"] {height: 18px;}
/* 상단 - 메인 & 서브 타이틀 */
.m_title {font-family: 'Paytone One', sans-serif; font-size: 3em; text-align: center;}
.s_title {font-family: 'Jua', sans-serif; font-size: 2em; text-align: center; margin-bottom: 30px;}
/*중단 - 입력 테이블 */
table {width: 100%; border: 1px solid black; border-collapse: collapse;}
tr {height: 70px;}
th,td {border: 1px solid black; padding-left: 5px;}
th {background: #ced4da;}
.c_id{ background: #ccc;}
.s_id{ color: red; font-size: 0.9em;}
.addr_row {height: 100px;}
.addr_row input {margin: 2px 0;}
#btn_address {width: 100px; height: 28px; border: none; background: #2f9277; color: white; font-size: 12px;
cursor: pointer; border-radius: 3px;}
span {font-size: 0.8em;}
/* 하단 - 가입, 취소 버튼 */
.btns {text-align: center; margin-top: 30px;}
.btns input[type="button"] {width: 120px; height: 40px; background: black; color: white; border: none;
font-size: 16px; font-weight: bold; cursor: pointer;}
</style>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
	document.addEventListener("DOMContentLoaded", function () {
		let form = document.infoForm;
		let id = form.id;
		let pwd = form.pwd;
		let pwd2 = form.pwd2;
		let name = form.name;
		let email = form.email;
		let tel = form.tel;
		let address = form.address;
		let address2 = form.address2;

		// 비밀번호(pwd) 유효성 검사 - 4글자 이상 입력
		let chk_pwd = document.getElementById("chk_pwd");
		pwd.addEventListener("keyup", function () {
			if(pwd.value.length < 4){
				chk_pwd.innerText = "비밀번호는 4글자 이상이어야 합니다.";
				chk_pwd.style.color = "red";
			} else{
				chk_pwd.innerText = "사용 가능한 비밀번호입니다.";
				chk_pwd.style.color = "skyblue";
			}
		})
		
		let chk_pwd2 = document.getElementById("chk_pwd2");
		pwd2.addEventListener("keyup",function(){
			if(pwd.value == pwd2.value){
				chk_pwd2.innerText = "비밀번호가 일치합니다";
				chk_pwd2.style.color = "skyblue";
			}else{
				chk_pwd2.innerText = "비밀번호가 일치하지 않습니다.";
				chk_pwd2.style.color = "red";
			}
		})
		
		// 이메일 검사 함수
		let isEmail = function(value){
			return (value.indexOf('@') > 2) && (value.split('@')[1].indexOf('.') > 2)
		}
		
		// 이메일 확인
		// 1. '@'문자 포함 여부 확인 -> 아이디가 3글자 이상인지
		// 2. '@'문자 다음에 '.'을 포함하고 있는지 -> 회사 이름도 3글자 이상인지
		let chk_email = document.getElementById("chk_email");
		email.addEventListener("keyup", function(event){
			let value = event.currentTarget.value;
			
			if(isEmail(value)){ // 이메일 형식이 맞을 때
				chk_email.innerText = "이메일 형식이 맞습니다. " + value;
				chk_email.style.color = "skyblue";
			}else{ // 이메일 형식이 아닐 때
				chk_email.innerText = "이메일 형식이 아닙니다. " + value;
				chk_email.style.color = "red";
			}
		})
		
		// 주소 찾기 버튼 - 다음 라이브러리 활용(다음이 비교적 쉽게 사용 가능)
		let btn_address = document.getElementById("btn_address");
		btn_address.addEventListener("click", function(){
			new daum.Postcode({
				oncomplete:function(data){
					address.value = data.address;
				}
			}).open();
		})
		
		// 회원 정보 수정 버튼 클릭 시, 회원 수정 페이지의 전체 내용 입력 유무에 따른 유효성 검사와 페이지 이동
		let btn_update = document.getElementById("btn_update");
		btn_update.addEventListener("click", function(){
			if(pwd.value.length == 0){
				alert('비밀번호를 입력하시오.');
				pwd.focus();
				return;
			}
			if(pwd2.value.length == 0){
				alert('비밀번호 확인해야 합니다.');
				pwd2.focus();
				return;
			}
			if(pwd.value != pwd2.value){
				alert('비밀번호와 비밀번호 확인이 일치하지 않습니다.');
				pwd2.focus();
				return;
			}
			
			if(name.value.length == 0){
				alert('이름을 입력하시오.');
				name.focus();
				return;
			}
			if(email.value.length == 0){
				alert('이메일을 입력하시오.');
				email.focus();
				return;
			}
			if(tel.value.length == 0){
				alert('전화번호를 입력하시오.');
				tel.focus();
				return;
			}
			if(address.value.length == 0){
				alert('주소를 입력하시오.');
				address.focus();
				return;
			}
			if(address2.value.length == 0){
				alert('상세 주소를 입력하시오.');
				address2.focus();
				return;
			}
			form.action = 'memberUpdatePro.jsp';
			form.submit();
		})
		
		// 회원 탈퇴 버튼 클릭 시, 회원 탈퇴(삭제)
		let btn_delete = document.getElementById("btn_delete");
		btn_delete.addEventListener("click", function(){
			let form = document.infoForm;
			if(!form.id.value){
				alert('아이디를 입력하시오');
				form.id.focus();
				return;
			}
			if(!form.pwd.value){
				alert('비밀번호를 입력하시오');
				form.pwd.focus();
				return;
			}
			if(!form.pwd2.value){
				alert('비밀번호 확인을 입력하시오');
				form.pwd2.focus();
				return;
			}
			if(pwd.value != pwd2.value){
				alert('비밀번호가 일치하지 않습니다.');
				form.pwd2.focus();
				return;
			}
			
			let answer = confirm('탈퇴하시겠습니까???');
			if(answer){
				form.action = 'memberDeletePro.jsp';
				form.submit();
			} else {
				return;
			}
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

// 아래는 세션 memberid가 있을 때 실행
MemberDAO memberDAO = MemberDAO.getInstance();
MemberDTO member = new MemberDTO();
member = memberDAO.getMember(memberId);

//날짜 형식 클래스
SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm");
%>
<div id="container">
	<div class="m_title"><a href="../board/boardList.jsp">BOARD</a></div>
	<div class="s_title">회원정보확인</div>
	
	<form action="memberUpdatePro.jsp" method="post" name="infoForm">
		<table>
			<tr>
				<th>아이디</th>
				<td>
					<input type="text" name="id" size="15" value="<%=member.getId()%>" class="c_id" readonly>
					&ensp;<span class="s_id">아이디는 변경 불가</span>
				</td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td>
					<input type="password" name="pwd" size="15" value="<%=member.getPwd()%>"><br>
					<span id="chk_pwd"></span>
				</td>
			</tr>
			<tr>
				<th>비밀번호 확인</th>
				<td>
					<input type="password" name="pwd2" size="15"><br>
					<span id="chk_pwd2"></span>
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" name="name" size="15" value="<%=member.getName()%>" ></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>
					<input type="text" name="email" size="30" value="<%=member.getEmail()%>" ><br>
					<span id="chk_email"></span>
				</td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td><input type="text" name="tel" size="20" value="<%=member.getTel()%>" ></td>
			</tr>
			<tr class="addr_row">
				<th>주소</th>
				<td>
					<input type="button" value="주소 찾기" id="btn_address"><br>
					<input type="text" name="address" size="49"><br>
					<input type="text" name="address2" size="49">
				</td>
			</tr>
			<tr>
				<th>가입 날짜</th>
				<td><%=sdf.format(member.getRegDate()) %></td>
			</tr>
		</table>
		<div class="btns">
			<input type="button" value="회원 정보 수정" id="btn_update">&emsp;&emsp;
			<input type="button" value="회원 탈퇴" id="btn_delete">
		</div>
	</form>
</div>
</body>
</html>