; Variables (most generic — applied first, overridden by later patterns)
(identifier) @variable

; Punctuation
["(" ")" "[" "]" "{" "}"] @punctuation.bracket
["," ";" "."] @punctuation.delimiter
"..." @punctuation.delimiter

; Operators
["=" ":="
 "+=" "-=" "*=" "/=" "%="
 "&=" "|=" "^=" "&^=" "<<=" ">>="
 "+" "-" "*" "/" "%"
 "&" "|" "^" "&^" "<<" ">>"
 "==" "!=" "<" ">" "<=" ">="
 "&&" "||" "!" "++" "--"] @operator
(ternary_expression ["?" ":"] @operator)

; Keywords
["if" "else" "for" "in" "return" "var" "func" "export"] @keyword
(import_expression "import" @keyword)
(break_statement) @keyword
(continue_statement) @keyword

; Literals
(boolean) @boolean
(undefined) @constant.builtin
(int_literal) @number
(float_literal) @number
(string_literal) @string
(raw_string_literal) @string
(char_literal) @string
(escape_sequence) @string.escape
(comment) @comment

; Properties (selector fields, map keys)
(selector_expression field: (identifier) @property)
(map_entry key: (identifier) @property)

; Parameters
(parameter_list (identifier) @variable.parameter)
(variadic_parameter (identifier) @variable.parameter)

; Function definitions
(var_declaration
  name: (identifier) @function.definition
  value: (func_literal))
(assignment_statement
  left: (identifier) @function.definition
  right: (func_literal))

; Function calls (generic)
(call_expression
  function: (identifier) @function)

; Built-in function calls (override generic)
((call_expression
  function: (identifier) @function.builtin)
 (#any-of? @function.builtin
   "len" "append" "copy" "delete" "splice" "type_name"
   "string" "int" "float" "char" "bool" "bytes" "error" "time"
   "is_string" "is_bool" "is_float" "is_char" "is_bytes"
   "is_error" "is_undefined" "is_function" "is_callable"
   "is_array" "is_immutable_array" "is_map" "is_iterable" "is_time"
   "print" "printf" "sprintf" "format"
   "to_json" "from_json"))

; Method calls (override @property for selector fields in call context)
(call_expression
  function: (selector_expression
    field: (identifier) @function))
