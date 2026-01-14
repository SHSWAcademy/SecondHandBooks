package project.member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.lang.reflect.Member;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class MemberService{

    @Autowired
    private final MemberMapper memberMapper;

    public boolean signUp(MemberVO vo) {
        return memberMapper.signUp(vo) > 0;
    }
    public MemberVO login(MemberVO vo) {
        return memberMapper.login(vo);
    }
    public int idCheck(String login_id) {
        System.out.println(memberMapper.idCheck(login_id) > 0 ? "중복" : "사용가능"); // db조회해서 중복 체크 성공 확인
        return memberMapper.idCheck(login_id);
    }
    public int nickNmCheck(String member_nicknm) {
        return memberMapper.nickNmCheck(member_nicknm);
    }
    public int emailCheck(String member_email) {
        return memberMapper.emailCheck(member_email);
    }
}