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

; Map-literal constants / schemas (e.g. _DATA_INFO_SCHEMA := { ... })
(var_declaration
  name: (identifier) @name
  value: (map_literal)) @item

(assignment_statement
  left: (identifier) @name
  right: (map_literal)) @item

; Method-like entries inside a map literal (builder objects, export maps):
;   foo: func(...) { ... }
; Picking up the `func` keyword as context gives them the same colored prefix
; as top-level functions.
(map_entry
  key: (identifier) @name
  value: (func_literal
    "func" @context)) @item

; Export block
(export_statement
  "export" @context) @item
