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
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.*;

import com.zaxxer.hikari.HikariDataSource;

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


    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    // JSP ViewResolver
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    // 이미지 경로 매핑 (임시 S3사용시 필요없음)
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/img/**")
                .addResourceLocations("file:///D:/Project/SecondHandBooks/img/");
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
        // 카멜 케이스 자동 변환 취소 : true -> false
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
        ssf.setMapperLocations(resolver.getResources("classpath:project/**/*Mapper.xml"));
        
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
        config.setLocation(new ClassPathResource("application.properties"));
        return config;
    }
}
