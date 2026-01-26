package project.config;


import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.*;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.*;
import com.zaxxer.hikari.HikariDataSource;

import java.util.Properties;

@Configuration
@MapperScan(basePackages = {"project"}, annotationClass = Mapper.class)
@ComponentScan(basePackages = {"project"})
@EnableWebMvc
@EnableTransactionManagement
@PropertySource("classpath:application.properties")
public class MvcConfig implements WebMvcConfigurer {

    @Value("${db.driver}")
    private String driver;
    @Value("${db.url}")
    private String url;
    @Value("${db.username}")
    private String username;
    @Value("${db.password}")
    private String password;

    // ================= Mail =================
    @Value("${mail.username}")
    private String mailUsername;
    @Value("${mail.password}")
    private String mailPassword;

    // ================= Redis =================
    @Value("${redis.host}")
    private String redisHost;
    @Value("${redis.port}")
    private int redisPort;
    @Value("${file.dir}")
    private String uploadPath;

    // JSP ViewResolver
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    // ================= Property =================
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertyConfigurer() {
        PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
        configurer.setLocation(new ClassPathResource("application.properties"));
        return configurer;
    }

    // 이미지 경로 매핑 (임시 S3사용시 필요없음)
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/img/**")
                .addResourceLocations("img/");
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

        /*
        첫 요청 시 최적화
        dataSource.setMinimumIdle(5); // 최소 유휴 연결, 기본값 :0 -> 현재 설정값 5

        서버 시작 시 커넥션을 먼저 몇 개 띄워둘 것인지에 대한 설정
        풀에서 '항상 유지할' 최소 유휴 연결 수
        설정을 따로 하지 않으면 기본값 0 적용 : 서버 시작 시 0개의 커넥션을 먼저 띄운다.
        setMinimumIdle(5) : 서버 시작 시 5개의 커넥션을 먼저 띄운다.
        => 서버를 띄우고 맨 처음 요청 시 느린 현상이 없어진다.

        서버가 띄워지고 맨 처음 요청 시 실행 시간이 1초가 넘어가서 추가를 해봤는데도 크게 성능이 줄어들지가 않는군..
        커넥션 풀 문제가 아니라 JSP 컴파일 타임때문에 실행 시간이 많이 걸리는듯 .. ?

        dataSource.setConnectionTestQuery("SELECT 1");
        // 연결 유효성 검사 (안정성), DB 연결이 끊어졌는지에 대한 검증
         */


        return dataSource;
    }

    // mybatis
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean ssf = new SqlSessionFactoryBean();
        ssf.setDataSource(dataSource());

        // Java Config로 모든 MyBatis 설정
        org.apache.ibatis.session.Configuration config = new org.apache.ibatis.session.Configuration();

        config.setMapUnderscoreToCamelCase(false);
        config.setJdbcTypeForNull(org.apache.ibatis.type.JdbcType.NULL);
        config.setLogImpl(org.apache.ibatis.logging.slf4j.Slf4jImpl.class);

        ssf.setConfiguration(config);

        org.springframework.core.io.support.PathMatchingResourcePatternResolver resolver =
                new org.springframework.core.io.support.PathMatchingResourcePatternResolver();
        ssf.setMapperLocations(resolver.getResources("classpath:**/*Mapper.xml"));

        return ssf.getObject();
    }



    // ================= TransactionManager =================
    @Bean
    public PlatformTransactionManager transactionManager() {
        return new DataSourceTransactionManager(dataSource());
    }

    // ================= MultipartResolver =================
    @Bean
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver = new CommonsMultipartResolver();
        resolver.setMaxUploadSize(5 * 1024 * 1024);
        resolver.setDefaultEncoding("utf-8");
        return resolver;
    }

    @Bean
    public JavaMailSenderImpl mailSender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost("smtp.gmail.com");
        mailSender.setPort(587);
        mailSender.setUsername(mailUsername);
        mailSender.setPassword(mailPassword);

        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.debug", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        return mailSender;
    }

    @Bean
    public RedisConnectionFactory redisConnectionFactory() {
        return new LettuceConnectionFactory(redisHost, redisPort);
    }

    @Bean
    public StringRedisTemplate redisTemplate() {
        StringRedisTemplate template = new StringRedisTemplate();
        template.setConnectionFactory(redisConnectionFactory());
        return template;
    }


}
