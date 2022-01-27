include(cmake/internal/_bottle_expand_dep)

function(_bottle_expand_deps _bottle_expanded_deps_)
  foreach(__dep_ IN LISTS ARGN)
    _bottle_expand_dep(__dep_ ${__dep_})
    list(APPEND ${_bottle_expanded_deps_} ${__dep_})
  endforeach()
  set(${_bottle_expanded_deps_} ${${_bottle_expanded_deps_}} PARENT_SCOPE)
endfunction(_bottle_expand_deps)
