package egovframework.fusion.comment.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.fusion.comment.service.CommentService;
import egovframework.fusion.comment.vo.CommentVO;
import egovframework.fusion.user.vo.UserVO;

@Controller
@RequestMapping("/board")
public class CommentController{
	
	
	@Autowired
	CommentService commentService;
	
	

    // 댓글 작성
    @PostMapping("/addComment.do")
    public String addComment(CommentVO commentVO, HttpSession session,HttpServletRequest request) {
    	String loggedInUserId = (String) session.getAttribute("userId");
    	commentVO.setUserId(loggedInUserId);
    	
    	String menuId=request.getParameter("menuId");
    	System.out.println("댓글 메뉴 아이디"+menuId);
    	
        commentService.addComment(commentVO);
        System.out.println(commentVO.getBoardId());
        return "redirect:/board/boardPost.do?boardId=" + commentVO.getBoardId()+"&menuId="+menuId;
    }

    // 대댓글 작성
    @PostMapping("/addReply.do")
    public String addReply(HttpSession session,CommentVO commentVO,HttpServletRequest request) {

    	UserVO userVO = (UserVO) session.getAttribute("loggedInUser");
    	
    	String menuId=request.getParameter("menuId");
    	System.out.println("댓글 메뉴 아이디"+menuId);
    	
    	commentVO.setUserId(userVO.getUserId());
        commentService.addReply(commentVO);
        return "redirect:/board/boardPost.do?boardId=" + commentVO.getBoardId()+"&menuId="+menuId;
    }

    // 댓글 수정 폼
    @GetMapping("/editCommentForm.do")
    public String editCommentForm(@RequestParam("commentId") int comment_id, Model model,HttpServletRequest request) {
    	
    	String menuId=request.getParameter("menuId");
    	System.out.println("댓글 메뉴 아이디"+menuId);
    	
        CommentVO comment = commentService.getCommentById(comment_id);
        model.addAttribute("comment", comment);
        return "comment/editCommentForm";
    }

    // 댓글 수정
    @PostMapping("/editComment.do")
    public String editComment(CommentVO commentVO,HttpServletRequest request) {
    	
    	String menuId=request.getParameter("menuId");
    	System.out.println("댓글 메뉴 아이디"+menuId);
    	
        commentService.updateComment(commentVO);
        return "redirect:/board/boardPost.do?boardId=" + commentVO.getBoardId()+"&menuId="+menuId;
    }


    @PostMapping("deleteComment.do")
    public String deleteComment(@RequestParam("commentId") int commentId, 
                                @RequestParam("boardId") int boardId, 
                                RedirectAttributes redirectAttributes,HttpServletRequest request) {
    	String menuId=request.getParameter("menuId");
    	System.out.println("댓글 메뉴 아이디"+menuId);
        try {
            // 댓글 삭제 처리
            commentService.deleteComment(commentId);
            redirectAttributes.addFlashAttribute("message", "댓글이 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "댓글 삭제 중 오류가 발생했습니다.");
        }
        return "redirect:/board/boardPost.do?boardId=" + boardId+"&menuId="+menuId;
    }
}