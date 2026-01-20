package project.chat.chatroom;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import project.chat.message.MessageService;
import project.chat.message.MessageVO;
import project.member.MemberVO;
import project.trade.TradeVO;
import project.util.Const;
import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatroomController {

    private final ChatroomService chatroomService;
    private final MessageService messageService;


    // 메인 화면 -> 채팅방 조회
    @GetMapping("/chatrooms")
    public String chat(Model model, HttpSession session) {

        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);

        // home 에서 로그인하지 않고 채팅방 접근 시 home 으로 리다이렉트
        if (sessionMember == null) {
            return "redirect:/";
        }

        // 지금은 전부 조회하지만 나중에 페이징 처리 필요
        List<ChatroomVO> chatrooms = chatroomService.searchAll(sessionMember.getMember_seq());

        model.addAttribute("chatrooms", chatrooms);

        return "chat/chatrooms";
    }



    // 판매글 -> 채팅방
    @PostMapping("/chatrooms")
    public String chat(Model model, HttpSession session, TradeVO tradeVO) {
        // 프론트에서 trade_seq, member_seller_seq, sale_title 이 tradeVO 로 넘어온다

        MemberVO sessionMember = (MemberVO) session.getAttribute(Const.SESSION);

        // 로그인하지 않고 채팅방 접근 시 home 으로 리다이렉트
        if (sessionMember == null) {
            return "redirect:/";
        }

        // 1. 판매글에서 채팅하기로 채팅에 들어왔을 경우 (프론트에서 tradeVO가 넘어올 경우)
        if (tradeVO.getTrade_seq() > 0) {

            long trade_seq = tradeVO.getTrade_seq();
            long member_seller_seq = tradeVO.getMember_seller_seq();
            long member_buyer_seq = sessionMember.getMember_seq();

            String sale_title = tradeVO.getSale_title();

            // 본인 채팅 방지
            if (member_seller_seq == member_buyer_seq) {
                return "chat/chatrooms";  // 채팅방 목록만 보여줌
            }

            ChatroomVO tradeChatroom = chatroomService.findOrCreateRoom(member_seller_seq, member_buyer_seq, trade_seq, sale_title);
            List<MessageVO> messages = messageService.getAllMessages(tradeChatroom.getChat_room_seq());
            model.addAttribute("trade_chat_room", tradeChatroom); // 현재 채팅방 전달
            model.addAttribute("messages", messages); // 현재 채팅방의 전체 메시지 전달 (이후 페이징 처리 필요)
        }


        // 2. 채팅방 모두 출력 (지금은 전부 조회하지만 나중에 페이징 처리 필요)
        List<ChatroomVO> chatrooms = chatroomService.searchAll(sessionMember.getMember_seq());
        System.out.println("테스트 출력 " + chatrooms.toString());
        model.addAttribute("chatrooms", chatrooms);
        // model.addAttribute("member_seq", sessionMember.getMember_seq());

        return "chat/chatrooms";
    }

    // 채팅 메시지 조회 api
    @GetMapping("/chat/messages")
    @ResponseBody
    public List<MessageVO> getMessages(@RequestParam("chat_room_seq") long chat_room_seq) {
        return messageService.getAllMessages(chat_room_seq);
    }

}
