package project.util.testing;

import java.util.List;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TestServiceImpl implements TestService {

    private final TestMapper mapper;

    @Override
    public List<TestVO> selectAll() {
        return mapper.selectAll();
    }

    @Override
    public TestVO selectOne(int no) {
        return mapper.selectOne(no);
    }
}