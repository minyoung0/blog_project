package egovframework.fusion.main.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.management.RuntimeErrorException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import egovframework.fusion.board.service.BoardService;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.gallery.service.GalleryService;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.gallery.vo.GalleryVO;
import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MainCodeVO;
import egovframework.fusion.main.vo.MenuLogVO;
import egovframework.fusion.main.vo.MenuVO;
import egovframework.fusion.main.vo.SubCodeVO;
import egovframework.fusion.survey.service.SurveyService;
import egovframework.fusion.survey.vo.SurveyInfoVO;

@Controller
public class MainController {

	@Autowired
	MainService mainService;
	@Autowired
	BoardService boardService;
	@Autowired
	GalleryService galleryService;
	@Autowired
	SurveyService surveyService;

	@ModelAttribute("menuList")
	public List<MenuVO> menuList() {
		System.out.println(mainService.getMenuListModel());
		return mainService.getMenuListModel();
	}

	// 공통코드 페이지
	@RequestMapping(value = "/main/commonCode.do", method = RequestMethod.GET)
	public String cmmnCodeManagePage(Model model, MainCodeVO mainCodeVO, SubCodeVO subCodeVO) {
		List<MainCodeVO> mainCodeList = mainService.getMainCodeList(mainCodeVO);
		List<SubCodeVO> subCodeList = mainService.getSubCodeList(subCodeVO);

		model.addAttribute("mainCodeList", mainCodeList);
		model.addAttribute("subCodeList", subCodeList);

		return "tiles/main/cmmnCodeManagePage";
	}

	// 공통코드 페이지 -- 대분류 코드 추가페이지
	@RequestMapping(value = "/main/mainCodeAddPage.do", method = RequestMethod.GET)
	public String addMainCodePage(Model model, MainCodeVO mainCodeVO, SubCodeVO subCodeVO) {
		List<MainCodeVO> mainCodeList = mainService.getMainCodeList(mainCodeVO);
		model.addAttribute("mainCodeList", mainCodeList);

		return "views/main/mainCodeAddPage";
	}

