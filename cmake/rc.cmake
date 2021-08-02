set(RC_BASE_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(add_resource name)
  cmake_parse_arguments(RC ";" "HEADER;SOURCE;NAMESPACE" "FILES" ${ARGN})

  if(NOT DEFINED RC_HEADER)
    set(RC_HEADER "${name}.hxx")
  endif()

  if(NOT DEFINED RC_SOURCE)
    set(RC_SOURCE "${name}.cxx")
  endif()

  get_filename_component(
    RC_HEADER
    ${RC_HEADER}
    ABSOLUTE
    BASE_DIR ${CMAKE_CURRENT_BINARY_DIR}/rc_gen
  )
  get_filename_component(
    RC_SOURCE
    ${RC_SOURCE}
    ABSOLUTE
    BASE_DIR ${CMAKE_CURRENT_BINARY_DIR}/rc_gen
  )

  set(DEPENDENCIES "")
  foreach(file ${RC_FILES})
    string(FIND ${file} = index)
    if(index EQUAL -1)
      list(APPEND DEPENDENCIES ${file})
    else()
      string(SUBSTRING ${file} 0 ${index} file)
      list(APPEND DEPENDENCIES ${file})
    endif()
  endforeach()

  add_custom_command(
    OUTPUT ${RC_HEADER} ${RC_SOURCE}
    COMMAND 
      "${CMAKE_COMMAND}"
      "-DGEN_HDR=${RC_HEADER}"
      "-DGEN_SRC=${RC_SOURCE}"
      "-DRC_NAMESPACE=${RC_NAMESPACE}"
      "-DRC_ITEMS=${RC_FILES}"
      "-P"
      "${RC_BASE_DIR}/rc_gen.cmake"
    DEPENDS ${DEPENDENCIES} ${RC_BASE_DIR}/rc_gen.cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    VERBATIM
  )

  add_library(${name} ${RC_SOURCE})
  target_include_directories(${name}
    INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/rc_gen
    )
endfunction()
