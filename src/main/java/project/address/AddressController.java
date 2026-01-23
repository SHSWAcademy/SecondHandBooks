package project.address;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import project.member.MemberVO;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/profile/address")
public class AddressController {

    private final AddressService addressService;

    @GetMapping("/list")
    @ResponseBody
    public List<AddressVO> getAddressList(HttpSession sess) {
        MemberVO user = (MemberVO) sess.getAttribute("loginSess");
        if (user == null) return null;
        return addressService.getAddressList(user.getMember_seq());
    }

    @PostMapping("/add")
    @ResponseBody
    public String addAddress(AddressVO vo, HttpSession sess) {
        MemberVO user = (MemberVO) sess.getAttribute("loginSess");
        if (user == null) return "fail";

        vo.setMember_seq(user.getMember_seq());
        // int 타입은 체크 안 하면 0이 되므로 별도 처리 불필요

        boolean result = addressService.addAddress(vo);
        return result ? "success" : "fail";
    }

    // [추가] 수정 요청
    @PostMapping("/update")
    @ResponseBody
    public String updateAddress(AddressVO vo, HttpSession sess) {
        MemberVO user = (MemberVO) sess.getAttribute("loginSess");
        if (user == null) return "fail";

        vo.setMember_seq(user.getMember_seq());

        boolean result = addressService.updateAddress(vo);
        return result ? "success" : "fail";
    }

    @PostMapping("/delete")
    @ResponseBody
    public String deleteAddress(@RequestParam long addr_seq) {
        boolean result = addressService.deleteAddress(addr_seq);
        return result ? "success" : "fail";
    }

    @PostMapping("/setDefault")
    @ResponseBody
    public String setDefaultAddress(@RequestParam long addr_seq, HttpSession sess) {
        MemberVO user = (MemberVO) sess.getAttribute("loginSess");
        if (user == null) return "fail";

        boolean result = addressService.setMyDefaultAddress(user.getMember_seq(), addr_seq);
        return result ? "success" : "fail";
    }
}