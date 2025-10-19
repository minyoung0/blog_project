package egovframework.fusion.blog.myPage.service;



import java.util.List;

import egovframework.fusion.blog.myPage.vo.BlogCategoryVO;
import egovframework.fusion.blog.myPage.vo.BlogCommentVO;
import egovframework.fusion.blog.myPage.vo.ChattingVO;
import egovframework.fusion.blog.myPage.vo.PostVO;
import egovframework.fusion.blog.myPage.vo.VisitVO;
import egovframework.fusion.blog.user.vo.BlogUserVO;

public interface ChatService {
	
	/* public void saveMessage(ChattingVO chattingVo); */
	
	public List<ChattingVO> getChattingList(String userId);
	
	public int getChatRoomId(String receiverId,String userId);
	
	public List<ChattingVO> getChatting(int roomId);
	
	public void saveMessage(ChattingVO chatting);
	
	public void markMessageAsY(int roomId, String senderId,String receiverId);
}	



