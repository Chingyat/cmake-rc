file(WRITE ${GEN_SRC} "#include \"${GEN_HDR}\"\n\n")
string(MAKE_C_IDENTIFIER ${GEN_HDR} hdr_guard)
string(TOUPPER ${hdr_guard} hdr_guard)
file(WRITE ${GEN_HDR} "#ifndef ${hdr_guard}
#define ${hdr_guard}

#include <array>
#include <cstdint>

")

if(NOT RC_NAMESPACE STREQUAL "")
  file(APPEND ${GEN_HDR} "namespace ${RC_NAMESPACE} {\n\n")
  file(APPEND ${GEN_SRC} "namespace ${RC_NAMESPACE} {\n\n")
  
endif()

foreach(item ${RC_ITEMS})
  string(FIND ${item} = index)
  string(SUBSTRING ${item} 0 ${index} file)
  math(EXPR index "${index} + 1")
  string(SUBSTRING ${item} ${index} -1 ident)
  string(MAKE_C_IDENTIFIER ${ident} ident)
  file(SIZE ${file} file_size)
  set(file_data "")
  set(i 0)
  while(i LESS file_size)
    math(EXPR modulo "${i} % 12")
    if(modulo EQUAL 0)
      string(APPEND file_data "\n")
    endif()
    file(READ ${file} byte OFFSET ${i} LIMIT 1 HEX)
    string(APPEND file_data "0x${byte}, ")
    math(EXPR i "${i} + 1")
  endwhile()

  file(APPEND ${GEN_SRC} "const std::array<std::uint8_t, ${file_size}> ${ident} {{${file_data}}};\n")
  file(APPEND ${GEN_HDR} "extern const std::array<std::uint8_t, ${file_size}> ${ident};\n")
endforeach()

if(NOT RC_NAMESPACE STREQUAL "")
  file(APPEND ${GEN_HDR} "\n} // namespace ${RC_NAMESPACE} \n")
  file(APPEND ${GEN_SRC} "\n} // namespace ${RC_NAMESPACE} \n")
endif()

file(APPEND ${GEN_HDR} "\n#endif // ${hdr_guard}\n")

