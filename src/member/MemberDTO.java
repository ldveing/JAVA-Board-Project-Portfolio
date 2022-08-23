package member;

import java.sql.Timestamp;

// DTO, VO, DataBean
// useBaean 액션 태그 사용 -> 데이터의 이동에서 사용
public class MemberDTO {
	// 프로퍼티(Property) -> 맴버 변수
	// 아이디, 비번, 이름, 이멜일, 전화번호, 주소
	private String id;
	private String pwd;
	private String name;
	private String email;
	private String tel;
	private String address;
	private Timestamp regDate;

	//getter
	public String getId() {
		return id;
	}

	public String getPwd() {
		return pwd;
	}

	public String getName() {
		return name;
	}

	public String getEmail() {
		return email;
	}

	public String getTel() {
		return tel;
	}

	public String getAddress() {
		return address;
	}

	public Timestamp getRegDate() {
		return regDate;
	}

	//setter
	public void setId(String id) {
		this.id = id;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public void setRegDate(Timestamp regDate) {
		this.regDate = regDate;
	}

	
	@Override
	public String toString() {
		return "MemberDTO [id=" + id + ", pwd=" + pwd + ", name=" + name + ", email=" + email + ", tel=" + tel
				+ ", address=" + address + ", regDate=" + regDate + "]";
	}

}
