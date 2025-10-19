package egovframework.fusion.user.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.fusion.user.vo.UserVO;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.user.service.UserService;

@Controller
public class UserController{
	
	@Autowired
	UserService userService;
	
	@RequestMapping(value = "/user/join.do", method = RequestMethod.GET)
	public String userList(UserVO userVo, Model model) {
		
		try {
//			List<UserVO> UserList = userService.getUserList(userVo);
//			model.addAttribute("userList", UserList);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return "views/user/join";
	}

	
	
	@RequestMapping(value="/user/insUser.do", method=RequestMethod.POST)
	public String insUser(@ModelAttribute UserVO userVo, Model model) {	
		
		try {
			userService.insUser(userVo);
			model.addAttribute("successMessage","회원가입이 완료되었습니다.");
			return "views/user/registerSuccess";
		}catch(IllegalArgumentException e) {
			model.addAttribute("errorMessage",e.getMessage());
			return "views/user/join";
		}

	}
	
	
	@RequestMapping(value = "/user/loginPage.do", method = RequestMethod.GET)
	public String loginPage(UserVO userVo, Model model) {
		
		return "views/user/login";
	}
	
	
	@RequestMapping(value="/user/login.do", method=RequestMethod.POST)
	public String login(UserVO userVo,HttpSession session,Model model) {
		
		 try {
		        // 서비스에서 로그인 처리
		        UserVO user = userService.login(userVo);
		        
		        if (user != null) {
		            // 로그인 성공: 세션에 사용자 정보 저장
		            session.setAttribute("loggedInUser", user); // 세션에 사용자 객체 저장
		            session.setAttribute("userId", user.getUserId());
		            session.setAttribute("accessRight",user.getAccessRight());
		            System.out.println("user access:"+user.getAccessRight());
					/*
					 * return "redirect:/gallery/galleryList.do"; // 로그인 후 게시판으로 이동
					 */
		            return "redirect:/main/main.do";
		        } else {
		            // 로그인 실패: 에러 메시지 전달
		            model.addAttribute("errorMessage", "로그인 정보가 올바르지 않습니다.");
		            return "views/user/login"; // 로그인 화면으로 다시 이동
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        model.addAttribute("errorMessage", "시스템 오류가 발생했습니다.");
		        return "views/user/login"; // 에러 발생 시 로그인 화면으로 이동
		    }
	}
	
	@RequestMapping(value="/user/logout.do", method=RequestMethod.GET)
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/main/main.do";
	}
	
	
	@RequestMapping(value = "/user/joinPage.do", method = RequestMethod.GET)
	public String joinPage(UserVO userVo, Model model) {
		
		return "views/user/join";
	}
	

	
}