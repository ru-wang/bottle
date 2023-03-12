include(cmake/internal/_bottle_compile_fbs)
include(cmake/internal/_bottle_expand_deps)
include(cmake/internal/_bottle_try_link_package)

function(bottle_fbs)
  # parse arguments
  cmake_parse_arguments(__bottle_tgt "XCLD" "NAME" "FBS" ${ARGN})

  # check arguments
  if(NOT __bottle_tgt_NAME)
    # NAME not defined or empty
    message(FATAL_ERROR "[bottle] creating FlatBuffers target: must provide a NAME")
  elseif(NOT __bottle_tgt_FBS)
    # NAME defined as non-empty but FBS not defined or empty
    message(FATAL_ERROR "[bottle] creating FlatBuffers target: must provide FBS for ${__bottle_tgt_NAME}")
  endif()

  string(JOIN "+" __bottle_tgt_name_ ${BOTTLE_PACKAGE_NAME} ${__bottle_tgt_NAME})
  _bottle_expand_deps(__bottle_tgt_fbs_ "@flatbuffers")
  _bottle_compile_fbs(__bottle_tgt_hdrs_ ${__bottle_tgt_FBS})

  add_library(${__bottle_tgt_name_} INTERFACE ${__bottle_tgt_hdrs_})
  target_include_directories(${__bottle_tgt_name_} INTERFACE ${PROJECT_BINARY_DIR})
  target_link_libraries(${__bottle_tgt_name_} INTERFACE ${__bottle_tgt_fbs_})

  # link to current package if exists
  if(NOT __bottle_tgt_XCLD)
    _bottle_try_link_package(${__bottle_tgt_name_})
  endif()

  message(VERBOSE "[bottle] FlatBuffers target with name ${__bottle_tgt_name_}")
endfunction(bottle_fbs)
