include(cmake/internal/_bottle_expand_deps)
include(cmake/internal/_bottle_generate_cfgs)
include(cmake/internal/_bottle_populate_srcs)
include(cmake/internal/_bottle_try_link_package)

function(bottle_library)
  # parse arguments
  cmake_parse_arguments(__bottle_tgt "XCLD" "NAME" "SRCS;HDRS;CFGS;DEPS;FEAT;OPTS;DEFS" ${ARGN})

  if(NOT __bottle_tgt_NAME)
    # NAME not defined or empty
    message(FATAL_ERROR "[bottle] creating library target fails: must provide a NAME")
  endif()

  string(JOIN "+" __bottle_tgt_name_ ${BOTTLE_PACKAGE_NAME} ${__bottle_tgt_NAME})
  _bottle_expand_deps(__bottle_tgt_deps_ ${__bottle_tgt_DEPS})
  _bottle_populate_srcs(__bottle_tgt_srcs_ ${__bottle_tgt_SRCS})
  _bottle_populate_srcs(__bottle_tgt_hdrs_ ${__bottle_tgt_HDRS})
  _bottle_generate_cfgs(__bottle_tgt_cfgs_ ${__bottle_tgt_CFGS})

  # add library target by add_library
  if(__bottle_tgt_srcs_)
    # add a shared library target
    set(__bottle_tgt_transcope_ PUBLIC)
    add_library(${__bottle_tgt_name_} SHARED)
    target_sources(${__bottle_tgt_name_}
      PRIVATE ${__bottle_tgt_srcs_}
      PUBLIC  ${__bottle_tgt_hdrs_} ${__bottle_tgt_cfgs_})
  else()
    # add a header-only library target
    set(__bottle_tgt_transcope_ INTERFACE)
    add_library(${__bottle_tgt_name_} INTERFACE)
    target_sources(${__bottle_tgt_name_} INTERFACE ${__bottle_tgt_hdrs_} ${__bottle_tgt_cfgs_})
  endif()

  if(__bottle_tgt_transcope_)
    if(__bottle_tgt_FEAT)
      target_compile_features(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${__bottle_tgt_FEAT})
    else()
      # FEAT not defined or empty
      target_compile_features(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} cxx_std_17)
    endif()

    target_compile_options(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${__bottle_tgt_OPTS})
    target_compile_definitions(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${__bottle_tgt_DEFS})

    target_include_directories(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${PROJECT_SOURCE_DIR})
    if(__bottle_tgt_cfgs_)
      target_include_directories(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${PROJECT_BINARY_DIR})
    endif()

    target_link_libraries(${__bottle_tgt_name_} ${__bottle_tgt_transcope_} ${__bottle_tgt_deps_})
  endif()

  # link to current package if exists
  if(NOT __bottle_tgt_XCLD)
    _bottle_try_link_package(${__bottle_tgt_name_})
  endif()

  message(VERBOSE "[bottle] create library target with name ${__bottle_tgt_name_}")
endfunction(bottle_library)
