package project.bookclub;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BookClubMapper {
    List<BookClubVO> selectMyBookClubs(long member_seq); // 내 모임 조회 추가
}