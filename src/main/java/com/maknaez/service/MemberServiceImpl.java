package com.maknaez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.MemberMapper;
import com.maknaez.model.AddressDTO;
import com.maknaez.model.MemberDTO;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.mybatis.support.SqlSessionManager;

public class MemberServiceImpl implements MemberService {
	private MemberMapper mapper = MapperContainer.get(MemberMapper.class);

	@Override
	public MemberDTO loginMember(Map<String, Object> map) {
		MemberDTO dto = null;
		
		try {
			dto = mapper.loginMember(map);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public void insertMember(MemberDTO dto) throws Exception {
		try {
			mapper.insertMember1(dto);
			mapper.insertMember2(dto);
			mapper.insertMember3(dto);
			
		} catch (Exception e) {
			// 트랜잭션 처리
			SqlSessionManager.setRollbackOnly();
			
			e.printStackTrace();
			
			throw e;
		}
		
	}

	@Override
	public void updateMember(MemberDTO dto) throws Exception {
		try {
			mapper.updateMember1(dto);
			mapper.updateMember2(dto);
		} catch (Exception e) {
			SqlSessionManager.setRollbackOnly();
			
			e.printStackTrace();
			
			throw e;
		}
	}

	@Override
	public void updateMemberLevel(Map<String, Object> map) throws Exception {
		try {
			mapper.updateMemberLevel(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void deleteProfilePhoto(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteProfilePhoto(map);
		} catch (Exception e) {
			e.printStackTrace();
			
			throw e;
		}
	}

	@Override
	public void deleteMember(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteMember1(map);
			mapper.deleteMember2(map);
		} catch (Exception e) {
			SqlSessionManager.setRollbackOnly();
			
			e.printStackTrace();
			
			throw e;
		}
	}
	
	@Override
	public MemberDTO findById(String memberId) {
		MemberDTO dto = null;
		try {
			dto = mapper.findById(memberId);
			
			if(dto != null && dto.getEmail() != null) {
				String[] ss = dto.getEmail().split("@");
				if(ss.length == 2) {
					dto.setEmail1(ss[0]);
					dto.setEmail2(ss[1]);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			throw e;
		}
		return dto;
	}

	@Override
	public MemberDTO findByIdx(Long memberIdx) {
		MemberDTO dto = null;
		try {
			dto = mapper.findByIdx(memberIdx);
			
			if(dto != null && dto.getEmail() != null) {
				String[] ss = dto.getEmail().split("@");
				if(ss.length == 2) {
					dto.setEmail1(ss[0]);
					dto.setEmail2(ss[1]);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			throw e;
		}
		return dto;
	}
	
	@Override
	public MemberDTO findByNickName(String nickName) {
	    MemberDTO dto = null;
	    try {
	        dto = mapper.findByNickName(nickName);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return dto;
	} 
	@Override
	public List<Map<String, Object>> listAgeSection() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Integer dataCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCount(map);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<MemberDTO> listMember(Map<String, Object> map) {
		List<MemberDTO> list = null;
		
		try {
			list = mapper.listMember(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public void releaseDormantMembers(List<Long> idxList) throws Exception {
		try {
	        for(Long memberIdx : idxList) {
	            Map<String, Object> map = new HashMap<>();
	            map.put("memberIdx", memberIdx);
	            map.put("enabled", 1); 
	            
	            mapper.updateEnabled(map);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}

	@Override
	public List<MemberDTO> listDormantMembers(Map<String, Object> map) throws Exception {
		List<MemberDTO> list = null;
		try {
			list = mapper.listDormantMembers(map);
			return list;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public Integer dataCountDormant(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCountDormant(map);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@Override
	public void insertAddress(AddressDTO dto) throws Exception {
	    try {
	        // [추가 로직] 만약 '기본 배송지'로 설정(isBasic=1)했다면, 
	        // 해당 회원의 기존 기본 배송지 설정을 모두 해제(0) 먼저 수행
	        if (dto.getIsBasic() == 1) {
	            mapper.updateAddressBasicReset(dto.getMemberIdx());
	        }
	        
	        // 그 다음 새로운 배송지 추가
	        mapper.insertAddress(dto);
	        
	    } catch (Exception e) {
	        // 에러 발생 시 롤백 처리
	        SqlSessionManager.setRollbackOnly();
	        e.printStackTrace();
	        throw e;
	    }
	}

	@Override
	public List<AddressDTO> listAddress(long memberIdx) {
		List<AddressDTO> list = null;
		try {
			list = mapper.listAddress(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public void deleteAddress(long addrId) throws Exception {
		try {
			mapper.deleteAddress(addrId);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void insertLoginLog(MemberDTO dto) throws Exception {
		try {
			mapper.insertLoginLog(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public void updateAddress(AddressDTO dto) throws Exception {
	    try {
	        // [중요 로직]
	        // 만약 이번에 수정하는 배송지를 '기본 배송지(1)'로 설정했다면?
	        // -> 기존에 있던 다른 기본 배송지를 '일반(0)'으로 바꿔줘야 합니다. (중복 방지)
	        if (dto.getIsBasic() == 1) {
	            mapper.updateAddressReset(dto.getMemberIdx()); 
	        }

	        // 배송지 정보 수정 실행
	        mapper.updateAddress(dto);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
}
