; Functions: foo := func(...) { ... }
; @context is intentionally omitted so the outline shows just the name,
; matching the LSP's document outline (`builder` rather than `func builder`).
(var_declaration
  name: (identifier) @name
  value: (func_literal)) @item

(assignment_statement
  left: (identifier) @name
  right: (func_literal)) @item

; Imports: alias := import("...")
(var_declaration
  name: (identifier) @name
  value: (import_expression)) @item

(assignment_statement
  left: (identifier) @name
  right: (import_expression)) @item

; Map-literal constants / schemas (e.g. _DATA_INFO_SCHEMA := { ... })
(var_declaration
  name: (identifier) @name
  value: (map_literal)) @item

(assignment_statement
  left: (identifier) @name
  right: (map_literal)) @item

; Method-like entries inside a map literal (builder objects, export maps):
;   foo: func(...) { ... }
(map_entry
  key: (identifier) @name
  value: (func_literal)) @item

; Export block
(export_statement) @item
