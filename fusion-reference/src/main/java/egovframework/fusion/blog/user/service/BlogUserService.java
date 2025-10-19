package egovframework.fusion.blog.user.service;

import egovframework.fusion.blog.user.vo.BlogUserVO;

public interface BlogUserService {
	
	//아이디 중복체크
	public int idCheck(String id);

	//닉네임 중복체크
	public int nickNameCheck(String nickName);
	
	//회원가입
	public void join(BlogUserVO userVo);
	
	//로그인
	public BlogUserVO login(BlogUserVO userVo);
}

