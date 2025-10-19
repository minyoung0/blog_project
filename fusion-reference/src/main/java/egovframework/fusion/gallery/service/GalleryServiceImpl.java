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

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.board.service.BoardServiceImpl;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.gallery.vo.FileVO;
import egovframework.fusion.gallery.vo.GalleryVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;

@Service
public class GalleryServiceImpl extends EgovAbstractServiceImpl implements GalleryService {

	private static final Logger LOGGER = LoggerFactory.getLogger(GalleryServiceImpl.class);

	@Autowired
	GalleryMapper galleryMapper;

	@Override
	public List<GalleryVO> getGalleryList(GalleryVO galleryVO) {

		return galleryMapper.getGalleryList(galleryVO);
	}

	@Override
	public void insGalleryPost(GalleryVO galleryVO) {
		// 게시글 저장
		galleryMapper.insertGallery(galleryVO);
	}

	@Override
	public void saveFiles(List<FileVO> fileList) {
		// 파일 저장
		for (FileVO fileVO : fileList) {
			galleryMapper.insertFile(fileVO);
		}
	}

	@Override
	public void saveTags(List<TagVO> tagList) {
		// 태그 저장
		for (TagVO tagVO : tagList) {
			galleryMapper.insertTag(tagVO);
		}
	}

	@Override
	public void savePost(GalleryVO galleryVO, List<FileVO> fileVOList, List<TagVO> tagVOList) {

		// 게시글 저장
		galleryMapper.insertPost(galleryVO);

		// 파일정보 저장
		for (FileVO fileVO : fileVOList) {
			fileVO.setBoardId(galleryVO.getBoardId());
			galleryMapper.insertFile(fileVO);
		}

		// 태그 저장
		for (TagVO tagVO : tagVOList) {
			tagVO.setBoardId(galleryVO.getBoardId()); // 게시글 ID 설정
			galleryMapper.insertTag(tagVO);
		}
	}
	


	@Override
	public List<FileVO> getFilesByBoardId(int boardId) {

		return galleryMapper.getFilesByBoardId(boardId);
	}

	@Override
	public int getTotalCount(BoardVO boardVO) {
		return galleryMapper.getTotalCount(boardVO);
	}

	@Override
	public GalleryVO getGalleryById(int boardId) {
		return galleryMapper.getGalleryById(boardId);
	}

	@Override
	public void DeletePost(int boardId) {
		galleryMapper.deletePost(boardId);
	}

	@Override
	public List<TagVO> getTagsByBoardId(int boardId) {
		return galleryMapper.getTagsByBoardId(boardId);
	}

	@Override
	public List<GalleryVO> getPostsByTag(String tagName) {
		return galleryMapper.getPostsByTag(tagName);
	}

	@Override
	public List<GalleryVO> searchGallery(GalleryVO galleryVO) {
		return galleryMapper.searchGallery(galleryVO);
	}
	
	@Override
	public List<GalleryVO> searchGallery2(String searchType, String keyword) {
		return galleryMapper.searchGallery2(searchType, keyword);
	}

	
	@Override
	public List<GalleryVO> searchGallery2(String searchType, String keyword,List<Integer>searchGalleryIdList) {
		return galleryMapper.searchGallery2(searchType, keyword,searchGalleryIdList);
	}


	@Override
	public int getSearchResultCount(GalleryVO galleryVO) {
		return galleryMapper.getSearchResultCount(galleryVO);
	}

	@Override
	public int incrementDownloadCount(int fileId) {
		galleryMapper.incrementDownloadCount(fileId);
		return galleryMapper.getDownloadCount(fileId); // 증가된 다운로드 횟수 반환
	}

	@Override
	public String getThumbnailByBoardId(int boardId) {
		return galleryMapper.getThumbnailByBoardId(boardId);
	}

	@Override
	public boolean increaseViewCount(int boardId, String userId) {
		int todayView = galleryMapper.checkTodayViewHistory(boardId, userId);

		if (todayView == 0) {
			galleryMapper.insertViewHistory(boardId, userId);
			galleryMapper.updateViewCount(boardId);
			return true;
		}
		return false;
	}

	@Override
	public void markFileAsDeleted(int fileId) {
		galleryMapper.updateFileDeleteYn(fileId);
	}

	@Override
	public void updGalleryPost(GalleryVO galleryVO) {
		galleryMapper.updGalleryPost(galleryVO);
	}

	@Override
	public void deleteFiles(List<Long> fileIds) {
		galleryMapper.markFilesAsDeleted(fileIds);
	}

	@Override
	public void addFiles(List<FileVO> fileVOList) {
		for (FileVO fileVO : fileVOList) {
			galleryMapper.insertFile(fileVO);
		}
	}

	@Override
    public int toggleLike(LikeVO likeVO) {
        // 현재 좋아요 상태 확인
        boolean isLiked = galleryMapper.checkLikeStatus(likeVO) > 0;

        if (isLiked) {
            // 좋아요 취소
            galleryMapper.updateLike(likeVO.getBoardId(), likeVO.getUserId(), 0);
        } else {
            // 좋아요 추가
            if (galleryMapper.checkExistingLike(likeVO) > 0) {
            	galleryMapper.updateLike(likeVO.getBoardId(), likeVO.getUserId(), 1);
            } else {
            	galleryMapper.insertLike(likeVO);
            }
        }

        // 현재 게시글의 좋아요 수 반환
        return galleryMapper.getLikeCount(likeVO.getBoardId());
    }
	
	/*
	 * @Override public boolean checkUserLiked(int boardId, String userId) { return
	 * galleryMapper.checkLikeStatus(new LikeVO(boardId,userId))>0; }
	 */
}
