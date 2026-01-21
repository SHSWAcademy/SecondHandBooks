package project.admin;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import project.bookclub.BookClubVO;
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
}