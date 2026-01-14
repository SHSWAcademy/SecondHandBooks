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
@Transactional(readOnly = true)
public class MemberService{

    @Autowired
    private final MemberMapper memberMapper;

    public boolean signUp(MemberVO vo) {
        return memberMapper.signUp(vo) > 0;
    }

    public int idCheck(String login_id) {
        return memberMapper.idCheck(login_id);
    }
    public int nickNmCheck(String member_nicknm) {
        return memberMapper.nickNmCheck(member_nicknm);
    }
    public int emailCheck(String member_email) {
        return memberMapper.emailCheck(member_email);
    }
}