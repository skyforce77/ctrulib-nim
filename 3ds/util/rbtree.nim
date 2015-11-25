template rbtree_item*(`ptr`, `type`, member: expr): expr =
  (cast[ptr `type`](((cast[cstring](`ptr`)) - offsetof(`type`, member))))

type
  rbtree_t* = rbtree
  rbtree_node_t* = rbtree_node
  rbtree_node_destructor_t* = proc (Node: ptr rbtree_node_t)
  rbtree_node_comparator_t* = proc (lhs: ptr rbtree_node_t; rhs: ptr rbtree_node_t): cint
  rbtree_node* = object
    parent_color*: uintptr_t
    child*: array[2, ptr rbtree_node_t]

  rbtree* = object
    root*: ptr rbtree_node_t
    comparator*: rbtree_node_comparator_t
    size*: csize


proc rbtree_init*(tree: ptr rbtree_t; comparator: rbtree_node_comparator_t)
proc rbtree_empty*(tree: ptr rbtree_t): cint
proc rbtree_size*(tree: ptr rbtree_t): csize
proc rbtree_insert*(tree: ptr rbtree_t; node: ptr rbtree_node_t): ptr rbtree_node_t
proc rbtree_insert_multi*(tree: ptr rbtree_t; node: ptr rbtree_node_t)
proc rbtree_find*(tree: ptr rbtree_t; node: ptr rbtree_node_t): ptr rbtree_node_t
proc rbtree_min*(tree: ptr rbtree_t): ptr rbtree_node_t
proc rbtree_max*(tree: ptr rbtree_t): ptr rbtree_node_t
proc rbtree_node_next*(node: ptr rbtree_node_t): ptr rbtree_node_t
proc rbtree_node_prev*(node: ptr rbtree_node_t): ptr rbtree_node_t
proc rbtree_remove*(tree: ptr rbtree_t; node: ptr rbtree_node_t;
                   destructor: rbtree_node_destructor_t): ptr rbtree_node_t
proc rbtree_clear*(tree: ptr rbtree_t; destructor: rbtree_node_destructor_t)