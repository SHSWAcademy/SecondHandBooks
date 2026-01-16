package project.config;


import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.zaxxer.hikari.HikariDataSource;

import java.util.Properties;

@Configuration
@MapperScan(basePackages = {"project"}, annotationClass = Mapper.class)
@ComponentScan(basePackages = {"project"})
@EnableWebMvc
@EnableTransactionManagement
public class MvcConfig implements WebMvcConfigurer{

    @Value("${db.driver}")
    private String driver;
    @Value("${db.url}")
    private String url;
    @Value("${db.username}")
    private String username;
    @Value("${db.password}")
    private String password;

    @Value("${mail.username}")
    private String mailUsername;

    @Value("${mail.password}")
    private String mailPassword;

    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    // JSP ViewResolver
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    // hikaricp
    @Bean
    @Primary
    public HikariDataSource dataSource() {
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setDriverClassName(driver);
        dataSource.setJdbcUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        return dataSource;
    }

    // mybatis
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean ssf = new SqlSessionFactoryBean();
        ssf.setDataSource(dataSource());

        // Java Config로 모든 MyBatis 설정
        org.apache.ibatis.session.Configuration config = new org.apache.ibatis.session.Configuration();

        // 카멜케이스 자동 변환: member_id → memberId
        config.setMapUnderscoreToCamelCase(false);

        // NULL 값 처리
        config.setJdbcTypeForNull(org.apache.ibatis.type.JdbcType.NULL);

        // 로그 설정
        config.setLogImpl(org.apache.ibatis.logging.slf4j.Slf4jImpl.class);

        // TypeAlias 등록 (필요한 패키지만)
        // 아직 VO 클래스가 없으면 주석 처리하기
        try {
            //config.getTypeAliasRegistry().registerAliases("project.member.vo");
        } catch (Exception e) {
            // 패키지 없으면 무시
        }

        ssf.setConfiguration(config);
        //mybatis-config.xml 설정 추가
        //ssf.setConfigLocation(new ClassPathResource("mybatis-config.xml"));

        // Mapper XML 파일 위치 설정
        org.springframework.core.io.support.PathMatchingResourcePatternResolver resolver =
            new org.springframework.core.io.support.PathMatchingResourcePatternResolver();
        ssf.setMapperLocations(resolver.getResources("classpath*:**/*Mapper.xml"));
        
        return ssf.getObject();
    }

    // MultipartResolver
    @Bean
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver = new CommonsMultipartResolver();
        resolver.setMaxUploadSize(5 * 1024 * 1024);
        resolver.setDefaultEncoding("utf-8");
        return resolver;
    }

    // TransactionManager
    @Bean
    public PlatformTransactionManager transactionManager() {
        DataSourceTransactionManager dtm = new DataSourceTransactionManager(dataSource());
        return dtm;
    }

    // property
    @Bean
    public static PropertyPlaceholderConfigurer properties() {
        PropertyPlaceholderConfigurer config = new PropertyPlaceholderConfigurer();
        config.setLocations(
                new ClassPathResource("db.properties"),
                new ClassPathResource("api.properties")
        );
        return config;
    }
    @Bean
    public JavaMailSenderImpl mailSender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();

        // SMTP 서버 설정 (Gmail 기준)
        mailSender.setHost("smtp.gmail.com");
        mailSender.setPort(587); // TLS 포트번호

        // 발신용 계정 정보
        mailSender.setUsername(mailUsername);
        mailSender.setPassword(mailPassword); // 구글 앱 비밀번호 16자리

        // 상세 속성 설정
        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // TLS 보안 설정 필수
        props.put("mail.debug", "true"); // 콘솔에 메일 발송 과정 로그 출력

        // SSL 관련 추가 설정 (간혹 인증서 문제 발생 시 필요)
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        return mailSender;
    }

    // Redis 임시 주입
    // 1. Redis 연결 팩토리 생성 (localhost:6379 접속)
    @Bean
    public RedisConnectionFactory redisConnectionFactory() {
        // 호스트: localhost, 포트: 6379
        return new LettuceConnectionFactory("localhost", 6379);
    }

    // 2. StringRedisTemplate 빈 등록 (이게 없어서 에러가 난 것임)
    @Bean
    public StringRedisTemplate redisTemplate() {
        StringRedisTemplate template = new StringRedisTemplate();
        template.setConnectionFactory(redisConnectionFactory());
        return template;
    }
}
