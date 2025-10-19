package egovframework.fusion.blog.myPage.service;


import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.blog.myPage.vo.BlogCategoryVO;
import egovframework.fusion.blog.myPage.vo.BlogCommentVO;
import egovframework.fusion.blog.myPage.vo.ChattingVO;
import egovframework.fusion.blog.myPage.vo.PostVO;
import egovframework.fusion.blog.myPage.vo.ViewVO;
import egovframework.fusion.blog.myPage.vo.VisitVO;
import egovframework.fusion.blog.user.vo.BlogUserVO;


@Mapper
public interface ChatMapper {

	public List<ChattingVO> getChattingList(@Param("userId")String userId);
	
	public Integer getChatRoomId(@Param("receiverId")String receiverId,@Param("userId")String userId);
	
	public void createChatRoom(ChattingVO chattingVo);
	
	public List<ChattingVO> getChatting(@Param("roomId")int roomId);
	
	public void saveMessage(ChattingVO chatting);
	
	public void markMessageAsY(@Param("roomId")int roomId,@Param("senderId")String senderId,@Param("receiverId")String receiverId);
}
