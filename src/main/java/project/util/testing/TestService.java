package project.util.testing;

import java.util.List;

public interface TestService {
    List<TestVO> selectAll();
    TestVO selectOne(int no);
}