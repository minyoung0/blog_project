package egovframework.fusion.main.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.main.vo.MainCodeVO;
import egovframework.fusion.main.vo.MenuLogVO;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.main.vo.SubCodeVO;
import egovframework.fusion.user.vo.UserVO;

@Mapper
public interface MainMapper {
	public List<MenuVO> getMenuList(MenuVO menuVO);

	public List<MenuVO> getMenuListModel();

	public List<MenuVO> getAllMenuList(MenuVO menuVO);

	public void addMenu(Map<String, Object> menuData);

	public void menuModify(Map<String, Object> menuData);

	public void checkDelMenu(List<Integer> menuIds);

	public int getTotalMenuCount(MenuVO menuVO);

	/* public String getMenuAccessRight(MenuVO menuVO); */
	public String getMenuAccessRight(int menuId);

	public String getMenuAccessRightByUrl(String menuUrl);

	public String getMenuAccessRightById(int menuId);

	public void saveAccessLog(MenuLogVO menuLogVo);

	public List<MenuVO> getAllMenuListWithNoPaging();

	
	//통계
	public List<HashMap<String, Object>> getMonthlyDataByYear(@Param("year") int year);

	public List<HashMap<String, Object>> recentThreeYear(@Param("thisYear") int thisYear,
			@Param("thisYearMOne") int thisYearMOne, @Param("thisYearMTwo") int thisYearMTwo);

	public List<HashMap<String, Object>> getDailyData(@Param("year") int year, @Param("month") int month);

	public List<HashMap<String, Object>> getTimeData(@Param("year") int year, @Param("month") int month,
			@Param("day") int day);

	public List<HashMap<String, Object>> getDuplTimeData(@Param("year") int year, @Param("month") int month,
			@Param("day") int day);

	public MenuVO getMenuDetail(MenuVO menuVO);

	public void deleteMenu(@Param("menuId") int menuId);

	
	//검색
	public List<Integer> searchBoardMenuAccessList(@Param("userAccess") String userAccess);

	public List<Integer> searchGalleryMenuAccessList(@Param("userAccess") String userAccess);

	public List<Integer> searchSurveyMenuAccessList(@Param("userAccess") String userAccess);
	
	//코드관리
	public List<MainCodeVO> getMainCodeList(MainCodeVO mainCodeVO);
	
	public List<SubCodeVO> getSubCodeList(SubCodeVO subCodeVO);

	
	//대문항 코드 가져오기
	public List<String> getMainCodeIdsList(MainCodeVO mainCodeVO);
	
	
	//새로운 대문항 공통코드 
	public void insNewMainCode(MainCodeVO mainCodeVO);
	
	//대문항 수정-정보가져오기
	public MainCodeVO getMenuDetailById(@Param("codeId")String codeId);
	
	//대문항 수정
	public void updNewMainCode(MainCodeVO mainCodeVO);
	
	public void updSubCodeWithMainCode(@Param("mainCodeId")String mainCodeId,@Param("deleteYn2")int deleteYn2);
	
	//대문항 코드당 소문항 코드 수
	public int cntSubCode(@Param("id")String id);
	
	//대문항 삭제
	public void checkDelMainCode(@Param("id") String id);
	
	//소문항 코드 가져오기
	public List<Integer> getSubCodeIdsList(@Param("mainCodeId") String mainCodeId);
	
	
	//새로운 소문항 공통코드 
	public void insNewSubCode(SubCodeVO subCodeVO);
	
	//소문항 수정- 정보가져오기
	public SubCodeVO getSubMenuDetailById(@Param("codeId") String codeId, @Param("subCodeId")int subCodeId);
	
	//소문항 수정
	public void updNewSubCode(SubCodeVO subCodeVo);
	
	public void checkDelSubCode(List<Integer> subCodeIds);
	
	public List<Map<String,String>> getBadWordsList(@Param("codeName")String codeName);
	
	public List<MainCodeVO> searchMainCode(@Param("searchType")String searchType,@Param("keyword")String keyword);
	
	//관리자 리스트 가져오기
	public List<UserVO> getAdminList();
}