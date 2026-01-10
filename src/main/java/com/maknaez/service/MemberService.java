package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.model.MemberDTO;

public interface MemberService {
	public MemberDTO loginMember(Map<String, Object> map);
	
	public void insertMember(MemberDTO dto) throws Exception;
	public void updateMember(MemberDTO dto) throws Exception;	
	public void updateMemberLevel(Map<String, Object> map) throws Exception;
	public void deleteProfilePhoto(Map<String, Object> map) throws Exception;
	public void deleteMember(Map<String, Object> map) throws Exception;
	
	public MemberDTO findByIdx(Long memberIdx);	
	public List<Map<String, Object>> listAgeSection();
	
	public Integer dataCount(Map<String, Object> map);
	public List<MemberDTO> listMember(Map<String, Object> map);
}
