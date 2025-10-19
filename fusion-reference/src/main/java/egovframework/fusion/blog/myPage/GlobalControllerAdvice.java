package egovframework.fusion.blog.myPage;

import java.time.LocalDate;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import egovframework.fusion.blog.myPage.service.MyPageService;
import egovframework.fusion.blog.myPage.vo.BlogCategoryVO;
import egovframework.fusion.blog.user.vo.BlogUserVO;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Autowired
    private MyPageService myPageService;

    @ModelAttribute("userInfo")
    public BlogUserVO getUserInfo(HttpSession session) {
        String blogUserId = (String) session.getAttribute("blogUserId"); // ✅ 세션에서 가져오기
        System.out.println("[ControllerAdvice] blogUserId: " + blogUserId);
        
        return (blogUserId != null) ? myPageService.getUserInfo(blogUserId) : null;
    }

    @ModelAttribute("category")
    public List<BlogCategoryVO> getCategoryList(HttpSession session) {
        String blogUserId = (String) session.getAttribute("blogUserId"); // ✅ 세션에서 가져오기
        return (blogUserId != null) ? myPageService.getCategory(blogUserId) : null;
    }
	/*
	 * @ModelAttribute("todayVisit") public int todayVisit(HttpSession session) {
	 * String blogUserId = (String) session.getAttribute("blogUserId");
	 * System.out.println("todayVIsit: "+blogUserId); LocalDate now=LocalDate.now();
	 * String today = now.toString(); return (blogUserId != null) ?
	 * myPageService.todayVisit(blogUserId,today) : 0; }
	 * 
	 * @ModelAttribute("totalVisit") public int totalVisit(HttpSession session) {
	 * String blogUserId = (String) session.getAttribute("blogUserId");
	 * System.out.println("totalVisit: "+blogUserId); return (blogUserId != null) ?
	 * myPageService.totalVisit(blogUserId) : 0; }
	 */
}
