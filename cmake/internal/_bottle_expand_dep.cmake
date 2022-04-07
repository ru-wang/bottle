function(_bottle_expand_dep _bottle_expanded_dep_ _bottle_dep_)
  # prefix `@' is used to mark external targets of current project
  if(_bottle_dep_ MATCHES "^@(.+)")
    # `@TARGET' expands to `${PROJECT_NAME}:deps:TARGET'
    string(REGEX REPLACE "^@(.+)" "${PROJECT_NAME}:deps:\\1" _bottle_dep_ ${_bottle_dep_})

  # prefix `///' is used to mark packages/targets built with other projects
  elseif(_bottle_dep_ MATCHES "^///(.+)")
    # `///PROJECT:PACKAGE[:TARGET]' expands to `PROJECT:PACKAGE[:TARGET]'
    string(REGEX REPLACE "^///(.+)" "\\1" _bottle_dep_ ${_bottle_dep_})

  # prefix `//' is used to mark packages/targets of current projects
  elseif(_bottle_dep_ MATCHES "^//(.+)")
    # `//PACKAGE[:TARGET]' expands to `${PROJECT_NAME}:PACKAGE[:TARGET]'
    string(REGEX REPLACE "^//(.+)" "${PROJECT_NAME}:\\1" _bottle_dep_ ${_bottle_dep_})

  # prefix `:' is used to mark targets within current package
  # prefix `/' is used to mark subpackages/targets within current package
  elseif(_bottle_dep_ MATCHES "^(:|/)(.+)")
    # `:TARGET' expands to `${PROJECT_NAME}:PACKAGE:TARGET'
    # `/SUBPACKAGE[:TARGET]' expands to `${PROJECT_NAME}:PACKAGE/SUBPACKAGE[:TARGET]'
    string(PREPEND _bottle_dep_ "${BOTTLE_PACKAGE_NAME}")
  endif()

  # replace `:' with `+' twice as there should be at most two `:'
  # use regex to avoid replacing `::'
  string(REGEX REPLACE "([^:]+):([^:]+)" "\\1+\\2" _bottle_dep_ ${_bottle_dep_})
  string(REGEX REPLACE "([^:]+):([^:]+)" "\\1+\\2" _bottle_dep_ ${_bottle_dep_})

  # replace all `/' with `.'
  string(REPLACE "/" "." _bottle_dep_ ${_bottle_dep_})

  set(${_bottle_expanded_dep_} ${_bottle_dep_} PARENT_SCOPE)
endfunction(_bottle_expand_dep)
