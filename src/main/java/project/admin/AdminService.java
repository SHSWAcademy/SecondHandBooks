package project.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;
import project.trade.TradeVO;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final AdminMapper adminMapper;

    public AdminVO login(String id, String pwd) {
        return adminMapper.loginAdmin(id, pwd);
    }

    // 통계
    public int countAllMembers() { return adminMapper.countAllMembers(); }
    public int countAllTrades() { return adminMapper.countAllTrades(); }
    public int countAllBookClubs() { return adminMapper.countAllBookClubs(); }

    // 목록
    public List<MemberVO> getRecentMembers() { return adminMapper.selectRecentMembers(); }
    public List<TradeVO> getRecentTrades() { return adminMapper.selectRecentTrades(); }
    public List<BookClubVO> getRecentBookClubs() { return adminMapper.selectRecentBookClubs(); }

    // 조회
    public List<LoginInfoVO> getMemberLoginLogs() {
        return adminMapper.selectMemberLoginLogs();
    }
    public List<LoginInfoVO> getAdminLoginLogs() {
        return adminMapper.selectAdminLoginLogs();
    }

    // 관리자 로그인 기록
    public void recordAdminLogin(Long admin_seq, String login_ip) {
        adminMapper.insertAdminLogin(admin_seq, login_ip);
    }
    // 관리자 로그아웃 기록
    public void recordAdminLogout(Long admin_seq, String logout_ip) {
        adminMapper.updateAdminLogout(admin_seq, logout_ip);
    }

    // 회원 로그인 기록
    public void recordMemberLogin(Long member_seq, String login_ip) {
        adminMapper.insertMemberLogin(member_seq, login_ip);
    }
    //회원 로그아웃 기록
    public void recordMemberLogout(Long member_seq, String logout_ip) {
        adminMapper.updateMemberLogout(member_seq, logout_ip);
    }
}