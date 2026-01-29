package project.config.interceptor;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import project.common.LogoutPendingManager;
import project.common.UserType;
import project.member.MemberVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Component
@RequiredArgsConstructor
@Slf4j
public class MemberActivityInterceptor implements HandlerInterceptor {

    private final LogoutPendingManager logoutPendingManager;

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        String uri = request.getRequestURI();

        //logout-pending API는 제외
        if (uri.contains("logout-pending")) {
            return true;
        }

        HttpSession sess = request.getSession(false);

        if (sess != null) {
            MemberVO memberVO = (MemberVO) sess.getAttribute("loginSess");

            if (memberVO != null) {
                // ★ 강제 로그아웃 체크 ★
                if (logoutPendingManager.isForceLogout(UserType.MEMBER, memberVO.getMember_seq())) {

                    request.getSession().invalidate();
                    // 강제 로그아웃 대상에서 제거
                    logoutPendingManager.removeForceLogout(UserType.MEMBER, memberVO.getMember_seq());

                    log.info("Member 강제 로그아웃 실행: memberSeq={}", memberVO.getMember_seq());

                    // 홈으로 리다이렉트 (또는 로그인 페이지)
                    response.sendRedirect("/");
                    return false;
                }
                // pending 상태 제거 (활동 감지)
                logoutPendingManager.removePending(UserType.MEMBER, memberVO.getMember_seq());

            }
        }
        return true;
    }
}

