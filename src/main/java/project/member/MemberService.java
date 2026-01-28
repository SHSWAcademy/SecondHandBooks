package project.member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.bookclub.mapper.BookClubMapper;
import project.bookclub.service.BookClubService;
import project.bookclub.vo.BookClubVO;
import project.trade.TradeMapper;

import java.lang.reflect.Member;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MemberService{

    private final MemberMapper memberMapper;
    private final TradeMapper tradeMapper;
    private final BookClubMapper bookClubMapper;

    private final BookClubService bookClubService;

    @Transactional
    public boolean signUp(MemberVO vo) {
        return memberMapper.signUp(vo) > 0;
    }

    public MemberVO login(MemberVO vo) {
        return memberMapper.login(vo);
    }
    // 로그인 로그 찍기
    @Transactional
    public boolean loginLogUpdate(long member_seq) {
        return memberMapper.loginLogUpdate(member_seq) > 0;
    }
    public int idCheck(String login_id) {
        System.out.println(memberMapper.idCheck(login_id) > 0 ? "중복" : "사용가능"); // db조회해서 중복 체크 성공 확인
        return memberMapper.idCheck(login_id);
    }
    public int nickNmCheck(String member_nicknm) {
        System.out.println(memberMapper.nickNmCheck(member_nicknm) > 0 ? "중복" : "사용가능"); // db조회해서 중복 체크 성공 확인
        return memberMapper.nickNmCheck(member_nicknm);
    }
    public int emailCheck(String member_email) {
        System.out.println(memberMapper.emailCheck(member_email) > 0 ? "중복" : "사용가능"); // db조회해서 중복 체크 성공 확인
        return memberMapper.emailCheck(member_email);
    }
    @Transactional // 2개 테이블 insert 보호
    public MemberVO processSocialLogin(Map<String, Object> params) {
        // 1. 소셜 ID로 가입 여부 확인
        MemberVO existMember = memberMapper.getMemberByOAuth(params);

        if (existMember != null) {
            // 이미 가입됨 -> 로그인
            if (existMember.getMember_deleted_dtm() != null) {
                return null;
            }
            return existMember;
        }

        // 2. 미가입 -> 회원가입 진행
        // (1) MEMBER_INFO 저장 (Map 사용)
        //params.put("member_st", "ACTIVE");
        String generatedLoginId = params.get("provider") + "_" + params.get("provider_id");
        params.put("login_id", generatedLoginId);
        String generatedPwd = params.get("provider") + "_로그인";
        params.put("member_pwd", generatedPwd);
        memberMapper.insertSocialMemberInfo(params);

        // (2) MEMBER_OAUTH 저장 (방금 생성된 member_seq 사용)
        // insertSocialMemberInfo 실행 시 params에 member_seq가 담겨옴
        memberMapper.insertMemberOAuth(params);

        // 3. 가입된 정보 다시 조회해서 리턴
        return memberMapper.getMemberByOAuth(params);
    }
    // 프로필 - 회원 정보 수정
    @Transactional
    public boolean updateMember(MemberVO vo) {
        return memberMapper.updateMember(vo) > 0;
    }
    // 프로필 - 회원 탈퇴

    @Transactional
    public boolean deleteMember(long member_seq) {
        
        // 1. 탈퇴하는 회원이 쓴 Trade soft delete
        int deleteTradeCount = tradeMapper.deleteAll(member_seq);
        log.info("delete trade count : {}", deleteTradeCount);
        

        // 2. 탈퇴한 회원의 Book Club 처리
        // BookClubVO seq 조회를 위한 select 쿼리 전달
        List<BookClubVO> bookClubVOS = bookClubMapper.selectMyBookClubs(member_seq);
        for (BookClubVO bookClubVO : bookClubVOS) {
            Map<String, Object> result = bookClubService.leaveBookClub(bookClubVO.getBook_club_seq(), member_seq);
            result.forEach((key, value) -> log.info("leaveBookClub - {} : {}", key, value));
        }

        return memberMapper.deleteMember(member_seq) > 0;
    }

    // 아이디 찾기 (전화번호로)
    public String findIdByTel(String member_tel_no) {
        return memberMapper.findIdByTel(member_tel_no);
    }

    // 비밀번호 찾기 - 회원 확인
    public boolean checkUserByIdAndEmail(String login_id, String member_email) {
        int count = memberMapper.checkUserByIdAndEmail(login_id, member_email);
        return count > 0;
    }

    // 비밀번호 재설정
    @Transactional
    public boolean resetPassword(String login_id, String new_pwd) {
        // 실제 운영 시에는 여기서 BCryptPasswordEncoder 등을 사용해 암호화해야 함
        // 예: String encPwd = passwordEncoder.encode(new_pwd);
        return memberMapper.updatePassword(login_id, new_pwd) > 0;
    }
}