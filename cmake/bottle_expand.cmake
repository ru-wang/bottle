include(cmake/internal/_bottle_expand_dep)

function(bottle_expand _bottle_expanded_ _bottle_target_)
  _bottle_expand_dep(${_bottle_expanded_} ${_bottle_target_})
  set(${_bottle_expanded_} ${${_bottle_expanded_}} PARENT_SCOPE)
endfunction(bottle_expand)
