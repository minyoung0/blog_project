package egovframework.blog.main.interceptor;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import egovframework.blog.main.service.MainService;
import egovframework.blog.main.vo.MenuVO;
import egovframework.blog.user.vo.UserVO;

public class LoginCheckInterceptor implements HandlerInterceptor {

	@Autowired
	MainService mainService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();

		// 세션에서 사용자 권한 가져오기

		String blogUserId=(String)request.getParameter("blogUserId");
		
		if (blogUserId != null && !blogUserId.isEmpty()) {
            session.setAttribute("blogUserId", blogUserId); // ✅ 최신 블로그 주인 ID를 세션에 저장
        }
		System.out.println("인터셉터 userId "+blogUserId);
		
		Object userAccessObject = session.getAttribute("accessRight");
		

		// 접근 권한이 없는 사람
		if (userAccessObject == null) {
			userAccessObject = "guest";
			
		}
		
		String userAccess = userAccessObject.toString();
		session.setAttribute("accessRight", userAccessObject);
		System.out.println("[인터셉터] 사용자권한: " + userAccess);

		// 요청 url 추출하기
		String menuUrl = request.getRequestURI();
		String menuParameter = request.getQueryString();
		String realUrl = menuUrl + "?" + menuParameter;
		String[] urlParts = menuUrl.split("/");
		String baseUrl = (urlParts.length > 1) ? urlParts[1] : "";
		System.out.println("menuUrl:" + menuUrl + ",realUrl:" + realUrl + ",baseUrl:" + baseUrl);

		int menuId;
		String menuIdFromRequest = request.getParameter("menuId");
		
		if(menuUrl.startsWith("/blog/")||menuUrl.startsWith("/chatting/")||menuUrl.startsWith("/chat/")) {
			System.out.println("통과:"+menuUrl);
			return true;
		}
		if (menuIdFromRequest == null) {
			menuId = 0;
		} else {
			menuId = Integer.parseInt(menuIdFromRequest);
		}
		System.out.println("[인터셉터]메뉴아이디 파라미터:" + menuId);
		System.out.println("[인터셉터]첫번쨰:" + baseUrl);

		// 세션에서 현재 baseUrl 및 메뉴 권한 가져오기
		String sessionBaseUrl = (String) session.getAttribute("current_baseUrl");
		String sessionMenuAccessRight = (String) session.getAttribute("current_menuAccessRight");
		System.out.println("sessionBaseUrl:" + sessionBaseUrl);
		System.out.println("sessionManuAccessRight:" + sessionMenuAccessRight);
		
		session.removeAttribute("searchBoardAccessIds");
		
		//외부 url 체크
		if("/main/externalLog.do".equals(menuUrl)) {
			return true;
		}
	

}