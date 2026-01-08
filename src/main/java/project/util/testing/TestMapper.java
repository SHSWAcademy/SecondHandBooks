package project.util.testing;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TestMapper {
    List<TestVO> selectAll();  // 전체 조회
    TestVO selectOne(int no);  // 단건 조회
}