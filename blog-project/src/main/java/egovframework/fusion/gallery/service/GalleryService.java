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

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.gallery.vo.GalleryVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;

public interface GalleryService {

	public List<GalleryVO> getGalleryList(GalleryVO galleryVO);

	// 게시글 저장
	public void insGalleryPost(GalleryVO galleryVO);

	// 파일 저장
	public void saveFiles(List<FileVO> fileList);

	// 태그 저장
	public void saveTags(List<TagVO> tagList);

	public void savePost(GalleryVO galleryVO, List<FileVO> fileVOList, List<TagVO> tagVOList);

	public List<FileVO> getFilesByBoardId(int boardId);

	public int getTotalCount(BoardVO boardVO);

	public GalleryVO getGalleryById(int boardId);

	public void DeletePost(int boardId);

	public List<TagVO> getTagsByBoardId(int boardId);

	public List<GalleryVO> getPostsByTag(String tagName);

	public List<GalleryVO> searchGallery(GalleryVO galleryVO);

	public List<GalleryVO> searchGallery2(String searchType, String keyword);

	public List<GalleryVO> searchGallery2(String searchType, String keyword, List<Integer> searchGalleryIdList);

	public int getSearchResultCount(GalleryVO galleryVO);

	// 다운로드 수 체크
	public int incrementDownloadCount(int fileId);

	public String getThumbnailByBoardId(int boardId);

	public boolean increaseViewCount(int boardId, String userId);

	// 좋아요
	public int toggleLike(LikeVO likeVO);

	// 수정 - 파일 삭제
	public void markFileAsDeleted(int fileId);

	public void deleteFiles(List<Long> fileIds);

	// 수정 - 파일 추가
	public void addFiles(List<FileVO> fileVOList);

	// 수정 - 게시글 수정
	public void updGalleryPost(GalleryVO galleryVO);

	/* public boolean checkUserLiked(int boardId, String loggedInUserId); */
}
