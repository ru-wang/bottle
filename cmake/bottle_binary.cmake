include(cmake/internal/_bottle_expand_deps)
include(cmake/internal/_bottle_generate_cfgs)
include(cmake/internal/_bottle_populate_srcs)

function(bottle_binary)
  # parse arguments
  cmake_parse_arguments(__bottle_tgt "" "NAME" "SRCS;HDRS;DEPS;OPTS;DEFS" ${ARGN})

  if(NOT __bottle_tgt_NAME)
    # NAME not defined or empty
    message(FATAL_ERROR "[bottle] creating binary target fails: must provide a NAME")
    if(NOT __bottle_tgt_SRCS AND NOT __bottle_tgt_DEPS)
      # neither SRCS or DEPS not defined or empty
      message(FATAL_ERROR "[bottle] creating binary target fails: must provide SRCS or DEPS for ${__bottle_tgt_NAME}")
    endif()
  endif()

  string(JOIN "+" __bottle_tgt_name_ ${BOTTLE_PACKAGE_NAME} ${__bottle_tgt_NAME})
  _bottle_expand_deps(__bottle_tgt_deps_ ${__bottle_tgt_DEPS})
  _bottle_populate_srcs(__bottle_tgt_srcs_ ${__bottle_tgt_SRCS})
  _bottle_populate_srcs(__bottle_tgt_hdrs_ ${__bottle_tgt_HDRS})

  # add binary target by add_executable
  if(__bottle_tgt_srcs_)
    # add a binary target
    set(__bottle_tgt_transcope_ PRIVATE)
    add_executable(${__bottle_tgt_name_})
    target_sources(${__bottle_tgt_name_} PRIVATE ${__bottle_tgt_srcs_} ${__bottle_tgt_hdrs_})
    set_target_properties(${__bottle_tgt_name_} PROPERTIES OUTPUT_NAME ${__bottle_tgt_NAME})
  else()
    # add a binary target alias
    add_executable(${__bottle_tgt_name_} ALIAS ${__bottle_tgt_deps_})
  endif()

  if(__bottle_tgt_transcope_)
    target_compile_features(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} cxx_std_17)
    target_compile_options(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${__bottle_tgt_OPTS})
    target_compile_definitions(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${__bottle_tgt_DEFS})

    target_include_directories(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${PROJECT_SOURCE_DIR})

    target_link_libraries(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${__bottle_tgt_deps_})
  endif()

  message(VERBOSE "[bottle] create binary target with name ${__bottle_tgt_name_}")
endfunction(bottle_binary)
