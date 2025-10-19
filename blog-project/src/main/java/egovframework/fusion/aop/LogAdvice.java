package egovframework.fusion.aop;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Before;

import egovframework.fusion.main.vo.MenuLogVO;
import egovframework.fusion.main.vo.MenuVO;

public class LogAdvice {
	public void printLog() {
		System.out.println("[공통로그 - LogAdvice] 비즈니스 로직 수행 전 동작");
	}
	
	public void printLogging() {
		System.out.println("[공통로그 - LogAdvice] 비즈니스 로직 수행 후 동작");
	}
	
	
}
