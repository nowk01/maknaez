package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.model.BoardDTO;
import com.maknaez.model.FaqDTO;

public interface BoardService {
	public void insertBoard(BoardDTO dto) throws Exception;
	public List<BoardDTO> listBoard(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public BoardDTO findById(long num);
	public void updateHitCount(long num) throws Exception;
	public BoardDTO findByPrev(Map<String, Object> map);
	public BoardDTO findByNext(Map<String, Object> map);
	public void deleteBoard(long num) throws Exception;

	public List<BoardDTO> listNotice(Map<String, Object> map);
	public int dataCountNotice();
	public BoardDTO findByIdNotice(long num);
	
	public List<FaqDTO> listFaq(Map<String, Object> map);
}