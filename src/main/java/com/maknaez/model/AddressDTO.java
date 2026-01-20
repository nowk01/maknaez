package com.maknaez.model;

public class AddressDTO {
    private long addrId;        // DB: addr_id (PK)
    private long memberIdx;     // DB: memberIdx (FK)
    private String addrName;    // DB: addr_name (배송지명: 집, 회사 등) - 현재 JSP엔 입력칸 없음(Null 처리)
    private String receiverName;// DB: receiver_name (받는 사람)
    private String receiverTel; // DB: receiver_tel (전화번호)
    private String zipCode;     // DB: zip_code (우편번호)
    private String addr1;       // DB: addr1
    private String addr2;       // DB: addr2
    private int isBasic;        // DB: isbasic (0:일반, 1:기본)
    
    // Getter & Setter
    public long getAddrId() { return addrId; }
    public void setAddrId(long addrId) { this.addrId = addrId; }
    
    public long getMemberIdx() { return memberIdx; }
    public void setMemberIdx(long memberIdx) { this.memberIdx = memberIdx; }
    
    public String getAddrName() { return addrName; }
    public void setAddrName(String addrName) { this.addrName = addrName; }
    
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
    
    public String getReceiverTel() { return receiverTel; }
    public void setReceiverTel(String receiverTel) { this.receiverTel = receiverTel; }
    
    public String getZipCode() { return zipCode; }
    public void setZipCode(String zipCode) { this.zipCode = zipCode; }
    
    public String getAddr1() { return addr1; }
    public void setAddr1(String addr1) { this.addr1 = addr1; }
    
    public String getAddr2() { return addr2; }
    public void setAddr2(String addr2) { this.addr2 = addr2; }
    
    public int getIsBasic() { return isBasic; }
    public void setIsBasic(int isBasic) { this.isBasic = isBasic; }
    
    public String getTelFormat() {
		if (receiverTel == null || receiverTel.length() == 0) {
			return "";
		}
		
		String tel = receiverTel.replaceAll("[^0-9]", ""); // 숫자만 남김
		return tel.replaceAll("^(02|0505|1[0-9]{3}|0[0-9]{2})([0-9]+)([0-9]{4})$", "$1 - $2 - $3");
	}
}