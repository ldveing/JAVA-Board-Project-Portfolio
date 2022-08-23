<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login form</title>
</head>
<style>
@import url('https://fonts.googleapis.com/css2?family=Anton&family=Paytone+One&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Hammersmith+One&display=swap');
#container {width: 450px; margin: 0 auto;}
a{text-decoration: none; color: black;}
/* 상단 - 메인 & 서브 타이틀 */
.m_title {font-family: 'Paytone One', sans-serif; font-size: 3em; text-align: center;}
.s_title {font-family: 'Hammersmith One', sans-serif; font-size: 2em; text-align: center; margin-bottom: 20px;}
/* 중단 - 입력창 */
.f_input {text-align: center; border: 1px solid #ccc; padding: 10px;}
.f_input .c_id, .f_input .c_pwd {height: 45px; margin-top: 20px; padding-left: 5px;}
.f_input .f_chk {text-align: left; margin-top: 10px; font-size: 0.9em; color: gray;}
.f_input #btn_login {width: 425px; height: 47px; margin-top: 25px; background: black; color: white; 
font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 25px; margin-bottom: 10px;}
/* 하단 - 비밀번호 찾기, 아이디 찾기, 회원가입 */
.f_a {text-align: center; margin-top: 30px; font-size: 0.9em;}
.f_a a {color: gray;}
</style>
<script>
	document.addEventListener("DOMContentLoaded", function(){
		let form = document.loginForm;
		
		// 로그인 버튼을 클릭 시, 유효성 검사
		let btn_login = document.getElementById("btn_login");
		btn_login.addEventListener("click",function(){
			if(!form.id.value){
				alert('아이디를 입력하시오');
				form.id.focus();
				return
			}
			if(!form.pwd.value){
				alert('비밀번호를 입력하시오');
				form.pwd.focus();
				return
			}
			form.submit();
		})
		
		// 쿠키가 생성되어 있을 때, 쿠키에 저장된 값인 아이디를 아이디 입력상자에 놓도록 하는 작업
		// 쿠키 확인 - 쿠키가 존재한다면
		if(document.cookie.length > 0){
			let search = "cookieId=";
			let idx = document.cookie.indexOf(search); // 쿠키 중에서 cookieId=이 나오는 위치
			if(idx != -1){ // cookieId가 있다면
				idx += search.length;
				let end = document.cookie.indexOf(';',idx);
				
				if(end == -1){
					end = document.cookie.length;
				}
				
				form.id.value = document.cookie.substring(idx, end);
				form.chk.checked = true;
			}
		}
		
		// 로그인 상태 유지 체그 박스 체크 시, 아이디 저장 -> 쿠키 사용
		// http 속성: 연결 상태를 유지하지 않음.
		// cookie, session: 연결 상태 유지. cookie: 연결 정보를 클라이언트 쪽에 저장 , session: 연결 정보를 서버 쪽에 저장
		// escape() 함수: *, -, _, +, ., / 를 제외한 모든 문자를 16진수로 변환하는 함수
		// 쉼표, 세미콜론 등과 같은 문자가 쿠키에서 사용되는 문자열과 충돌을 방지하기 위해서 사용
		let chk = document.getElementById("chk");
		chk.addEventListener("click", function(){
			let now = new Date(); // 오늘 날짜
			let name = "cookieId";// 쿠키 이름
			let value = form.id.value;// 쿠키 값
			
			if(form.chk.checked == true){ // 체크 박스 체크 -> 쿠키 생성
				// 쿠키 만료 날짜: 날짜를 지금으로 부터 7일 후로 설정
				now.setDate(now.getDate() + 7); 
			}else{ // 체크 박스 해제 -> 쿠키 삭제
				// 쿠키 만료 날짜: 날짜를 지금으로 설정
				now.setDate(now.getDate() + 0);
			}
			// 쿠키 생성 시 필요한 정보: 쿠키 이름 & 값, 쿠키 위치, 만료 시간
			document.cookie = name + "=" + escape(value) + ";path=/;expires=" + now.toGMTString() + ";";
		})
	})
</script>
<body>
<div id="container">
	<div class="m_title"><a href="#">BOARD</a></div>
	<div class="s_title">LOGIN</div>
	<form action="memberLoginPro.jsp" method="post" name="loginForm">
		<div class="f_input">
			<div class="f_id"><input type="text" id="id" name="id" class="c_id" placeholder="아이디" size="55"></div>
			<div class="f_pwd"><input type="password" id="pwd" name="pwd" class="c_pwd" placeholder="비밀번호" size="55"></div>
			<div class="f_chk">
				<input type="checkbox" id="chk" class="c_chk" size="55">&nbsp;
				<label for="chk">로그인 상태 유지</label>
			</div>
			<div class="f_submit"><input type="button" value="로그인" id="btn_login"></div>
		</div>
		<div class="f_a">
			<a href="#">비밀번호 찾기</a>&ensp;|&ensp;
			<a href="#">아이디 찾기</a>&ensp;|&ensp;
			<a href="../member/memberJoinForm.jsp">회원가입</a>
		</div>
	</form>
</div>
</body>
</html>