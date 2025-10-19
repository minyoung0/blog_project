package egovframework.fusion.main.controller;

import java.time.LocalDate;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import egovframework.fusion.main.service.MainService;
import egovframework.fusion.main.vo.MenuLogVO;

@RestController
public class MenuStatisticsController {

	@Autowired
	MainService mainService;

	@RequestMapping(value = "/main/recentThreeYear.do", method = RequestMethod.GET)
	public Map<String, Object> recentThreeYear() {

		LocalDate now = LocalDate.now();

		int thisYear = now.getYear();
		int thisYearMOne = thisYear - 1;
		int thisYearMTwo = thisYear - 2;

		List<HashMap<String, Object>> result = mainService.recentThreeYear(thisYear, thisYearMOne, thisYearMTwo);
		System.out.println("반환데이터" + result);

		Map<String, Object> response = new HashMap<>();
		response.put("success", true);
		response.put("data", result);

		return response;
	}

	@RequestMapping(value = "/main/monthlyYearData.do", method = RequestMethod.GET)
	public Map<String, Object> getMonthlyDataByYear(@RequestParam int year) {
		System.out.println(year);
		List<HashMap<String, Object>> result = mainService.getMonthlyDataByYear(year);
		System.out.println("반환데이터" + result);

		Map<String, Object> response = new HashMap<>();
		response.put("success", true);
		response.put("data", result);

		return response;
	}

	@RequestMapping(value = "/main/DailyData.do", method = RequestMethod.GET)
	public Map<String, Object> getDailyData(@RequestParam int year, @RequestParam int month) {
		System.out.println(year);
		List<HashMap<String, Object>> result = mainService.getDailyData(year, month);
		System.out.println("반환데이터 데일리:" + result);

		Map<String, Object> response = new HashMap<>();
		response.put("success", true);
		response.put("data", result);

		return response;
	}

	@RequestMapping(value = "/main/TimeData.do", method = RequestMethod.GET)
	public Map<String, Object> getTimeData(@RequestParam int year, @RequestParam int month, @RequestParam int day, @RequestParam int removeDuplicate ) {
		System.out.println("중복제거여부:"+removeDuplicate);
		List<HashMap<String, Object>> result = mainService.getTimeData(year, month, day,removeDuplicate);
		System.out.println("반환데이터" + result);

		Map<String, Object> response = new HashMap<>();
		response.put("success", true);
		response.put("data", result);

		return response;
	}

}
