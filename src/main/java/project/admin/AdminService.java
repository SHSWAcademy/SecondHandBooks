package project.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import project.bookclub.BookClubVO;
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
}