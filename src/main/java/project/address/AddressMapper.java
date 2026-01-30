package project.address;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface AddressMapper {
    List<AddressVO> selectAddressList(long member_seq);
    int insertAddress(AddressVO vo);
    int deleteAddress(long addr_seq);
    int resetDefaultAddress(long member_seq);
    int setDefaultAddress(long addr_seq);
    int updateAddress(AddressVO vo);
    int countAddress(long member_seq); // 주소 갯수 제한 (5개)
}