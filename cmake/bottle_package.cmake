function(bottle_package)
  # parse arguments
  cmake_parse_arguments(__bottle_pkg "DEPS" "" "" ${ARGN})

  if(NOT __bottle_pkg_DEPS AND NOT BOTTLE_ROOT_PAKCAGE_NAME)
    set(__bottle_pkg_is_root_ TRUE)
  endif()

  if(__bottle_pkg_DEPS)
    string(JOIN "+" BOTTLE_PACKAGE_NAME ${PROJECT_NAME} "deps")
    set(BOTTLE_PACKAGE_NAME ${BOTTLE_PACKAGE_NAME} PARENT_SCOPE)
  else()
    file(RELATIVE_PATH __bottle_pkg_name_ ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_LIST_DIR})
    string(REPLACE "/" "." __bottle_pkg_name_ ${__bottle_pkg_name_})
    string(JOIN "+" BOTTLE_PACKAGE_NAME ${PROJECT_NAME} ${__bottle_pkg_name_})
    set(BOTTLE_PACKAGE_NAME ${BOTTLE_PACKAGE_NAME} PARENT_SCOPE)

    add_library(${BOTTLE_PACKAGE_NAME} INTERFACE)
    message(VERBOSE "[bottle] package target with name ${BOTTLE_PACKAGE_NAME}")
  endif()

  if (__bottle_pkg_is_root_)
    set(BOTTLE_ROOT_PAKCAGE_NAME ${BOTTLE_PACKAGE_NAME} PARENT_SCOPE)
    string(JOIN "::" __bottle_pkg_export_alias_ ${PROJECT_NAME} ${__bottle_pkg_name_})
    add_library(${__bottle_pkg_export_alias_} ALIAS ${BOTTLE_PACKAGE_NAME})

    message(VERBOSE "[bottle] root package target with name ${BOTTLE_PACKAGE_NAME}")
    message(VERBOSE "[bottle] export root package target alias ${__bottle_pkg_export_alias_}")
  endif()
endfunction(bottle_package)