	// 대문항 코드 추가
	@RequestMapping(value = "/main/addMainCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addMainCode(MainCodeVO mainCodeVO, @Param("mainCodeId") String mainCodeId,
			@Param("mainCodeName") String mainCodeName, @Param("mainCodeDescription") String mainCodeDescription,
			HttpSession session) {

		String userId = (String) session.getAttribute("userId");
		System.out.println("대분류 공통코드 생성자" + userId);

		System.out.println("코드아이디:" + mainCodeId + ",코드명:" + mainCodeName + "코드상세정보:" + mainCodeDescription);

		List<String> mainCodeIdsList = mainService.getMainCodeIdsList(mainCodeVO);
		Map<String, Object> response = new HashMap<>();
		try {

			if (mainCodeId.equals(mainCodeId.toLowerCase())) {
				response.put("false", false);
				response.put("message","대문항 코드 Id는 숫자만 허용됩니다");
				return response;
			}
			if (mainCodeIdsList.contains(mainCodeId)) {
				response.put("false", false);
				response.put("message","이미 존재하는 코드 ID입니다");
				return response;
			}

			mainCodeVO.setMainCodeId(mainCodeId);
			mainCodeVO.setMainCodeName(mainCodeName);
			mainCodeVO.setMainCodeDescription(mainCodeDescription);
			mainCodeVO.setUserId(userId);

			mainService.insNewMainCode(mainCodeVO);

			response.put("success", true);
			return response;

		}catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return response;
		}

	}

	// 대문항 코드 수정
	@RequestMapping(value = "/main/updMainCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updMainCode(MainCodeVO mainCodeVO, @Param("mainCodeId") String mainCodeId,
			@Param("mainCodeName") String mainCodeName, @Param("mainCodeDescription") String mainCodeDescription,
			HttpSession session,@Param("deleteYn")String deleteYn) {

		String userId = (String) session.getAttribute("userId");
		System.out.println("대분류 공통코드 생성자" + userId);
		
		int deleteYn2=Integer.parseInt(deleteYn);

		System.out.println("코드아이디:" + mainCodeId + ",코드명:" + mainCodeName + "코드상세정보:" + mainCodeDescription);

		List<String> mainCodeIdsList = mainService.getMainCodeIdsList(mainCodeVO);
		try {

			mainCodeVO.setMainCodeId(mainCodeId);
			mainCodeVO.setMainCodeName(mainCodeName);
			mainCodeVO.setMainCodeDescription(mainCodeDescription);
			mainCodeVO.setUserId(userId);
			mainCodeVO.setDeleteYn(deleteYn2);

			mainService.updNewMainCode(mainCodeVO);
			
			if(deleteYn2==1 ||deleteYn2==0) {
				mainService.updSubCodeWithMainCode(mainCodeId,deleteYn2);
			}

			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			return response;

		}catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return response;
		}

	}

	// 대문항 코드 수정 페이지
	@RequestMapping(value = "/main/updMainCodePage.do", method = RequestMethod.GET)
	public String updMainCodePage(HttpServletRequest request, Model model, MainCodeVO mainCodeVO) {
		String codeId = (String) request.getParameter("mainCodeId");
		System.out.println(codeId);
		try {
			List<MainCodeVO> mainCodeList = mainService.getMainCodeList(mainCodeVO);
			MainCodeVO codeDetail = mainService.getMenuDetailById(codeId);
			model.addAttribute("mainCodeList", mainCodeList);
			model.addAttribute("codeDetail", codeDetail);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "views/main/updMainCode";
	}

	// 대문항 삭제
	// 메뉴추가페이지 -- 체크항목 비활성화
	@RequestMapping(value = "/main/checkDelMainCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkDelMainCode(@RequestBody Map<String, Object> requestData) {

		List<String> mainCodeIds = (List<String>) requestData.get("mainCodeIds");
		Map<String, Object> response = new HashMap<>();
		System.out.println(mainCodeIds);
		try {
			for (String id : mainCodeIds) {
				System.out.println(id);
				int subCodeCount = mainService.cntSubCode(id);
				if (subCodeCount > 0) {
					response.put("success", false);
					response.put("message", "소문항이 존재하는 대문항이 있습니다. 확인 후 다시 시도해주십시오.");
					return response;
				}
			}

			for (String id : mainCodeIds) {
				System.out.println("삭제전");
				mainService.checkDelMainCode(id);
				System.out.println("삭제");
			}
			response.put("success", true);
			return response;

		} catch (

		Exception e) {
			e.printStackTrace();

			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return response;
		}

	}

	// 소문항 코드 추가
	@RequestMapping(value = "/main/addSubCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addSubCode(MainCodeVO mainCodeVO, SubCodeVO subCodeVO,
			@Param("mainCodeId") String mainCodeId, @Param("subCodeId") String subCodeId,
			@Param("mainCodeName") String mainCodeName, @Param("mainCodeDescription") String mainCodeDescription,
			HttpSession session) {

		String userId = (String) session.getAttribute("userId");
		System.out.println("소분류 공통코드 생성자" + userId);

		int IntegerSubCodeId = Integer.parseInt(subCodeId);

		System.out.println("코드아이디:" + mainCodeId + ",코드명:" + mainCodeName + "코드상세정보:" + mainCodeDescription);

		List<Integer> subCodeIdsList = mainService.getSubCodeIdsList(mainCodeId);
		List<String> mainCodeIdsList = mainService.getMainCodeIdsList(mainCodeVO);

		// 소문항 코드 아이디 숫자 정규식
		String regExp = "^[0-9]+$";
		Map<String, Object> response = new HashMap<>();
		try {
			// 소문항이 문자로 들어올때
			if (!subCodeId.matches(regExp)) {
				response.put("false", false);
				response.put("message","소문항 코드 Id는 숫자만 허용됩니다");
				return response;
			}
			// 소문항 코드가 이미 존재할때
			if (subCodeIdsList.contains(IntegerSubCodeId)) {
				response.put("false", false);
				response.put("message","이미 존재하는 소문항 코드Id입니다");
				return response;
			}

			// 대문항 코드를 소문자로 입력했을때
			/*
			 * if (mainCodeId.equals(mainCodeId.toLowerCase())) { response.put("false",
			 * false); response.put("message","대문항 코드 Id에 소문자는 허용되지 않습니다"); return response;
			 * }
			 */
			// 존재하지 않는 대문항코드에 소문항코드를 추가하려고할때
			if (!mainCodeIdsList.contains(mainCodeId)) {
				response.put("false", false);
				response.put("message","존재하지 않는 대문항 코드 ID입니다.");
				return response;
				
			}
			

			subCodeVO.setMainCodeId(mainCodeId);
			subCodeVO.setSubCodeId(IntegerSubCodeId);
			subCodeVO.setSubCodeName(mainCodeName);
			subCodeVO.setSubCodeDescription(mainCodeDescription);
			subCodeVO.setUserId(userId);

			mainService.insNewSubCode(subCodeVO);


			response.put("success", true);
			return response;

		}catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return response;
		}

	}

	// 공통코드 페이지 -- 소분류 코드 추가 페이지
	@RequestMapping(value = "/main/subCodeAddPage.do", method = RequestMethod.GET)
	public String addSubCodePage(Model model, MainCodeVO mainCodeVO, SubCodeVO subCodeVO) {
		List<MainCodeVO> mainCodeList = mainService.getMainCodeList(mainCodeVO);
		List<SubCodeVO> subCodeList = mainService.getSubCodeList(subCodeVO);

		model.addAttribute("mainCodeList", mainCodeList);
		model.addAttribute("subCodeList", subCodeList);
		return "views/main/subCodeAddPage";
	}

	// 소문항 코드 수정 페이지
	@RequestMapping(value = "/main/updSubCodePage.do", method = RequestMethod.GET)
	public String updSubCodePage(HttpServletRequest request, Model model, MainCodeVO mainCodeVO, SubCodeVO subCodeVO) {
		String codeId = (String) request.getParameter("mainCodeId");
		String subbbbCodeId = (String) request.getParameter("subCodeId");
		int subCodeId = Integer.parseInt(subbbbCodeId);
		System.out.println(codeId + "," + subCodeId);
		try {
			List<MainCodeVO> mainCodeList = mainService.getMainCodeList(mainCodeVO);
			List<SubCodeVO> subCodeList = mainService.getSubCodeList(subCodeVO);
			SubCodeVO subCodeDetail = mainService.getSubMenuDetailById(codeId, subCodeId);

			model.addAttribute("subCodeList", subCodeList);
			model.addAttribute("mainCodeList", mainCodeList);
			model.addAttribute("codeDetail", subCodeDetail);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "views/main/updSubCode";
	}

	// 소문항 수정
	@RequestMapping(value = "/main/updSubCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updSubsCode(SubCodeVO subCodeVO, @Param("mainCodeId") String mainCodeId,
			@Param("subCodeId") String subCodeId, @Param("subCodeName") String subCodeName,
			@Param("subCodeDescription") String subCodeDescription, HttpSession session,@Param("deleteYn")String deleteYn) {

		String userId = (String) session.getAttribute("userId");
		System.out.println("대분류 공통코드 생성자" + userId);
		
		int deleteYn2=Integer.parseInt(deleteYn);
		int subCodeIdd = Integer.parseInt(subCodeId);

		System.out.println("삭제여부:"+deleteYn2);
		System.out.println("코드명:" + subCodeName + "코드상세정보:" + subCodeDescription);

		/* List<String> mainCodeIdsList = mainService.getMainCodeIdsList(mainCodeVO); */
		try {

			subCodeVO.setSubCodeName(subCodeName);
			subCodeVO.setSubCodeDescription(subCodeDescription);
			subCodeVO.setUserId(userId);
			subCodeVO.setMainCodeId(mainCodeId);
			subCodeVO.setSubCodeId(subCodeIdd);
			subCodeVO.setDeleteYn(deleteYn2);

			mainService.updNewSubCode(subCodeVO);

			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			return response;

		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return response;
		}

	}

	// 소문항 삭제

	@RequestMapping(value = "/main/checkDelSubCode.do", method = RequestMethod.POST)
	public String checkDelSubCode(@RequestParam("subCodeIds") List<Integer> subCodeIds) {
		System.out.println("subCodeIds" + subCodeIds);

		try {
			mainService.checkDelSubCode(subCodeIds);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/main/commonCode.do";
	}
	
	//공통코드 검색
	@RequestMapping(value="/sns/MainCodesearch.do",method=RequestMethod.GET)
	public String searchMainCode(@RequestParam(value = "searchType", required = false) String searchType,
			@RequestParam(value = "keyword", required = false) String keyword, Model model,MainCodeVO mainCodeVO, SubCodeVO subCodeVO) {
		System.out.println("searchType: " + searchType);
		System.out.println("keyword: " + keyword);
		try {
			if (keyword == null || keyword.trim().isEmpty()) {
				// 검색어가 없을 경우 기본 리스트 반환
				return "redirect:/main/commonCode.do";
			}
			List<MainCodeVO> mainCodeList = mainService.getMainCodeList(mainCodeVO);
			List<SubCodeVO> subCodeList = mainService.getSubCodeList(subCodeVO);
			List<MainCodeVO> codeDetail = mainService.searchMainCode(searchType, keyword);
			
			for(MainCodeVO code:codeDetail) {
				System.out.println("mainCodeId:"+code.getMainCodeId());
			}
			model.addAttribute("mainCodeList", mainCodeList);
			model.addAttribute("subCodeList", subCodeList);
			model.addAttribute("codeDetail", codeDetail);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "tiles/main/cmmnCodeManagePage";
	}

	// 메인페이지
	@RequestMapping(value = "/main/main.do", method = RequestMethod.GET)
	public String mainPage(MenuVO menuVO, Model model) {
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "tiles/main/home";
	}

	// 메뉴관리 페이지
	@RequestMapping(value = "/main/menuManagement.do", method = RequestMethod.GET)
	public String menuMangagementPage(MenuVO menuVO, Model model,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "limit", required = false, defaultValue = "10") int limit) {

		int startRow = (page - 1) * limit;

		menuVO.setStartRow(startRow);
		menuVO.setLimit(limit);

		try {
			List<MenuVO> menuList = mainService.getMenuList(menuVO);
			List<MenuVO> menuAllList = mainService.getAllMenuList(menuVO);

			// 전체 게시물 수 가져오기
			int totalCount = mainService.getTotalMenuCount(menuVO);

			// 총 페이지 수 계산
			int totalPage = (int) Math.ceil((double) totalCount / limit);

			model.addAttribute("menuList", menuList);
			model.addAttribute("menuAllList", menuAllList);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("currentPage", page);
			model.addAttribute("selectedLimit", limit);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "tiles/main/menuManagement";
	}

	// 통계페이지
	@RequestMapping(value = "/main/accessStatistics.do", method = RequestMethod.GET)
	public String statisticsPage(MenuVO menuVO, Model model) {
		try {
			List<MenuVO> menuList = mainService.getMenuList(menuVO);
			model.addAttribute("menuList", menuList);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "tiles/main/accessStatistics";
	}

	// 메뉴추가페이지
	@RequestMapping(value = "/main/addMenuPage.do", method = RequestMethod.GET)
	public String addMenuPage(Model model, MenuVO menuVO) {
		try {
			List<MenuVO> menuList = mainService.getMenuList(menuVO);
			model.addAttribute("menuList", menuList);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "views/main/addMenu";
	}

	// 메뉴추가페이지--메뉴추가
	@RequestMapping(value = "/main/addMenu.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addmenu(@RequestBody Map<String, Object> menuData,HttpSession session) {
		String userId = (String)session.getAttribute("userId");
		String menuName = (String) menuData.get("menuName");
		String menuUrl = (String) menuData.get("menuUrl");
		int menutypeId = (Integer) menuData.get("boardtypeId");
		System.out.println("menuName:" + menuName + "menuUrl" + menuUrl + "menutypeId" + menutypeId);
		menuData.put("userId",userId);
		Map<String, Object> response = new HashMap<>();
		try {
			mainService.addMenu(menuData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return response;
	}

	// 메뉴삭제페이지 -- 체크항목 비활성화
	@RequestMapping(value = "/main/checkDelMenu.do", method = RequestMethod.POST)
	public String checkDelBoard(@RequestParam("menuIds") List<Integer> menuIds) {
		System.out.println("menuIds" + menuIds);
		try {
			mainService.checkDelMenu(menuIds);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/main/menuManagement.do";
	}

	// 권한 없음 페이지
	@RequestMapping(value = "/accessDenied.do", method = RequestMethod.GET)
	public String errorPage() {
		return "tiles/main/accessDenied";
	}

	// 전체 검색
	@RequestMapping(value = "/main/search.do", method = RequestMethod.GET)
	public String searchTotal(@RequestParam(value = "searchType") String searchType,
			@RequestParam(value = "keyword") String keyword, Model model, HttpServletRequest request,
			HttpSession session) {

		/*
		 * String RequestMenuId = request.getParameter("menuId"); int menuId =
		 * Integer.parseInt(RequestMenuId); System.out.println("boardPost menuId:" +
		 * RequestMenuId);
		 */
		try {
			if (keyword == null || keyword.trim().isEmpty()) {
				return "redirect:tiles/main/home";
			}

			List<Integer> searchBoardIdList = (List<Integer>) session.getAttribute("searchBoardAccessIds");
			List<Integer> searchGalleryIdList = (List<Integer>) session.getAttribute("searchGalleryAccessIds");
			List<Integer> searchSurveyIdList = (List<Integer>) session.getAttribute("searchSurveyAccessIds");
			System.out.println(
					"board:" + searchBoardIdList + ",gallery:" + searchGalleryIdList + ",survey:" + searchSurveyIdList);

			/*
			 * List<BoardVO> boardList = boardService.searchBoard(searchType, keyword);
			 * List<GalleryVO> galleryList2 = galleryService.searchGallery2(searchType,
			 * keyword); List<SurveyInfoVO> surveyList =
			 * surveyService.searchSurvey(searchType, keyword);
			 */

			List<BoardVO> boardList = boardService.searchBoard(searchType, keyword, searchBoardIdList);
			List<GalleryVO> galleryList2 = galleryService.searchGallery2(searchType, keyword, searchGalleryIdList);
			List<SurveyInfoVO> surveyList = surveyService.searchSurvey(searchType, keyword);

			model.addAttribute("boardList", boardList);
			model.addAttribute("galleryList", galleryList2);
			model.addAttribute("surveyList", surveyList);
			/* model.addAttribute("menuId",menuId); */
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "tiles/main/searchTotal";
	}

	// 메뉴 페이지--메뉴 상세보기
	@RequestMapping(value = "/main/menuDetail.do", method = RequestMethod.GET)
	public String menuDetail(MenuVO menuVO, Model model, HttpServletRequest request) {
		try {

			MenuVO menuDetail = mainService.getMenuDetail(menuVO);
			model.addAttribute("menuDetail", menuDetail);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "views/main/menuDetail";
	}

	// 메뉴 페이지 -- 메뉴수정페이지
	@RequestMapping(value = "/main/menuModifyPage.do", method = RequestMethod.GET)
	public String menuModify(MenuVO menuVO, Model model, HttpServletRequest request) {
		try {

			MenuVO menuDetail = mainService.getMenuDetail(menuVO);
			model.addAttribute("menuDetail", menuDetail);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "views/main/menuModifyPage";
	}

	// 메뉴 페이지--메뉴 수정페이지 --메뉴 수정
	@RequestMapping(value = "/main/menuModify2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> menuModify(@RequestBody Map<String, Object> menuData) {
		String menuName = (String) menuData.get("menuName");
		String menuId = (String) menuData.get("menuId");
		String deleteYn = (String) menuData.get("deleteYn");

		System.out.println("menuName:" + menuName + ",menuId:" + menuId + ",삭제여부:" + deleteYn);
		System.out.println(menuData);
		int realMenuId = Integer.parseInt(menuId);
		int realDeleteYn = Integer.parseInt(deleteYn);

		menuData.put("menuId", realMenuId);
		menuData.put("deleteYn", realDeleteYn);

		Map<String, Object> response = new HashMap<>();
		try {
			mainService.menuModify(menuData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return response;
	}

	// 메뉴 페이지 --메뉴 수정 페이지-- 메뉴 삭제
	@RequestMapping(value = "/main/deleteMenu.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMenu(@RequestParam("menuId") int menuId) {
		System.out.println("삭제할메뉴아이디:" + menuId);
		Map<String, Object> response = new HashMap<>();
		try {
			System.out.println(menuId);
			mainService.deleteMenu(menuId);
			response.put("status", "success");
			response.put("message", "메뉴가 정상적으로 삭제되었습니다");

		} catch (Exception e) {
			e.printStackTrace();
			response.put("status", "error");
			response.put("message", "메뉴삭제 도중 오류가 발생하였습니다");
		}

		return response;
	}

	// 외부 링크 로그 기록
	@RequestMapping(value = "/main/externalLog.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> logExternalAccess(@RequestParam int menuId, @RequestParam String menuUrl,
			HttpServletRequest request) {
		HttpSession session = request.getSession();
		Object userId = session.getAttribute("userId");

		if (userId == null) {
			userId = "guest";
		}

		// 로그 데이터 생성
		MenuLogVO logVO = new MenuLogVO();
		logVO.setUserId(userId.toString());
		logVO.setMenuId(menuId);
		logVO.setAccessDate(new java.sql.Date(System.currentTimeMillis()));

		// 로그 저장
		mainService.saveAccessLog(logVO);

		// 응답 데이터 구성
		Map<String, Object> response = new HashMap<>();
		response.put("success", true);
		response.put("message", "로그 저장 완료");

		return response;
	}
	
	


}