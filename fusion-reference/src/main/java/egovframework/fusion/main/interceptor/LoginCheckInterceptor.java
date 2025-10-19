package egovframework.fusion.main.interceptor;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.user.vo.UserVO;

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
		
		// 검색 권한 체크
		if (session.getAttribute("searchBoardAccessIds") == null || session.getAttribute("searchGalleryAccessIds")==null||session.getAttribute("searchSurveyAccessIds")==null) {
			List<Integer> searchBoardAccessIds = mainService.searchBoardMenuAccessList(userAccess);
			List<Integer> searchGalleryAccessIds = mainService.searchGalleryMenuAccessList(userAccess);
			List<Integer> searchSurveyAccessIds = mainService.searchSurveyMenuAccessList(userAccess);
		
			
			if(searchBoardAccessIds==null||searchBoardAccessIds.isEmpty()) {
				searchBoardAccessIds=new ArrayList<>();
				searchBoardAccessIds.add(0);
			}else if(searchGalleryAccessIds==null||searchGalleryAccessIds.isEmpty()) {
				searchGalleryAccessIds=new ArrayList<>();
				searchGalleryAccessIds.add(0);
			}else if(searchSurveyAccessIds==null||searchSurveyAccessIds.isEmpty()){
				searchSurveyAccessIds=new ArrayList<>();
				searchSurveyAccessIds.add(0);
			}
			System.out.println("[인터셉터]검색가능한 글게시판 메뉴 아이디: "+searchBoardAccessIds);
			System.out.println("[인터셉터]검색가능한 갤러리게시판 메뉴 아이디: "+searchGalleryAccessIds);
			System.out.println("[인터셉터]검색가능한 설문게시판 메뉴 아이디: "+searchSurveyAccessIds);
			session.setAttribute("searchBoardAccessIds", searchBoardAccessIds);
			session.setAttribute("searchGalleryAccessIds", searchGalleryAccessIds);
			session.setAttribute("searchSurveyAccessIds", searchSurveyAccessIds);
		}
		
		//검색 페이지 허용
		if ("/main/search.do".equals(menuUrl)) {
			System.out.println("[인터셉터] 검색페이지 허용");
			return true;
		}


		// **1. 메뉴 호출 시 처리**
		if (menuId > 0) {
			// DB에서 menuId로 메뉴 권한 가져오기
			String menuAccessRightById = mainService.getMenuAccessRightById(menuId);
			System.out.println("menuAccessRightById 권한: " + menuAccessRightById);

			// 권한 검증
			if (menuAccessRightById == null || !isAuthorized(userAccess, menuAccessRightById)) {
				response.sendRedirect("/accessDenied.do"); // 권한 없음
				return false;
			}

			// 세션에 baseUrl과 권한 저장
			session.setAttribute("current_baseUrl", baseUrl);
			session.setAttribute("current_menuAccessRight", menuAccessRightById);

			return true; // 요청 허용
		}

		System.out.println("Request:" + realUrl);
		System.out.println("권한:" + userAccess);

		// 메뉴 권한

		/* String menuAccessRight = mainService.getMenuAccessRightByUrl(menuUrl); */
		String menuAccessRightById = mainService.getMenuAccessRightById(menuId);
		System.out.println("메뉴권한:" + menuAccessRightById);

		if (menuId == 0) {
			// **2. 부가기능 요청 시 처리**
			if (baseUrl.equals(sessionBaseUrl)) {
				return true; // 요청 허용
			}

		}
		


		// **3. 권한 없음 또는 잘못된 요청**
		response.sendRedirect("/accessDenied.do");
		return false;

	}

	// 권한 검증
	private boolean isAuthorized(String userAccess, String menuAccessRight) {
		List<String> roleList = List.of("guest", "normal", "admin", "superAdmin");

		int userRoleIndex = roleList.indexOf(userAccess);
		int menuRoleIndex = roleList.indexOf(menuAccessRight);

		System.out.println("userRoleIndex: " + userRoleIndex);
		System.out.println("menuRoleIndex: " + menuRoleIndex);

		// 사용자 권한이 메뉴 권한 이상인지 확인
		return userRoleIndex >= menuRoleIndex;
	}

}