package project.admin;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;
import project.trade.TradeVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminMapper {
    AdminVO loginAdmin(@Param("id") String id, @Param("pwd") String pwd);

    // 통계 (카드)
    int countAllMembers();
    int countAllTrades();
    int countAllBookClubs();

    // 검색 (리스트)
    List<MemberVO> searchMembers(@Param("status") String status, @Param("keyword") String keyword);
    List<TradeVO> searchTrades(@Param("status") String status, @Param("keyword") String keyword);
    List<BookClubVO> searchBookClubs(@Param("keyword") String keyword);

    // 관리 (액션)
    void updateMemberStatus(@Param("seq") Long seq, @Param("status") String status);
    void deleteMember(@Param("seq") Long seq);

    void updateTradeStatus(@Param("seq") Long seq, @Param("status") String status);
    void deleteTrade(@Param("seq") Long seq);

    void deleteBookClub(@Param("seq") Long seq);

    // [NEW] 차트 통계
    List<Map<String, Object>> selectDailySignupStats();
    List<Map<String, Object>> selectDailyTradeStats();
    List<Map<String, Object>> selectCategoryStats();
}