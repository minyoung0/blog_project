package egovframework.fusion.main.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import egovframework.fusion.blog.myPage.vo.BlogLikeVO;
import egovframework.fusion.main.vo.MainCodeVO;
import egovframework.fusion.main.vo.MenuLogVO;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.main.vo.SubCodeVO;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.ResponseVO;
import egovframework.fusion.survey.vo.SurveyInfoVO;
import egovframework.fusion.user.vo.UserVO;

public interface MainService {

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

	public void saveAccessLog(MenuLogVO menulogVO);

	public List<MenuVO> getAllMenuListWithNoPaging();

	// 통계페이지
	public List<HashMap<String, Object>> recentThreeYear(int thisYear, int thisYearMOne, int thisYearMTwo);

	public List<HashMap<String, Object>> getMonthlyDataByYear(int year);

	public List<HashMap<String, Object>> getDailyData(int year, int month);

	public List<HashMap<String, Object>> getTimeData(int year, int month, int day, int removeDuplicate);

	public MenuVO getMenuDetail(MenuVO menuVO);

	public void deleteMenu(int menuId);

	public List<Integer> searchBoardMenuAccessList(String userAccess);

	public List<Integer> searchGalleryMenuAccessList(String userAccess);

	public List<Integer> searchSurveyMenuAccessList(String userAccess);

	// 코드관리 페이지
	public List<MainCodeVO> getMainCodeList(MainCodeVO mainCodeVO);

	public List<SubCodeVO> getSubCodeList(SubCodeVO subCodeVO);

	// 대분류 코드 정보 가져오기
	public List<String> getMainCodeIdsList(MainCodeVO mainCodeVO);

	// 대분류 코드 생성
	public void insNewMainCode(MainCodeVO mainCodeVO);

	// 대분류 코드 수정 정보 가져오기- by Id
	public MainCodeVO getMenuDetailById(String codeId);

	// 대분류 코드 수정
	public void updNewMainCode(MainCodeVO mainCodeVO);

	public void updSubCodeWithMainCode(String mainCodeId,int deleteYn2);
	
	// 대분류 코드 당 소분류 코드 수
	public int cntSubCode(String id);

	// 대분류 삭제
	public void checkDelMainCode(String id);

	// 소분류 코드 정보 가져오기
	public List<Integer> getSubCodeIdsList(String mainCodeId);

	// 소분류 코드 생성
	public void insNewSubCode(SubCodeVO subCodeVO);

	// 소문항 수정 -정보가져오기
	public SubCodeVO getSubMenuDetailById(String codeId, int subCodeId);

	// 소문항 코드 수정
	public void updNewSubCode(SubCodeVO subCodeVO);

	// 소문항 선택 삭제
	public void checkDelSubCode(List<Integer> subCodeIds);

	//Filter- 비속어 리스트 가져오기
	public List<Map<String,String>> getBadWordsList(String codeName);
	
	//코드 검색
	public List<MainCodeVO> searchMainCode(String searchType,String keyword);
	
	//관리자 리스트 가져오기
	public List<UserVO> getAdminList();
	


}