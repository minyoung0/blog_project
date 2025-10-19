package egovframework.fusion.aop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.springframework.beans.factory.annotation.Autowired;

import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuLogVO;

public class ControlAdvice {

	@Autowired
	MainService mainService;

	public void printLog() {
		System.out.println("[공통로그 - ControlAdvice] 비즈니스 로직 수행 전 동작!!!!!!!!!");
	}
}
