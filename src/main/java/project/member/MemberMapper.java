package project.member;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Map;

@Mapper
public interface MemberMapper {
    MemberVO login(MemberVO vo);
    int loginLogUpdate(long member_seq);
    int signUp(MemberVO vo);

    //
    int idCheck(String login_id);
    int nickNmCheck(String member_nicknm);
    int emailCheck(String member_email);

    MemberVO getMemberByOAuth(Map<String, Object> map);
    void insertSocialMemberInfo(Map<String, Object> map);
    void insertMemberOAuth(Map<String, Object> map);

    int updateMember(MemberVO vo);
    int deleteMember(long member_seq);

    String findIdByTel(String member_tel_no);

    int checkUserByIdAndEmail(@org.apache.ibatis.annotations.Param("login_id") String login_id,
                              @org.apache.ibatis.annotations.Param("member_email") String member_email);

    int updatePassword(@org.apache.ibatis.annotations.Param("login_id") String login_id,
                       @org.apache.ibatis.annotations.Param("member_pwd") String member_pwd);

    int checkPasswordMatch(@Param("login_id") String login_id, @Param("member_pwd") String member_pwd);
}
