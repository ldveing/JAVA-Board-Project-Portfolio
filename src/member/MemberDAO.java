package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.JDBCUtil;

// DAO(Data Access Object) - DB 연결, 해제, 질의를 담당
public class MemberDAO {
	// Singleton Pattern(싱글톤 패턴) - 클래스의 인스턴스 하나만 생성하는 방법 
	private MemberDAO(){ }// 생성자
	
	private static MemberDAO memberDAO = new MemberDAO(); // <-- 인스턴스 생성
	
	public static MemberDAO getInstance(){
		return memberDAO;
	}
	
	// DB 연결, 질의 객체 선언
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 회원 가입 메소드
	public int insertMember(MemberDTO member) {
		String sql = "insert into member values(?, ?, ?, ?, ?, ?, now())";
		int cnt = 0; // 성공 여부
		
		try {
			conn = JDBCUtil.getConnection();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getId());
			pstmt.setString(2, member.getPwd());
			pstmt.setString(3, member.getName());
			pstmt.setString(4, member.getEmail());
			pstmt.setString(5, member.getTel());
			pstmt.setString(6, member.getAddress());
			cnt = pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt);
		}
		return cnt;
	}
	
	// 회원 ID 중복 체크
	public int checkID(String id) {
		String sql = "select * from member where id = ?";
		int cnt = 0;// 성공 여부
		
		try {
			conn = JDBCUtil.getConnection();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {// 중복되는 아이디
				cnt = 0;
			}else {// 사용 가능한 아이디
				cnt = 1;
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return cnt;
	}
	
	// 로그인 메소드
	public int login(String id, String pwd) {
		String sql = "select * from member where id = ?";
		int cnt = -1; // -1: 아이디 없음, 0: ID 일치 & PW 불일치, 1: ID & PW 둘 다 일치
		
		try {
			conn = JDBCUtil.getConnection();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {// 아이디 있음
				String dbPwd = rs.getString("pwd");
				if(pwd.equals(dbPwd)) {// ID & PW 둘 다 일치
					cnt = 1;
				}else { // ID 일치 & PW 불일치
					cnt= 0;
				}
			}else {// 아이디 없음
				cnt = -1;
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return cnt;
	}
	
	// 회원 정보 보기(1명, 자신의 정보)
	public MemberDTO getMember(String id) {
		String sql = "select * from member where id = ?";
		MemberDTO member = new MemberDTO();
		
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				// 가입일을 제외한 정보를 member 테이블로부터 가져와서 member 객체에 저장
				member.setId(rs.getString("id"));
				member.setPwd(rs.getString("pwd"));
				member.setName(rs.getString("name"));
				member.setEmail(rs.getString("email"));
				member.setTel(rs.getString("tel"));
				member.setAddress(rs.getString("address"));
				member.setRegDate(rs.getTimestamp("regDate"));
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return member;
	}
	
	// 회원 정보 수정
	public int updateMember(MemberDTO member) {
		String sql = "update member set pwd=?, name=?, email=?, tel=?, address=? where id = ?";
		int cnt = 0; // 성공 여부
		
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getPwd());
			pstmt.setString(2, member.getName());
			pstmt.setString(3, member.getEmail());
			pstmt.setString(4, member.getTel());
			pstmt.setString(5, member.getAddress());
			pstmt.setString(6, member.getId());
			cnt = pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt);
		}
		return cnt;
	}
	
	// 회원 삭제(탈퇴) 메소드 -> 해당 회원 탈퇴 시, 게시판 글도 삭제
	// 트랜잭션(Transaction) 처리
	public int deleteMember(String id, String pwd) throws Exception {
		String sql1 = "delete from member where id = ? and pwd = ?";
		String sql2 = "delete from board where writer = ?";
		int cnt = 0; // 성공 여부
		
		try {
			conn = JDBCUtil.getConnection();
			
			// 트랜잭션(transaction) 처리 - DML(insert, update, delete) 작업이 2개 이상 동시에 처리 되어야 할 때
			// 모두 처리 되거나 모두 처리되지 않게 하던지 하는 방법
			// All or Nothing
			
			// transaction 1단계 - autocommit 기능을 끔
			conn.setAutoCommit(false);
			// 1번 작업: 회원 삭제(탈퇴)
			pstmt = conn.prepareStatement(sql1);
			pstmt.setString(1, id);
			pstmt.setString(2, pwd);
			cnt = pstmt.executeUpdate();
			
			// 2번 작업: 해당 회원이 작성한 게시판 글 모두 삭제
			pstmt = conn.prepareStatement(sql2);
			pstmt.setString(1, id);
			cnt = pstmt.executeUpdate();
			
			// transaction 2단계 - 모든 작업이 완료되면 커밋을 함
			conn.commit();

			// transaction 3단계	- autocommit 기능을 다시 활성화
			conn.setAutoCommit(true);
			
		}catch (Exception e) {
			// 트랜잭션 처리 시에 예외 발생 시 롤백시킴
			conn.rollback();
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt);
		}
		return cnt;
	}
}
