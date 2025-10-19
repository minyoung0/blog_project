package egovframework.fusion.user.service;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.user.vo.UserVO;

@Mapper
public interface UserMapper{
	
//	public List<UserVO> getUserList (UserVO userVo);
	
	public void insUser(UserVO userVo);
	
	public UserVO login(UserVO userVo);
	
	UserVO getUserById(String userId);
}