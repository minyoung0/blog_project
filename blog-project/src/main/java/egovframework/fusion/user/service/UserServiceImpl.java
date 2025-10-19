package egovframework.fusion.user.service;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import egovframework.fusion.user.vo.UserVO;

@Service
public class UserServiceImpl extends EgovAbstractServiceImpl implements UserService{
	
	
	@Autowired
	UserMapper userMapper;
	
//	@Override
//	public List<UserVO> getUserList(UserVO userVo) {
//		return userMapper.getUserList(userVo);
//	}

	@Override
	public void insUser(UserVO userVo) {
		
		//비밀번호 확인 -> 두개 맞니?
		//계정에 중복 계정이 있니?
		//로직 구현~~~
		UserVO exstingUser	=userMapper.getUserById(userVo.getUserId());
		if(exstingUser !=null ) {
			throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
		}
		
		userMapper.insUser(userVo);
	}
	
	@Override
	public UserVO login(UserVO userVo) {
		return userMapper.login(userVo);
	}
	
}