package com.maknaez.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.maknaez.model.MemberDTO;

public interface MemberMapper {
	public MemberDTO loginMember(Map<String, Object> map);
	public void insertLoginLog(Map<String, Object> map);
	
	public void insertMember1(MemberDTO dto) throws SQLException;
	public void insertMember2(MemberDTO dto) throws SQLException;
	public void insertMember12(MemberDTO dto) throws SQLException;
	public void updateMember1(MemberDTO dto) throws SQLException;
	public void updateMember2(MemberDTO dto) throws SQLException;
	public void updateMemberLevel(Map<String, Object> map) throws SQLException;
	public void deleteProfilePhoto(Map<String, Object> map) throws SQLException;
	public void deleteMember1(Map<String, Object> map) throws SQLException;
	public void deleteMember2(Map<String, Object> map) throws SQLException;
	
	public MemberDTO findById(String userId);
	public MemberDTO findByIdx(Long memberIdx);	
	public List<Map<String, Object>> listAgeSection();
	
	public Integer dataCount(Map<String, Object> map);
	public List<MemberDTO> listMember(Map<String, Object> map);
}
