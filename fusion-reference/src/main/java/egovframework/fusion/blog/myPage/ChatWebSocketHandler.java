package egovframework.fusion.blog.myPage;


import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import egovframework.fusion.blog.myPage.service.ChatService;
import egovframework.fusion.blog.myPage.vo.ChattingVO;

import java.net.URI;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {
	
	@Autowired
	private ChatService chatService;
	
	private ObjectMapper objectMapper= new ObjectMapper(); //Jackson객체

    // 연결된 사용자 관리용 맵 (roomId -> 세션 목록)
    private final Map<String, List<WebSocketSession>> roomSessions = new HashMap<>();
    Map<String, WebSocketSession> userSession=new ConcurrentHashMap<>();
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
    	try {			
    		String roomId = getPathVariable(session, "roomId");
    		String userId= getUserIdFromQuery(session);
    		roomSessions.putIfAbsent(roomId, new ArrayList<>());
    		roomSessions.get(roomId).add(session);
    		userSession.put(userId, session);
    		System.out.println("✅ 연결됨 - roomId: " + roomId);
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String roomId = getPathVariable(session, "roomId");
        System.out.println("[메세지전송]");
        System.out.println("메세지:"+message.getPayload());
        System.out.println("senderId:");
        // 1. JSON -> ChattingVO로 변환
        ChattingVO chatData = objectMapper.readValue(message.getPayload(), ChattingVO.class);
        System.out.println("[chatData getType]: "+chatData.getType());
        if("readNotify".equals(chatData.getType())) {
        	chatService.markMessageAsY(chatData.getRoomId(),chatData.getSenderId(),chatData.getReceiverId());
        	return;
        }
        
        chatService.saveMessage(chatData);

        for (WebSocketSession s : roomSessions.getOrDefault(roomId, new ArrayList<>())) {
        	if (s.isOpen()) {
        		s.sendMessage(message);
        	}
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
    	try {
			 String roomId = getPathVariable(session, "roomId");

	        if (roomId != null && roomSessions.containsKey(roomId)) {
	            roomSessions.get(roomId).remove(session);
	        }
	
	        System.out.println("❌ 연결 종료 - roomId: " + roomId);
		} catch (Exception e) {
			e.printStackTrace();
		}
       
    }

    private String getPathVariable(WebSocketSession session, String key) {
        Map<String, Object> attributes = session.getAttributes();
        String uri = session.getUri().toString();
        System.out.println("[get]PathVariable: "+uri);
        String[] split = uri.split("/");
        if (key.equals("roomId")) {
            return split[split.length - 2];
        } else if (key.equals("userId")) {
            return split[split.length - 1];
        }
        return null;
    }
    
    private String getUserIdFromQuery(WebSocketSession session) {
        String query = session.getUri().getQuery(); // "userId=user123"
        
        if (query != null) {
            for (String param : query.split("&")) {
                String[] pair = param.split("=");
                if (pair.length == 2 && "userId".equals(pair[0])) {
                    return pair[1];
                }
            }
        }
        return null;
    }

}