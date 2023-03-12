include(cmake/internal/_bottle_expand_deps)

function(_bottle_compile_msgs _bottle_compiled_srcs_ _bottle_compiled_hdrs_)
  _bottle_expand_deps(__protoc_ "@protoc")

  foreach(__msg_ IN LISTS ARGN)
    get_filename_component(__msg_ext_ ${__msg_} LAST_EXT)
    string(REGEX REPLACE "^(.+)\\${__msg_ext_}" "\\1" __msg_name_ ${__msg_})

    add_custom_command(
      COMMAND $<TARGET_FILE:${__protoc_}>
      ARGS    --proto_path=${PROJECT_SOURCE_DIR}
              --cpp_out=${PROJECT_BINARY_DIR}
              ${CMAKE_CURRENT_LIST_DIR}/${__msg_}
      OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${__msg_name_}.pb.cc
              ${CMAKE_CURRENT_BINARY_DIR}/${__msg_name_}.pb.h
      DEPENDS ${CMAKE_CURRENT_LIST_DIR}/${__msg_})

    list(APPEND ${_bottle_compiled_srcs_} ${CMAKE_CURRENT_BINARY_DIR}/${__msg_name_}.pb.cc)
    list(APPEND ${_bottle_compiled_hdrs_} ${CMAKE_CURRENT_BINARY_DIR}/${__msg_name_}.pb.h)
  endforeach()

  set(${_bottle_compiled_srcs_} ${${_bottle_compiled_srcs_}} PARENT_SCOPE)
  set(${_bottle_compiled_hdrs_} ${${_bottle_compiled_hdrs_}} PARENT_SCOPE)
endfunction(_bottle_compile_msgs)
