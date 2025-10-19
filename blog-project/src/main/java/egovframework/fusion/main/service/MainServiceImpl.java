package egovframework.fusion.main.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import egovframework.fusion.main.vo.MainCodeVO;
import egovframework.fusion.main.vo.MenuLogVO;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.main.vo.SubCodeVO;
import egovframework.fusion.user.vo.UserVO;

@Service
public class MainServiceImpl extends EgovAbstractServiceImpl implements MainService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MainServiceImpl.class);

	@Autowired
	MainMapper mainMapper;

	@Override
	public List<MenuVO> getMenuList(MenuVO menuVO) {
		return mainMapper.getMenuList(menuVO);
	}

	@Override
	public List<MenuVO> getMenuListModel() {
		return mainMapper.getMenuListModel();
	}

	@Override
	public List<MenuVO> getAllMenuList(MenuVO menuVO) {
		return mainMapper.getAllMenuList(menuVO);
	}

	@Override
	public void addMenu(Map<String, Object> menuData) {
		mainMapper.addMenu(menuData);
	}

	@Override
	public void menuModify(Map<String, Object> menuData) {
		mainMapper.menuModify(menuData);
	}

	@Override
	public void checkDelMenu(List<Integer> menuIds) {
		mainMapper.checkDelMenu(menuIds);
	}

	@Override
	public int getTotalMenuCount(MenuVO menuVO) {
		return mainMapper.getTotalMenuCount(menuVO);
	}

	/*
	 * @Override public String getMenuAccessRight(MenuVO menuVO) { return
	 * mainMapper.getMenuAccessRight(menuVO); }
	 */

	@Override
	public String getMenuAccessRight(int menuId) {
		return mainMapper.getMenuAccessRight(menuId);
	}

	@Override
	public String getMenuAccessRightByUrl(String menuUrl) {
		return mainMapper.getMenuAccessRightByUrl(menuUrl);
	}

	@Override
	public String getMenuAccessRightById(int menuId) {
		return mainMapper.getMenuAccessRightById(menuId);
	}

	@Override
	public void saveAccessLog(MenuLogVO menuLogVo) {
		mainMapper.saveAccessLog(menuLogVo);
	}

	@Override
	public List<MenuVO> getAllMenuListWithNoPaging() {
		return mainMapper.getAllMenuListWithNoPaging();
	}

	// 통계
	@Override
	public List<HashMap<String, Object>> getMonthlyDataByYear(int year) {
		return mainMapper.getMonthlyDataByYear(year);
	}

	@Override
	public List<HashMap<String, Object>> recentThreeYear(int thisYear, int thisYearMOne, int thisYearMTwo) {
		return mainMapper.recentThreeYear(thisYear, thisYearMOne, thisYearMTwo);
	}

	@Override
	public List<HashMap<String, Object>> getDailyData(int year, int month) {
		System.out.println("년도: "+year);
		System.out.println("월: "+month);
		return mainMapper.getDailyData(year, month);
	}

	@Override
	public List<HashMap<String, Object>> getTimeData(int year, int month, int day, int removeDuplicate) {
		if (removeDuplicate == 1) {
			return mainMapper.getDuplTimeData(year, month, day);
		} else {
			return mainMapper.getTimeData(year, month, day);
		}

	}

	@Override
	public MenuVO getMenuDetail(MenuVO menuVO) {
		return mainMapper.getMenuDetail(menuVO);
	}

	@Override
	public void deleteMenu(int menuId) {
		mainMapper.deleteMenu(menuId);
	}

	// 검색
	@Override
	public List<Integer> searchBoardMenuAccessList(String userAccess) {
		return mainMapper.searchBoardMenuAccessList(userAccess);
	}

	@Override
	public List<Integer> searchGalleryMenuAccessList(String userAccess) {
		return mainMapper.searchGalleryMenuAccessList(userAccess);
	}

	@Override
	public List<Integer> searchSurveyMenuAccessList(String userAccess) {
		return mainMapper.searchSurveyMenuAccessList(userAccess);
	}

	// 코드관리
	@Override
	public List<MainCodeVO> getMainCodeList(MainCodeVO mainCodeVO) {
		return mainMapper.getMainCodeList(mainCodeVO);
	}

	@Override
	public List<SubCodeVO> getSubCodeList(SubCodeVO subCodeVO) {
		return mainMapper.getSubCodeList(subCodeVO);
	}

	// 대문항 공통코드 가져오기
	@Override
	public List<String> getMainCodeIdsList(MainCodeVO mainCodeVO) {
		return mainMapper.getMainCodeIdsList(mainCodeVO);
	}

	// 새로운 대문항 공통코드 추가
	@Override
	public void insNewMainCode(MainCodeVO mainCodeVO) {
		mainMapper.insNewMainCode(mainCodeVO);
	}

	// 대분류 코드 수정 정보가져오기- by Id
	@Override
	public MainCodeVO getMenuDetailById(String codeId) {
		return mainMapper.getMenuDetailById(codeId);
	}
	
	//대분류 코드 수정
	@Override
	public void updNewMainCode(MainCodeVO mainCodeVO) {
		mainMapper.updNewMainCode(mainCodeVO);
	}
	
	@Override
	public void updSubCodeWithMainCode(String mainCodeId,int deleteYn2) {
		mainMapper.updSubCodeWithMainCode(mainCodeId,deleteYn2);
	}
	
	//대분류 코드 당 소분류 코드 수 
	@Override
	public int cntSubCode(String id) {
		return mainMapper.cntSubCode(id);
	}
	
	//대문항 삭제
	@Override
	public void checkDelMainCode(String id) {
		System.out.println("삭제 서비스 작동");
		mainMapper.checkDelMainCode(id);
		System.out.println("삭제 서비스 완료");
	}

	// 소문항 공통코드 가져오기

	@Override
	public List<Integer> getSubCodeIdsList(String mainCodeId) {
		return mainMapper.getSubCodeIdsList(mainCodeId);
	}

	// 새로운 소문항 공통코드 추가
	@Override
	public void insNewSubCode(SubCodeVO subCodeVO) {
		mainMapper.insNewSubCode(subCodeVO);
	}
	
	//소문항 수정- 정보가져오기
	@Override
	public SubCodeVO getSubMenuDetailById(String codeId, int subCodeId) {
		return mainMapper.getSubMenuDetailById(codeId,subCodeId);
	}

	//소문항 수정
	@Override
	public void updNewSubCode(SubCodeVO subCodeVO) {
		mainMapper.updNewSubCode(subCodeVO);
	}
	
	//소문항 삭제
	@Override
	public void checkDelSubCode(List<Integer> subCodeIds) {
		mainMapper.checkDelSubCode(subCodeIds);
	}
	
	@Override
	public List<Map<String,String>> getBadWordsList(String codeName){
		return mainMapper.getBadWordsList(codeName);
	}
	
	@Override
	public List<MainCodeVO> searchMainCode(String searchType,String keyword){
		return mainMapper.searchMainCode(searchType,keyword);
	}
	
	
	//관리자 리스트 가져오기
	@Override
	public List<UserVO> getAdminList(){
		return mainMapper.getAdminList();
	}
}
