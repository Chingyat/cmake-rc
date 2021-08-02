cmake_minimum_required(VERSION 3.13)

project(cmake-rc)

include(GNUInstallDirs)
install(FILES cmake/rc_gen.cmake cmake/rc.cmake
  DESTINATION ${CMAKE_INSTALL_DATADIR}/cmake/Modules)

add_subdirectory(example)
