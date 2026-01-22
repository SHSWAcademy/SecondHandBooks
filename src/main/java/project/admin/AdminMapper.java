package project.admin;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.bookclub.vo.BookClubVO;
import project.member.MemberVO;
import project.trade.TradeVO;

import java.util.List;

@Mapper
public interface AdminMapper {
    AdminVO loginAdmin(@Param("id") String id, @Param("pwd") String pwd);

    // 통계
    int countAllMembers();
    int countAllTrades();
    int countAllBookClubs();

    // 목록 조회
    List<MemberVO> selectRecentMembers();
    List<TradeVO> selectRecentTrades();
    List<BookClubVO> selectRecentBookClubs();

    // 조회
    List<LoginInfoVO> selectMemberLoginLogs();
    List<LoginInfoVO> selectAdminLoginLogs();

    // 저장/업데이트
    void insertAdminLogin(@Param("admin_seq") Long admin_seq, @Param("login_ip") String login_ip);
    void updateAdminLogout(@Param("admin_seq") Long admin_seq, @Param("logout_ip") String logout_ip);
    void insertMemberLogin(@Param("member_seq") Long admin_seq, @Param("login_ip") String login_ip);
    void updateMemberLogout(@Param("member_seq") Long admin_seq, @Param("login_ip") String login_ip);
}