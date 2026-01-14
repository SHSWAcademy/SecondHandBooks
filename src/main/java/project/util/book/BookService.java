package project.util.book;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class BookService {

    private final BookMapper bookMapper;

    @Transactional
    public BookVO saveBook(BookVO bookVO) {
        return bookMapper.save(bookVO);
    }

    public BookVO findByIsbn(String isbn) {
        return bookMapper.findByIsbn(isbn);
    }
}
