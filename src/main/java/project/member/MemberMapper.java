package project.member;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {
    int idCheck(String login_id);
    int nickNmCheck(String member_nicknm);
    int emailCheck(String member_email);
}
