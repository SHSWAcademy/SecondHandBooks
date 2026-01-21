package project.admin;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AdminMapper {
    // 관리자 로그인 (ID, PW로 조회)
    AdminVO loginAdmin(@Param("id") String id, @Param("pwd") String pwd);
}