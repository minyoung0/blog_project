package egovframework.fusion.sns.filter;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.SubCodeVO;
import egovframework.fusion.sns.service.SnsService;

@WebFilter(urlPatterns = "/sns/getBoardList.do")
public class BadWordFilter implements Filter {
	@Autowired
	MainService mainService;
	@Autowired
	SnsService snsService;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		System.out.println("[필터] init 작동");

		
		try {
		    Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 드라이버 로드
		    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?serverTimezone=UTC&useSSL=false", "root","mysql001");
		    System.out.println("✅ MySQL 연결 성공!");
		} catch (ClassNotFoundException e) {
		    System.out.println("❌ MySQL 드라이버 로드 실패!");
		    e.printStackTrace();
		} catch (SQLException e) {
		    System.out.println("❌ MySQL 연결 실패!");
		    e.printStackTrace();
		}
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		System.out.println("[필터] doFilter 작동");

		// http기반(세션관리 등등) 요청 수행하기에는 HttpServletRequest로 변환 필요
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		// 변수
		String page = httpRequest.getParameter("page");
		String size = httpRequest.getParameter("size");
		String searchType = request.getParameter("searchType");
		String keyword = request.getParameter("keyword");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		System.out.println("시작일:" + startDate + "종료일:" + endDate);

		SimpleDateFormat date = new SimpleDateFormat("yyyy-mm-dd");
		date.setTimeZone(TimeZone.getTimeZone("UTC"));
		try {
			if (!startDate.equals("") ||!endDate.equals("")) {
				Date start = date.parse(startDate);
				Date end = date.parse(endDate);

				if (start.after(end)) {
					httpResponse.setContentType("text/plain");
					httpResponse.setCharacterEncoding("utf-8");
					httpResponse.setStatus(httpResponse.SC_BAD_REQUEST);
					httpResponse.getWriter().write("시작날짜와 종료날짜가 올바르지않습니다");
					return;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// 사용자정보
		HttpSession session = httpRequest.getSession();
		String userId = (String) session.getAttribute("userId");

		String userAccess = "";

		if (userId == null || !userAccess.isEmpty()) {
			userAccess = "guest";
		} else {
			userAccess = snsService.getUserAccessRight(userId);
		}

		httpRequest.setAttribute("userAccess", userAccess);

		System.out.println("[필터]권한:" + userAccess);
		System.out.println("[필터]:사용자아이디" + userId);
		System.out.println("[필터]: page=" + page + ", size=" + size);
		System.out.println("[검색]: type=" + searchType + ", keyword=" + keyword);

		if (userId == null) {
			userId = "guest";
		}

		// 날짜 예외처리
		if (searchType == null) {
			searchType = "";
		}
		if(keyword==null) {
			keyword="";
		}

		int pageNum = Integer.parseInt(page);
		int pageSize = Integer.parseInt(size);
		System.out.println("!!!!!!!!!"+searchType.getClass());
		
		//게시물, 검색 리스트 가져오기
		List<BoardVO> boardList;
		if (!searchType.equals("1") && !searchType.isEmpty()) {
			boardList = snsService.searchResultList(searchType, keyword, startDate, endDate, pageNum, pageSize);
		} else {
			boardList = snsService.getBoardList(pageNum, pageSize);
		}

		// DB에 Main_Code_Id=C 인 code name list 가져오기 현재 C 비속어 대분류 코드
		String codeName = "C";
		List<Map<String, String>> badWordsList = new ArrayList<>();
		badWordsList = mainService.getBadWordsList(codeName);

		// 비속어 List
		List<String> badWords = new ArrayList<>();
		System.out.println("비속어 리스트: " + badWords);

		for (Map<String, String> value : badWordsList) {
			badWords.addAll(value.values());
			System.out.println(value);
		}

		// 글 정보, 파일 정보 담을 배열
		List<Map<String, Object>> responseList = new ArrayList<>();

		// 작성한 글 내용 가져오기
		for (BoardVO board : boardList) {
			Map<String, Object> post = new HashMap<>();
			if (board.getBoardTitle() != null) {
				board.setBoardTitle(maskContent(board.getBoardTitle(), badWords));
				System.out.println("마스킹된 타이틀:" + board.getBoardTitle());
			}
			if (board.getBoardContent() != null) {
				board.setBoardContent(maskContent(board.getBoardContent(), badWords));
				System.out.println("마스킹된 내용:" + board.getBoardContent());
			}
			// Integer에는 null가능
			String boardUserId = board.getUserId();
			Integer relationStatus = snsService.getFollowStatus(boardUserId, userId);

			// 작성자와 사용자가 같거나 게스트일때 아예 팔로우 버튼 안띄울 임의 숫자 지정
			if (board.getUserId().equals(userId) || userId.equals("guest")) {
				relationStatus = 3;
			}

			int status = (relationStatus == null) ? 0 : relationStatus;

			System.out.println("게시글 제목:" + board.getBoardTitle());
			System.out.println("작성자와 사용자의 관계" + status);

			post.put("title", board.getBoardTitle());
			post.put("content", board.getBoardContent());
			post.put("user", board.getUserId());
			post.put("boardId", board.getBoardId());
			post.put("scrapOriginalUser", board.getScrapFromUserId());
			post.put("writeDate", board.getBoardRegistDatetime());
			post.put("followStatus", status);

			// 파일 목록 추가
			List<FileVO> files = snsService.getFilesByBoardId(board.getBoardId());
			List<Map<String, Object>> fileList = new ArrayList<>();
			for (FileVO file : files) {
				fileList.add(Map.of("originalName", file.getOriginalName(), "filePath", file.getFilePath()));
			}
			post.put("files", fileList);

			post.put("accessRight", userAccess);
			responseList.add(post);
		}

		// object 형태 responseList -> json형태로 바꿔서 전달
		ObjectMapper objectMapper = new ObjectMapper();
		String maskedReponse = objectMapper.writeValueAsString(responseList);

		response.setCharacterEncoding("UTF-8");

		// response 응답 내보내기
		response.getWriter().write(maskedReponse);

		/* chain.doFilter(request, response); */

	}

	// 비속어 마스킹
	public String maskContent(String text, List<String> badWordsList) {
		for (String badWord : badWordsList) {
			String masking = "*".repeat(badWord.length());
			// ?i ==> 대소문자 무시 + Patter.quote(badWord) :badword 대소문자를 무시한 badWord를 포함한 문자들을
			// 마스킹처리
			text = text.replaceAll("(?i)" + Pattern.quote(badWord), masking);
		}

		text = maskPersonal(text);

		return text;
	}

	// 개인정보 마스킹
	public String maskPersonal(String text) {

		// 이메일 패턴
		String emailPattern = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}";
		text = text.replaceAll(emailPattern, "******@***.***");

		// 전화번호 하이픈 x
		String phonePattern = "\\b(\\d{2,3}[-.]?\\d{3,4}[-.]?\\d{4})\\b";
		text = text.replaceAll(phonePattern, "***********");

		// 전화번호 하이픈 O
		String phonePattern2 = "(\\d{3})-(\\d{4})-(\\d{4})";
		text = text.replaceAll(phonePattern2, "***-****-****");

		// 주민등록번호
		String ssnPattern = "\\d{2}([0]\\d|[1][0-2])([0][1-9]|[1-2]\\d|[3][0-1])[-]*[1-4]\\d{6}";
		text = text.replaceAll(ssnPattern, "******-*******");

		return text;
	}

	@Override
	public void destroy() {
		System.out.println("[필터] destroy 작동");

	}

}
