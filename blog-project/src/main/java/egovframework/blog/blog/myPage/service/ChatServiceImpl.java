package egovframework.fusion.blog.myPage.service;

import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.text.StringEscapeUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.blog.myPage.vo.BlogCategoryVO;
import egovframework.fusion.blog.myPage.vo.BlogCommentVO;
import egovframework.fusion.blog.myPage.vo.ChattingVO;
import egovframework.fusion.blog.myPage.vo.PostVO;
import egovframework.fusion.blog.myPage.vo.ViewVO;
import egovframework.fusion.blog.myPage.vo.VisitVO;
import egovframework.fusion.blog.user.service.BlogUserMapper;
import egovframework.fusion.blog.user.vo.BlogUserVO;

@Service
public class ChatServiceImpl extends EgovAbstractServiceImpl implements ChatService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MyPageServiceImpl.class);
	
	@Autowired
	ChatMapper chatMapper;
	
	@Override
	public List<ChattingVO> getChattingList(String userId){
		return chatMapper.getChattingList(userId);
	}
	
	@Override
	public int getChatRoomId(String receiverId,String userId) {
		Integer roomId=chatMapper.getChatRoomId(receiverId,userId);
		
		System.out.println("[serviceImpl]roomId:"+roomId);
		
		if(roomId!=null) {
			return roomId;
		}
		
		ChattingVO room = new ChattingVO();
		room.setUser1Id(userId);
		room.setUser2Id(receiverId);
		chatMapper.createChatRoom(room);
		System.out.println("user1: "+room.getUser1Id());
		System.out.println("user2: "+room.getUser2Id());
		
		return room.getRoomId();
		
	}
	
	@Override
	public List<ChattingVO> getChatting(int roomId){
		List<ChattingVO> chatting =  chatMapper.getChatting(roomId);
		
		for(ChattingVO chat: chatting) {
			chat.setSendingTime(formatDate(chat.getSendingTime()));
		}
		
		return chatting;
	}
	
	@Override
	public void saveMessage(ChattingVO chatting) {
		chatMapper.saveMessage(chatting);
	}
	
	public String formatDate(String date) {
		DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

		DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

		LocalDateTime dateTime = LocalDateTime.parse(date, inputFormat);
		String formattedDate = dateTime.format(dateFormat);
		return formattedDate;
	}
	
	@Override
	public void markMessageAsY(int roomId, String senderId, String receiverId) {
		chatMapper.markMessageAsY(roomId,senderId,receiverId);
	}
	
}