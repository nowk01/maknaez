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
		List<BoardDTO> list = null;
		try {
			list = mapper.listBoard(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
		try {
			result = mapper.dataCount(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public BoardDTO findById(long num) {
		BoardDTO dto = null;
		try {
			dto = mapper.findById(num);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
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
	public BoardDTO findByPrev(Map<String, Object> map) {
		BoardDTO dto = null;
		try {
			dto = mapper.findByPrev(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public BoardDTO findByNext(Map<String, Object> map) {
		BoardDTO dto = null;
		try {
			dto = mapper.findByNext(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
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
	public List<BoardDTO> listNotice(Map<String, Object> map) {
		List<BoardDTO> list = null;
		try {
			list = mapper.listNotice(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public int dataCountNotice() {
		int result = 0;
		try {
			result = mapper.dataCountNotice();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public BoardDTO findByIdNotice(long num) {
		BoardDTO dto = null;
		try {
			mapper.updateHitCountNotice(num);
			dto = mapper.findByIdNotice(num);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public List<FaqDTO> listFaq(Map<String, Object> map) {
		List<FaqDTO> list = null;
		try {
			list = mapper.listFaq(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}