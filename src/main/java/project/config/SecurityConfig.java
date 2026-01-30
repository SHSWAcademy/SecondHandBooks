package project.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.csrf.InvalidCsrfTokenException;
import org.springframework.security.web.csrf.MissingCsrfTokenException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletResponse;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

    // 1) 독서모임 전체: CSRF 켬
    @Bean
    @Order(1)
    public SecurityFilterChain bookClubChain(HttpSecurity http) throws Exception {
        http
                // ✅ 이 체인은 /bookclubs/** 전체에 적용
                .antMatcher("/bookclubs/**")
                .authorizeRequests()
                .anyRequest().permitAll()
                .and()
                .csrf(csrf -> csrf
                        .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()))
                .exceptionHandling(ex -> ex
                        .accessDeniedHandler(bookClubAccessDeniedHandler()))
                .formLogin(form -> form.disable())
                .httpBasic(basic -> basic.disable())
                .logout(logout -> logout.disable());

        return http.build();
    }

    /**
     * BookClub CSRF 검증 실패 등 접근 거부 시 처리
     * - AJAX 요청: 401 + JSON 응답
     * - 일반 요청: /login으로 리다이렉트
     */
    @Bean
    public AccessDeniedHandler bookClubAccessDeniedHandler() {
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
                        "\"redirectUrl\":\"/login\"}"
                );
            } else {
                // 일반 요청: 로그인 페이지로 리다이렉트
                String redirectUrl = isCsrfError
                        ? request.getContextPath() + "/login?expired=true"
                        : request.getContextPath() + "/login?denied=true";
                response.sendRedirect(redirectUrl);
            }
        };
    }

    // 2) 나머지 전체: CSRF 끔 (기존 로그인/POST 흐름 안 깨지게)
    @Bean
    @Order(2)
    public SecurityFilterChain allOtherChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll())
                // ✅ 여기서 CSRF를 꺼서 기존 로그인/POST가 안 막히게 함
                .csrf(csrf -> csrf.disable())
                .formLogin(form -> form.disable())
                .httpBasic(basic -> basic.disable())
                .logout(logout -> logout.disable());

        return http.build();
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
