(var_declaration
  name: (identifier) @name
  value: (func_literal
    "func" @context)) @item

(assignment_statement
  left: (identifier) @name
  right: (func_literal
    "func" @context)) @item
