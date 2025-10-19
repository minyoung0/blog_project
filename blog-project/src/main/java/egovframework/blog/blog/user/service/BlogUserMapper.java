package egovframework.fusion.blog.user.service;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.blog.user.vo.BlogUserVO;

@Mapper
public interface BlogUserMapper {

	public int idCheck(@Param("id")String id);
	
	public int nickNameCheck(@Param("nickName")String nickName);
	
	public void join(BlogUserVO userVo);
	
	public BlogUserVO login(BlogUserVO userVo);
	
	public BlogUserVO getUserInfo(@Param("userId") String userId);
}
