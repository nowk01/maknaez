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

    public void updateBoardReply(BoardDTO dto) throws SQLException;

    public List<BoardDTO> listNotice(Map<String, Object> map);

    public int dataCountNotice(Map<String, Object> map); 
    
    public BoardDTO findByIdNotice(long num);
    public void updateHitCountNotice(long num) throws SQLException;
    
    public void insertNotice(BoardDTO dto) throws SQLException;
    public void updateNotice(BoardDTO dto) throws SQLException;
    public void deleteNotice(long num) throws SQLException;

    public List<FaqDTO> listFaq(Map<String, Object> map);
}