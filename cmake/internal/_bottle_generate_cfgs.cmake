function(_bottle_generate_cfgs _bottle_generated_cfgs_)
  foreach(__cfg_ IN LISTS ARGN)
    get_filename_component(__cfg_ext_ ${__cfg_} LAST_EXT)
    string(REGEX REPLACE "^(.+)\\${__cfg_ext_}" "\\1" __cfg_name_ ${__cfg_})

    configure_file(${CMAKE_CURRENT_LIST_DIR}/${__cfg_} ${CMAKE_CURRENT_BINARY_DIR}/${__cfg_name_})
    list(APPEND ${_bottle_generated_cfgs_} ${CMAKE_CURRENT_BINARY_DIR}/${__cfg_name_})
  endforeach()
  set(${_bottle_generated_cfgs_} ${${_bottle_generated_cfgs_}} PARENT_SCOPE)
endfunction(_bottle_generate_cfgs)
