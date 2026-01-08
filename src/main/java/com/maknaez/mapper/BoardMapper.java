package com.maknaez.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.maknaez.model.BoardDTO;
import com.maknaez.model.FaqDTO;

public interface BoardMapper {
	public void insertBoard(BoardDTO dto) throws SQLException;
	public List<BoardDTO> listBoard(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public BoardDTO findById(long num);
	public void updateHitCount(long num) throws SQLException;
	public void deleteBoard(long num) throws SQLException;

    public BoardDTO findByPrev(Map<String, Object> map);
    public BoardDTO findByNext(Map<String, Object> map);

    public List<BoardDTO> listNotice(Map<String, Object> map);
    public int dataCountNotice();
    public BoardDTO findByIdNotice(long num);
    public void updateHitCountNotice(long num) throws SQLException;

    public List<FaqDTO> listFaq(Map<String, Object> map);
}