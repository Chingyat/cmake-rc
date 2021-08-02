#include "res.hxx"
#include <iostream>

void test()
{
  std::cout.write(reinterpret_cast<char const *>(CMakeLists_txt.data()), CMakeLists_txt.size());

  std::cout.write(reinterpret_cast<char const *>(test_source.data()), test_source.size());
}
