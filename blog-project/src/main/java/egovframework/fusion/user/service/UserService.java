package egovframework.fusion.user.service;

import java.util.DuplicateFormatFlagsException;
import java.util.List;

import egovframework.fusion.user.vo.UserVO;

public interface UserService{
	
//	public List<UserVO> getUserList(UserVO userVo);
	
	public void insUser(UserVO userVo);
	
	public UserVO login(UserVO userVo);
	

}