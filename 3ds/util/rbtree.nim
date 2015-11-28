template rbtree_item*(`ptr`, `type`, member: expr): expr =
  (cast[ptr `type`](((cast[cstring](`ptr`)) - offsetof(`type`, member))))

type
  rbtree_t* = rbtree
  rbtree_node_t* = rbtree_node
  rbtree_node_destructor_t* = proc (Node: ptr rbtree_node_t) {.cdecl.}
  rbtree_node_comparator_t* = proc (lhs: ptr rbtree_node_t; rhs: ptr rbtree_node_t): cint {.
      cdecl.}
  rbtree_node* {.importc: "rbtree_node", header: "rbtree.h".} = object
    parent_color* {.importc: "parent_color".}: uintptr_t
    child* {.importc: "child".}: array[2, ptr rbtree_node_t]

  rbtree* {.importc: "rbtree", header: "rbtree.h".} = object
    root* {.importc: "root".}: ptr rbtree_node_t
    comparator* {.importc: "comparator".}: rbtree_node_comparator_t
    size* {.importc: "size".}: csize


proc rbtree_init*(tree: ptr rbtree_t; comparator: rbtree_node_comparator_t) {.cdecl,
    importc: "rbtree_init", header: "rbtree.h".}
proc rbtree_empty*(tree: ptr rbtree_t): cint {.cdecl, importc: "rbtree_empty",
    header: "rbtree.h".}
proc rbtree_size*(tree: ptr rbtree_t): csize {.cdecl, importc: "rbtree_size",
    header: "rbtree.h".}
proc rbtree_insert*(tree: ptr rbtree_t; node: ptr rbtree_node_t): ptr rbtree_node_t {.
    cdecl, importc: "rbtree_insert", header: "rbtree.h".}
proc rbtree_insert_multi*(tree: ptr rbtree_t; node: ptr rbtree_node_t) {.cdecl,
    importc: "rbtree_insert_multi", header: "rbtree.h".}
proc rbtree_find*(tree: ptr rbtree_t; node: ptr rbtree_node_t): ptr rbtree_node_t {.
    cdecl, importc: "rbtree_find", header: "rbtree.h".}
proc rbtree_min*(tree: ptr rbtree_t): ptr rbtree_node_t {.cdecl, importc: "rbtree_min",
    header: "rbtree.h".}
proc rbtree_max*(tree: ptr rbtree_t): ptr rbtree_node_t {.cdecl, importc: "rbtree_max",
    header: "rbtree.h".}
proc rbtree_node_next*(node: ptr rbtree_node_t): ptr rbtree_node_t {.cdecl,
    importc: "rbtree_node_next", header: "rbtree.h".}
proc rbtree_node_prev*(node: ptr rbtree_node_t): ptr rbtree_node_t {.cdecl,
    importc: "rbtree_node_prev", header: "rbtree.h".}
proc rbtree_remove*(tree: ptr rbtree_t; node: ptr rbtree_node_t;
                   destructor: rbtree_node_destructor_t): ptr rbtree_node_t {.cdecl,
    importc: "rbtree_remove", header: "rbtree.h".}
proc rbtree_clear*(tree: ptr rbtree_t; destructor: rbtree_node_destructor_t) {.cdecl,
    importc: "rbtree_clear", header: "rbtree.h".}