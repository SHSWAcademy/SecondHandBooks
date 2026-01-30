package project.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

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
                .formLogin(form -> form.disable())
                .httpBasic(basic -> basic.disable())
                .logout(logout -> logout.disable());

        return http.build();
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
}
