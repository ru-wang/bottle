include(cmake/internal/_bottle_expand_deps)

function(_bottle_compile_fbs _bottle_compiled_hdrs_)
  _bottle_expand_deps(__flatc_ "@flatc")

  foreach(__fbs_ IN LISTS ARGN)
    get_filename_component(__fbs_ext_ ${__fbs_} LAST_EXT)
    string(REGEX REPLACE "^(.+)\\${__fbs_ext_}" "\\1" __fbs_name_ ${__fbs_})

    add_custom_command(
      COMMAND $<TARGET_FILE:${__flatc_}>
      ARGS    --cpp --cpp-std c++17 --keep-prefix
              -I ${PROJECT_SOURCE_DIR}
              -o ${CMAKE_CURRENT_BINARY_DIR}
              ${CMAKE_CURRENT_LIST_DIR}/${__fbs_}
      OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${__fbs_name_}_generated.h
      DEPENDS ${CMAKE_CURRENT_LIST_DIR}/${__fbs_})

    list(APPEND ${_bottle_compiled_hdrs_} ${CMAKE_CURRENT_BINARY_DIR}/${__fbs_name_}_generated.h)
  endforeach()

  set(${_bottle_compiled_hdrs_} ${${_bottle_compiled_hdrs_}} PARENT_SCOPE)
endfunction(_bottle_compile_fbs)
