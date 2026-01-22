package project.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;
import project.trade.TradeVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final AdminMapper adminMapper;

    public AdminVO login(String id, String pwd) {
        return adminMapper.loginAdmin(id, pwd);
    }

    // --- 통계 ---
    public int countAllMembers() { return adminMapper.countAllMembers(); }
    public int countAllTrades() { return adminMapper.countAllTrades(); }
    public int countAllBookClubs() { return adminMapper.countAllBookClubs(); }

    // --- 검색 (API) ---
    public List<MemberVO> searchMembers(String status, String keyword) {
        return adminMapper.searchMembers(status, keyword);
    }

    public List<TradeVO> searchTrades(String status, String keyword) {
        return adminMapper.searchTrades(status, keyword);
    }

    public List<BookClubVO> searchBookClubs(String keyword) {
        return adminMapper.searchBookClubs(keyword);
    }

    // --- 관리 액션 (API) ---
    @Transactional
    public void handleMemberAction(Long seq, String action) {
        // ENUM 값에 맞춰 상태 코드 매핑 필요
        if ("BAN".equals(action)) adminMapper.updateMemberStatus(seq, "BAN");
        else if ("ACTIVE".equals(action)) adminMapper.updateMemberStatus(seq, "JOIN");
        else if ("DELETE".equals(action)) adminMapper.deleteMember(seq);
    }

    @Transactional
    public void handleTradeAction(Long seq, String action) {
        if ("DELETE".equals(action)) {
            adminMapper.deleteTrade(seq);
        } else {
            // SALE, RESERVED, SOLD 등
            adminMapper.updateTradeStatus(seq, action);
        }
    }

    @Transactional
    public void deleteBookClub(Long seq) {
        adminMapper.deleteBookClub(seq);
    }

    // --- [NEW] 차트 데이터 조회 ---
    public Map<String, Object> getChartData() {
        Map<String, Object> data = new HashMap<>();
        data.put("dailySignups", adminMapper.selectDailySignupStats());
        data.put("dailyTrades", adminMapper.selectDailyTradeStats());
        data.put("categories", adminMapper.selectCategoryStats());
        return data;
    }

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