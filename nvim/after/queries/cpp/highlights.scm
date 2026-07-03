; extends

; Types and class names
(type_identifier) @type

((type_identifier) @type
  (#set! priority 110))

(qualified_identifier
  (type_identifier) @type
  (#set! priority 110))

(class_specifier
  name: (type_identifier) @type.definition
  (#set! priority 110))

(struct_specifier
  name: (type_identifier) @type.definition
  (#set! priority 110))

(enum_specifier
  name: (type_identifier) @type.definition
  (#set! priority 110))

(alias_declaration
  name: (type_identifier) @type.definition
  (#set! priority 110))

(concept_definition
  name: (identifier) @type.definition
  (#set! priority 110))

((identifier) @constructor
  (#lua-match? @constructor "^[A-Z]$")
  (#set! priority 110))

; Namespaces
(namespace_definition
  name: (identifier) @module
  (#set! priority 110))

(namespace_alias_definition
  name: (identifier) @module
  (#set! priority 110))

(using_declaration
  .
  "using"
  .
  "namespace"
  .
  [
    (qualified_identifier)
    (identifier)
  ] @module
  (#set! priority 110))

((namespace_identifier) @module
  (#set! priority 110))

; Functions and methods
(function_declarator
  declarator: (identifier) @function
  (#set! priority 110))

(function_declarator
  declarator: (field_identifier) @function.method
  (#set! priority 110))

(function_declarator
  (qualified_identifier
    (identifier) @function)
  (#set! priority 110))

(function_declarator
  (qualified_identifier
    (qualified_identifier
      (identifier) @function))
  (#set! priority 110))

(call_expression
  function: (identifier) @function.call
  (#set! priority 110))

(call_expression
  function: (qualified_identifier
    (identifier) @function.call)
  (#set! priority 110))

(call_expression
  function: (qualified_identifier
    (qualified_identifier
      (identifier) @function.call))
  (#set! priority 110))

(call_expression
  function: (field_expression
    field: (field_identifier) @function.method.call)
  (#set! priority 110))

(call_expression
  function: (template_function
    (identifier) @function.call)
  (#set! priority 110))

; Fields and members
(field_declaration
  (field_identifier) @variable.member
  (#set! priority 110))

(field_expression
  field: (field_identifier) @variable.member
  (#set! priority 110))

(field_initializer
  (field_identifier) @property
  (#set! priority 110))

((field_identifier) @variable.member
  (#lua-match? @variable.member "^m_.*$")
  (#set! priority 110))
