package com.maknaez.service;

import java.util.List;
import java.util.Map;
import com.maknaez.model.BoardDTO;
import com.maknaez.model.FaqDTO;

public interface BoardService {
	// 1:1 문의
	public void insertBoard(BoardDTO dto) throws Exception;
	public List<BoardDTO> listBoard(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public BoardDTO findById(long num);
	public void updateHitCount(long num) throws Exception;
	public void updateBoardReply(BoardDTO dto) throws Exception; // 답변 등록
	public BoardDTO findByPrev(Map<String, Object> map);
	public BoardDTO findByNext(Map<String, Object> map);
	public void deleteBoard(long num) throws Exception;

	// 공지사항
	public void insertNotice(BoardDTO dto) throws Exception; // 공지 등록
	public void updateNotice(BoardDTO dto) throws Exception; // 공지 수정
	public void deleteNotice(long num) throws Exception;     // 공지 삭제
	public List<BoardDTO> listNotice(Map<String, Object> map);
	public int dataCountNotice(Map<String, Object> map); // 파라미터 추가됨
	public BoardDTO findByIdNotice(long num);
	public void updateHitCountNotice(long num) throws Exception;
	
	// FAQ
	public List<FaqDTO> listFaq(Map<String, Object> map);

}