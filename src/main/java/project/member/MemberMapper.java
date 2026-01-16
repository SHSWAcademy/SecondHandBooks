package project.member;

import org.apache.ibatis.annotations.Mapper;

import java.util.Map;

@Mapper
public interface MemberMapper {
    MemberVO login(MemberVO vo);
    int signUp(MemberVO vo);
    // CRUD, findById, save
    int idCheck(String login_id);
    int nickNmCheck(String member_nicknm);
    int emailCheck(String member_email);

    MemberVO getMemberByOAuth(Map<String, Object> map);
    void insertSocialMemberInfo(Map<String, Object> map);
    void insertMemberOAuth(Map<String, Object> map);
}
