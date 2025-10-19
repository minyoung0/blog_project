package egovframework.fusion.aop;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuLogVO;
import egovframework.fusion.main.vo.MenuVO;

@Aspect
@Component
public class MenuAccessLog {
	@Autowired
	MainService mainService;

	@Autowired
	HttpServletRequest request;

	@Pointcut("execution(* egovframework.fusion..*Controller.*(..))&&!@annotation(org.springframework.web.bind.annotation.ModelAttribute)")
	private void publicTarget() {
	}

	@Before("publicTarget()")
	public void logMenuAccess(JoinPoint joinPoint) {
		System.out.println("[공통로그 - ControlAdvice] 비즈니스 로직 수행 전 동작!!!!!!!!!");

		String menuUrl = request.getRequestURI();
		String menuParameter = request.getQueryString();
		String realUrl = menuUrl + "?" + menuParameter;
		System.out.println("주소:" + realUrl);

		HttpSession session = request.getSession();
		Object userId = session.getAttribute("userId");

		if (userId == null) {
			userId = "null";
		}

		// DB에 있는 메뉴 리스트 불러오기
		List<MenuVO> menuList = mainService.getAllMenuListWithNoPaging();
		System.out.println("메뉴리스트"+menuList);

		for (MenuVO menu : menuList) {
			if (menu.getMenuUrl().equals(realUrl)) {
				String RequestMenuId = request.getParameter("menuId");
				int menuId = Integer.parseInt(RequestMenuId);
				System.out.println("menuId: " + menuId + ",userId:" + userId + ",menuUrl:" + realUrl);

			
					MenuLogVO log = new MenuLogVO();
					log.setUserId(userId.toString());
					log.setMenuId(menuId);
					log.setAccessDate(new java.sql.Date(System.currentTimeMillis()));

					// 서비스 호출로 데이터 저장
					mainService.saveAccessLog(log);
			}
		}
		System.out.println("aop실행:"+joinPoint.getSignature().getName());
	}

}
