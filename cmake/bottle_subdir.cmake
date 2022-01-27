include(cmake/internal/_bottle_try_link_package)

function(bottle_subdir)
  # parse arguments
  cmake_parse_arguments(__bottle_tgt "XCLD" "NAME" "" ${ARGN})

  if(NOT __bottle_tgt_NAME)
    # NAME not defined or empty
    message(FATAL_ERROR "[bottle] adding subdirectory fails: must provide a NAME")
  endif()

  add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/${__bottle_tgt_NAME})

  string(REPLACE "/" "." __bottle_tgt_NAME ${__bottle_tgt_NAME})
  string(JOIN "." __bottle_tgt_name_ ${BOTTLE_PACKAGE_NAME} ${__bottle_tgt_NAME})

  # link to current package if exists
  if(NOT __bottle_tgt_XCLD)
    _bottle_try_link_package(${__bottle_tgt_name_})
  endif()

  message(VERBOSE "[bottle] add subdirectory with name ${__bottle_tgt_name_}")
endfunction(bottle_subdir)
