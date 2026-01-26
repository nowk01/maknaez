package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.mapper.BoardMapper;
import com.maknaez.model.BoardDTO;
import com.maknaez.model.FaqDTO;
import com.maknaez.mybatis.support.MapperContainer;

public class BoardServiceImpl implements BoardService {
	private BoardMapper mapper = MapperContainer.get(BoardMapper.class);

	@Override
	public void insertBoard(BoardDTO dto) throws Exception {
		try {
			mapper.insertBoard(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public List<BoardDTO> listBoard(Map<String, Object> map) {
		try {
			return mapper.listBoard(map);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		try {
			return mapper.dataCount(map);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public BoardDTO findById(long num) {
		try {
			return mapper.findById(num);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public void updateHitCount(long num) throws Exception {
		try {
			mapper.updateHitCount(num);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteBoard(long num) throws Exception {
		try {
			mapper.deleteBoard(num);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public BoardDTO findByPrev(Map<String, Object> map) {
		try {
			return mapper.findByPrev(map);
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public BoardDTO findByNext(Map<String, Object> map) {
		try {
			return mapper.findByNext(map);
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public void updateBoardReply(BoardDTO dto) throws Exception {
		try {
			mapper.updateBoardReply(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void insertNotice(BoardDTO dto) throws Exception {
		try {
			mapper.insertNotice(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void updateNotice(BoardDTO dto) throws Exception {
		try {
			mapper.updateNotice(dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void updateHitCountNotice(long num) throws Exception {
	    try {
	        mapper.updateHitCountNotice(num);
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}

	@Override
	public BoardDTO findByIdNotice(long num) {
	    try {
	        return mapper.findByIdNotice(num);
	    } catch (Exception e) {
	        return null;
	    }
	}
	
	@Override
	public void deleteNotice(long num) throws Exception {
		try {
			mapper.deleteNotice(num);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public List<BoardDTO> listNotice(Map<String, Object> map) {
		try {
			return mapper.listNotice(map);
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public int dataCountNotice(Map<String, Object> map) {
		try {
			return mapper.dataCountNotice(map);
		} catch (Exception e) {
			return 0;
		}
	}


	@Override
	public List<FaqDTO> listFaq(Map<String, Object> map) {
		try {
			return mapper.listFaq(map);
		} catch (Exception e) {
			return null;
		}
	}
}