package egovframework.fusion.blog.user.service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.blog.user.vo.BlogUserVO;


@Service
public class BlogUserServiceImpl extends EgovAbstractServiceImpl implements BlogUserService{

	private static final Logger LOGGER = LoggerFactory.getLogger(BlogUserServiceImpl.class);
	
	@Autowired
	BlogUserMapper userMapper;
	
	@Override
	public int idCheck(String id) {
		return userMapper.idCheck(id);
	}
	
	@Override
	public int nickNameCheck(String nickName) {
		 return userMapper.nickNameCheck(nickName);
	}
	
	@Override
	public void join(BlogUserVO uservo) {
		userMapper.join(uservo);
	}
	
	@Override
	public BlogUserVO login(BlogUserVO userVo) {
		return userMapper.login(userVo);
	}
	
}
