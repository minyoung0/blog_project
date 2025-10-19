package egovframework.fusion.blog.myPage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.fusion.blog.myPage.service.ChatService;
import egovframework.fusion.blog.myPage.service.MyPageService;
import egovframework.fusion.blog.myPage.vo.BlogCategoryVO;
import egovframework.fusion.blog.myPage.vo.ChattingVO;
import egovframework.fusion.blog.user.service.BlogUserService;
import egovframework.fusion.blog.user.vo.BlogUserVO;
import egovframework.fusion.user.service.UserService;

@Controller

public class ChatController {
	
	@Autowired
	BlogUserService userService;
	
	@Autowired
	MyPageService myPageService;
	
	@Autowired
	ChatService chatService;
	
	@GetMapping("/chat/getChatList.do")
	public String getChatList(Model model,@RequestParam("userId")String userId) {
		try {
 			List<ChattingVO> chattingList = chatService.getChattingList(userId);
			
			model.addAttribute("chattingList",chattingList);
			return "/views/blog/chatting/chattingMain";
		} catch (Exception e) {
			e.printStackTrace();
			return "/views/blog/error";
		}
	}
	
	@PostMapping("/chat/getChatRoom.do")
	@ResponseBody
	public Map<String,Object> getChatRoom(@RequestParam("receiverId")String receiverId,HttpSession session){
		Map<String,Object> response=new HashMap<>();
		try {
			String userId=(String)session.getAttribute("userId");
			System.out.println("[getChatRoom] receiverId: "+receiverId+", userId: "+userId);
			int roomId=chatService.getChatRoomId(receiverId,userId);
			
			response.put("receiverId", receiverId);
			response.put("userId", userId);
			response.put("roomId",roomId);
			response.put("result", "success");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("result","fail");
			return response;
		}
	}
	
	@GetMapping("/chat/getMessage.do")
	public String getMessage(@RequestParam("receiverId")String receiverId,@RequestParam("roomId")int roomId,Model model,HttpSession session) {
		try {
			List<ChattingVO> message=chatService.getChatting(roomId);
			BlogUserVO receiverInfo=myPageService.getUserInfo(receiverId);
			model.addAttribute("partner",receiverInfo);
			model.addAttribute("message",message);
			return "/views/blog/chatting/chattingRoom";
		} catch (Exception e) {
			e.printStackTrace();
			return "/views/blog/error";
		}
	}
	
	
}
