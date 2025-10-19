package egovframework.fusion.blog.user.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

import egovframework.fusion.blog.myPage.service.MyPageService;
import egovframework.fusion.blog.user.service.BlogUserService;
import egovframework.fusion.blog.user.vo.BlogUserVO;
import egovframework.fusion.user.vo.UserVO;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

@Controller
public class BlogUserController {
	
	@Autowired
	BlogUserService userService;
	
	@Autowired
	MyPageService myPageService;

	


	@GetMapping("blog/loginPage.do")
	public String loginPage() {
		return "tiles/blog/loginPage";
	}
	
	@GetMapping("blog/joinPage.do")
	public String joinPage() {
		return "tiles/blog/joinPage";
	}
	
	@PostMapping("/blog/idDoubleCheck.do")
	@ResponseBody
	public Map<String,Object> idCheck(@RequestParam("id")String id){
		Map<String,Object> response = new HashMap<>();
		try {
			int result = userService.idCheck(id);
			System.out.println("result:"+result);
			if(result>0) {
				throw new RuntimeException();
			}
			else {				
				response.put("message", "사용가능한 아이디입니다");
				response.put("status","usable");
			}
				return response;
		} catch(RuntimeException e) {
			e.printStackTrace();
			response.put("message", "중복되는 아이디입니다.");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("message","오류발생");
			return response;
		}
		
	}
	
	@PostMapping("/blog/nickNameDoubleCheck.do")
	@ResponseBody
	public Map<String,Object> nickNameCheck(@RequestParam("nickName")String nickName){
		Map<String,Object> response = new HashMap<>();
		try {
			int result = userService.nickNameCheck(nickName);
			System.out.println("result:"+result);
			if(result>0) {
				throw new RuntimeException();
			}
			else {				
				response.put("message", "사용가능한 닉네임입니다");
				response.put("status","usable");
			}
				return response;
		} catch(RuntimeException e) {
			e.printStackTrace();
			response.put("message", "중복되는 닉네임입니다.");
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.put("message","오류발생");
			return response;
		}
	}
	
	@PostMapping("/blog/join.do")
	@ResponseBody
	public Map<String,Object> join(@RequestParam("name")String name,@RequestParam("email")String email,
			@RequestParam("nickName")String nickName, @RequestParam("userId")String userId,@RequestParam("password")String password,
			@RequestParam(value = "profile", required = false)MultipartFile profile,BlogUserVO userVo){
		Map<String,Object> response=new HashMap<>();
		try {
			String uploadDir="C:/Users/미냠/Downloads/final/fusion-reference/src/main/webapp/images/egovframework/profile/";

			String filePath="";
			if(profile!=null  && !profile.isEmpty()) {
				String uuid=UUID.randomUUID().toString();
				String fileName=uuid+"_"+profile.getOriginalFilename();
				File dest = new File(uploadDir+fileName);
				
				profile.transferTo(dest);
				filePath="/images/egovframework/profile/" + fileName;
			}
			
			userVo.setUserName(name);
			userVo.setUserId(userId);
			userVo.setPassword(password);
			userVo.setNickName(nickName);
			userVo.setUserAccessRight("normal");
			userVo.setProfileImage(filePath);
			
			userService.join(userVo);
			
	        response.put("status", "success");
	        response.put("message", "회원가입 성공");
	        response.put("filePath", filePath); // **파일이 저장된 경로 반환**
			
			return response;
		} catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "파일 업로드 중 오류 발생");
	        return response;
		}
	}
	
	@PostMapping(value="/blog/login.do")
	public String login(BlogUserVO userVo,HttpSession session,Model model) {
		
		 try {
		        // 서비스에서 로그인 처리
		        BlogUserVO user = userService.login(userVo);
		        
		        if (user != null) {
		            // 로그인 성공: 세션에 사용자 정보 저장
		            session.setAttribute("loggedInUser", user); // 세션에 사용자 객체 저장
		            session.setAttribute("userId", user.getUserId());
		            session.setAttribute("accessRight",user.getUserAccessRight());
		            System.out.println("user access:"+user.getUserAccessRight());
					/*
					 * return "redirect:/gallery/galleryList.do"; // 로그인 후 게시판으로 이동
					 */
		            return "redirect:/blog/mainPage.do";
		        } else {
		            // 로그인 실패: 에러 메시지 전달
		            model.addAttribute("errorMessage", "로그인 정보가 올바르지 않습니다.");
		            return "tiles/blog/loginPage"; // 로그인 화면으로 다시 이동
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        model.addAttribute("errorMessage", "시스템 오류가 발생했습니다.");
		        return "tiles/blog/loginPage"; // 에러 발생 시 로그인 화면으로 이동
		    }
	}
	
	@GetMapping(value="/blog/logout.do")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/blog/mainPage.do";
	}
	
	
}
