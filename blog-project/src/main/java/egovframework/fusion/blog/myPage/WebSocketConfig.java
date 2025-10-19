package egovframework.fusion.blog.myPage;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.beans.factory.annotation.Autowired;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Autowired
    private ChatWebSocketHandler chatWebSocketHandler;

    public WebSocketConfig() {
        System.out.println("🧩 WebSocketConfig 생성자 호출됨");
    }
    
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
    	 System.out.println("✅ WebSocketConfig 등록됨");

	    registry.addHandler(chatWebSocketHandler, "/chatting.do")
	            .setAllowedOrigins("*");
    }
    
}
