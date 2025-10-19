/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.gallery.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.gallery.vo.GalleryVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;
import egovframework.fusion.survey.vo.SurveyInfoVO;

@Mapper
public interface GalleryMapper {

	public List<GalleryVO> getGalleryList(GalleryVO galleryVO);

	public void insertGallery(GalleryVO galleryVO); // 게시글 저장

	public void insertTag(TagVO tagVO); // 태그 저장

	public void insertPost(GalleryVO galleryVO);

	public List<FileVO> getFilesByBoardId(int boardId);

	public int getTotalCount(BoardVO boardVO);

	GalleryVO getGalleryById(@Param("boardId") int boardId);

	public void deletePost(int boardId);

	public List<TagVO> getTagsByBoardId(int boardId);

	public List<GalleryVO> getPostsByTag(String tagName);

	public String getThumbnailByBoardId(@Param("boardId") int boardId);

	public List<GalleryVO> searchGallery(GalleryVO galleryVO);
	
	public List<GalleryVO> searchGallery2(@Param("searchType")String searchType, @Param("keyword")String keyword);
	
	public List<GalleryVO> searchGallery2(@Param("searchType")String searchType, @Param("keyword")String keyword,@Param("galleryMenuIds") List<Integer> searchGalleryIdList);

	public int getSearchResultCount(GalleryVO galleryVO);

	public int checkTodayViewHistory(@Param("boardId") int boardId, @Param("userId") String userId);

	public void insertViewHistory(@Param("boardId") int boardId, @Param("userId") String userId);

	public void updateViewCount(@Param("boardId") int boardId);

	// 다운로드 수 조회
	public int getDownloadCount(@Param("fileId") int fileId);

	public int incrementDownloadCount(@Param("fileId") int fileId);

	public int updateDownloadCount(@Param("fileId") int fileId);

	public void updateFileDeleteYn(@Param("fileId") int fileId);

	public void updGalleryPost(GalleryVO galleryVO);

	public void markFilesAsDeleted(@Param("fileIds") List<Long> fileIds);

	public void insertFile(FileVO fileVO);

	int checkLikeStatus(LikeVO likeVO); // 좋아요 여부 확인

	int checkExistingLike(LikeVO likeVO); // 기존 좋아요 데이터 존재 여부 확인

	void insertLike(LikeVO likeVO); // 좋아요 데이터 추가

	void updateLike(int boardId, String userId, int likeYn); // 좋아요 상태 업데이트

	int getLikeCount(int boardId); // 게시글 좋아요 개수 조회

	public SurveyInfoVO getSurveyById(int surveyId);
}
