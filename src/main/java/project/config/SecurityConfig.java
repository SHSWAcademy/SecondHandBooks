package project.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.csrf.InvalidCsrfTokenException;
import org.springframework.security.web.csrf.MissingCsrfTokenException;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletResponse;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

        private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

        /**
         * 통합 보안 설정
         * - CSRF: 기본 활성화 (세션 기반)
         * - 기존 기능(/login, /member, /trade 등)은 CSRF 예외 처리
         * - 북클럽(/bookclubs)은 CSRF 보호 적용 (상태 변경 요청만)
         */
        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                http
                                .authorizeRequests()
                                .anyRequest().permitAll()
                                .and()
                                // ✅ CSRF: /bookclubs/** 경로의 POST/PUT/PATCH/DELETE 요청에만 적용
                                .csrf()
                                .requireCsrfProtectionMatcher(request -> {
                                        String uri = request.getRequestURI();
                                        String contextPath = request.getContextPath();

                                        // contextPath 제거
                                        if (contextPath != null && !contextPath.isEmpty()) {
                                                uri = uri.substring(contextPath.length());
                                        }

                                        // /bookclubs/** 경로 체크
                                        if (!uri.startsWith("/bookclubs")) {
                                                return false;
                                        }

                                        // 상태 변경 메소드만 CSRF 적용 (POST, PUT, PATCH, DELETE)
                                        // GET은 조회 요청이므로 CSRF 불필요
                                        String method = request.getMethod();
                                        return "POST".equals(method) || "PUT".equals(method) ||
                                                        "PATCH".equals(method) || "DELETE".equals(method);
                                })
                                .and()
                                .exceptionHandling(ex -> ex
                                                .accessDeniedHandler(csrfAccessDeniedHandler()))
                                .formLogin().disable()
                                .httpBasic().disable()
                                .logout().disable();

                return http.build();
        }

        /**
         * CSRF 검증 실패 등 접근 거부 시 처리
         * - AJAX 요청: 401 + JSON 응답
         * - 일반 요청: /login으로 리다이렉트
         */
        @Bean
        public AccessDeniedHandler csrfAccessDeniedHandler() {
                return (request, response, accessDeniedException) -> {
                        log.warn("Access denied for URI: {}, Exception: {}",
                                        request.getRequestURI(), accessDeniedException.getClass().getSimpleName());

                        // CSRF 토큰 관련 예외인 경우 (세션 만료로 인한 토큰 불일치 가능성)
                        boolean isCsrfError = accessDeniedException instanceof InvalidCsrfTokenException
                                        || accessDeniedException instanceof MissingCsrfTokenException;

                        // AJAX 요청 감지
                        String requestedWith = request.getHeader("X-Requested-With");
                        boolean isAjax = "XMLHttpRequest".equals(requestedWith);
                        String accept = request.getHeader("Accept");
                        boolean isJsonRequest = accept != null && accept.contains("application/json");

                        if (isAjax || isJsonRequest) {
                                // AJAX/JSON 요청: 401 + JSON 응답
                                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                                response.setContentType("application/json;charset=UTF-8");
                                String message = isCsrfError
                                                ? "세션이 만료되었습니다. 페이지를 새로고침 후 다시 시도해주세요."
                                                : "접근이 거부되었습니다. 다시 로그인해주세요.";
                                response.getWriter().write(
                                                "{\"error\":\"SESSION_EXPIRED\"," +
                                                                "\"message\":\"" + message + "\"," +
                                                                "\"redirectUrl\":\"/login\"}");
                        } else {
                                // 일반 요청: 로그인 페이지로 리다이렉트
                                String redirectUrl = isCsrfError
                                                ? request.getContextPath() + "/login?expired=true"
                                                : request.getContextPath() + "/login?denied=true";
                                response.sendRedirect(redirectUrl);
                        }
                };
        }

        @Bean
        public BCryptPasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }
}