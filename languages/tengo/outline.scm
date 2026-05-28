; Functions: foo := func(...) { ... }
(var_declaration
  name: (identifier) @name
  value: (func_literal
    "func" @context)) @item

(assignment_statement
  left: (identifier) @name
  right: (func_literal
    "func" @context)) @item

; Imports: alias := import("...")
(var_declaration
  name: (identifier) @name
  value: (import_expression
    "import" @context)) @item

(assignment_statement
  left: (identifier) @name
  right: (import_expression
    "import" @context)) @item

; Map-literal constants / schemas at the top level (e.g. _DATA_INFO_SCHEMA := { ... })
(var_declaration
  name: (identifier) @name
  value: (map_literal)) @item

(assignment_statement
  left: (identifier) @name
  right: (map_literal)) @item

; Export block
(export_statement
  "export" @context) @item
