include(cmake/internal/_bottle_compile_msgs)
include(cmake/internal/_bottle_expand_deps)
include(cmake/internal/_bottle_try_link_package)

function(bottle_proto)
  # parse arguments
  cmake_parse_arguments(__bottle_tgt "XCLD" "NAME" "MSGS" ${ARGN})

  # check arguments
  if(NOT __bottle_tgt_NAME)
    # BIN not defined or empty
    message(FATAL_ERROR "[bottle] creating proto target: must provide a NAME")
  elseif(NOT __bottle_tgt_MSGS)
    # BIN defined as non-empty but SRCS not defined or empty
    message(FATAL_ERROR "[bottle] creating proto target: must provide MSGS for ${__bottle_tgt_NAME}")
  endif()

  string(JOIN "+" __bottle_tgt_name_ ${BOTTLE_PACKAGE_NAME} ${__bottle_tgt_NAME})
  _bottle_expand_deps(__bottle_tgt_proto_ "@protobuf")
  _bottle_compile_msgs(__bottle_tgt_srcs_ __bottle_tgt_hdrs_ ${__bottle_tgt_MSGS})

  add_library(${__bottle_tgt_name_} SHARED)
  target_sources(${__bottle_tgt_name_} PRIVATE ${__bottle_tgt_srcs_})
  target_include_directories(${__bottle_tgt_name_} PUBLIC ${PROJECT_BINARY_DIR})
  target_link_libraries(${__bottle_tgt_name_} PUBLIC ${__bottle_tgt_proto_})

  # link to current package if exists
  if(NOT __bottle_tgt_XCLD)
    _bottle_try_link_package(${__bottle_tgt_name_})
  endif()

  message(VERBOSE "[bottle] proto target with name ${__bottle_tgt_name_}")
endfunction(bottle_proto)
