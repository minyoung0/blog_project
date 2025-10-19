import org.springframework.stereotype.Component;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;

@Component

public class RoleBasedInterceptor implements HandlerInterceptor {

	private final MainService mainService; // Service를 통해 DB에서 권한 조회

	public RoleBasedInterceptor(MainService mainService) {

		this.mainService = mainService;

	}
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	    HttpSession session = request.getSession();

	    // 세션에서 사용자 권한 가져오기
	    Object userAccess = session.getAttribute("accessRight");
	    if (userAccess == null) {
	        response.sendRedirect("/accessDenied.do"); // 사용자 권한 없음
	        return false;
	    }

	    // 요청 URL 및 baseUrl 추출
	    String menuUrl = request.getRequestURI(); // 예: /board/boardList.do
	    String[] urlParts = menuUrl.split("/");
	    String baseUrl = (urlParts.length > 1) ? urlParts[1] : ""; // 첫 번째 경로 추출

	    // 세션에서 현재 baseUrl 및 메뉴 권한 가져오기
	    String sessionBaseUrl = (String) session.getAttribute("current_baseUrl");
	    String sessionMenuAccessRight = (String) session.getAttribute("current_menuAccessRight");

	    // **1. 메뉴 호출 시 처리**
	    if (sessionBaseUrl == null || !baseUrl.equals(sessionBaseUrl)) {
	        // DB에서 메뉴 권한 가져오기
	        String menuAccessRight = mainService.getMenuAccessRightByUrl(menuUrl);
	        if (menuAccessRight == null || !isAuthorized(userAccess.toString(), menuAccessRight)) {
	            response.sendRedirect("/accessDenied.do"); // 권한 없음
	            return false;
	        }

	        // 세션에 baseUrl과 권한 저장
	        session.setAttribute("current_baseUrl", baseUrl);
	        session.setAttribute("current_menuAccessRight", menuAccessRight);

	        return true; // 메뉴 호출 요청 허용
	    }

	    // **2. 부가기능 요청 시 처리**
	    if (baseUrl.equals(sessionBaseUrl) && isAuthorized(userAccess.toString(), sessionMenuAccessRight)) {
	        return true; // 요청 허용
	    }

	    // **3. 권한 없음 또는 잘못된 요청**
	    response.sendRedirect("/accessDenied.do");
	    return false;
	}

	// 권한 검증 메서드
	private boolean isAuthorized(String userAccess, String menuAccessRight) {
	    List<String> rolesHierarchy = List.of("normal", "admin", "superadmin");
	    int userRoleIndex = rolesHierarchy.indexOf(userAccess);
	    int menuRoleIndex = rolesHierarchy.indexOf(menuAccessRight);

	    return userRoleIndex >= menuRoleIndex; // 사용자 권한이 메뉴 권한 이상인지 확인
	}
	


}
