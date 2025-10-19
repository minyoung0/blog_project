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

import egovframework.fusion.blog.myPage.service.MyPageService;
import egovframework.fusion.blog.myPage.vo.BlogCategoryVO;
import egovframework.fusion.blog.user.service.BlogUserService;

@Controller
@RequestMapping("/blog/setting")
public class SettingController {
	
	@Autowired
	BlogUserService userService;
	
	@Autowired
	MyPageService myPageService;

	//카테고리 페이지
	@GetMapping(value="/category.do")
	public String categoryPage(HttpSession session,Model model) {
		String userId=(String)session.getAttribute("userId");
		List<BlogCategoryVO> categoryList = myPageService.getCategory(userId);
		
		
		model.addAttribute("categoryList",categoryList);
		return "views/blog/myPage/setting/category";
	}
	
	@PostMapping(value="/addCategory.do")
	@ResponseBody
	public Map<String, Object> addCategory(HttpSession session,@RequestParam("categoryName") String categoryName,@RequestParam("visibility")String visibility){
		Map<String,Object> response= new HashMap<>();
		try {
			String userId=(String)session.getAttribute("userId");
			myPageService.addCategory(categoryName,visibility,userId);
			response.put("categoryName", categoryName);
			response.put("visibility",visibility);
			return response;
		} catch (Exception e) {
			return response;
		}
	}
	
	@GetMapping(value="/getCategoryDetail.do")
	@ResponseBody
	public Map<String, Object> CategoryDetail(HttpSession session,@RequestParam("categoryId") int categoryId){
		Map<String,Object> response= new HashMap<>();
		try {
			BlogCategoryVO categoryDetail=myPageService.getCategoryName(categoryId);
			response.put("categoryDetail", categoryDetail);		
			return response;
		} catch (Exception e) {
			return response;
		}
	}
	
	//-----------------------------------------------------------------------//
	
	//이웃관리
	
	@GetMapping(value="/neighbors.do")
	public String neighborsPage() {
	
		return "views/blog/myPage/setting/neighbors";
	}
	@GetMapping(value="/stats.do")
	public String statsPage() {
		return "views/blog/myPage/setting/stats";
	}
	@GetMapping(value="/userSetting.do")
	public String userSettingPage() {
		return "views/blog/myPage/setting/userSetting";
	}
}
