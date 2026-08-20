; extends

; Match C++ loop keywords to `if`'s conditional-keyword color. Keep the
; priority above the inherited C++ query's `@keyword.repeat` captures.
((for_statement "for" @keyword.conditional)
  (#set! priority 130))

((while_statement "while" @keyword.conditional)
  (#set! priority 130))

; Standard streams should not look like ordinary local variables.
((identifier) @variable.stream
  (#any-of? @variable.stream "cin" "cout" "cerr" "clog")
  (#set! priority 130))

; In `visited[u]`, distinguish the indexed container from its index variable.
((subscript_expression
  argument: (identifier) @variable.container)
  (#set! priority 130))

; Color variables declared from vector, array, and other template/container
; types. The function_declarator case covers declarations such as `v(n)`.
(declaration
  type: [
    (template_type)
    (qualified_identifier
      name: (template_type))
  ]
  declarator: [
    (identifier) @variable.container
    (init_declarator
      declarator: (identifier) @variable.container)
    (function_declarator
      declarator: (identifier) @variable.container)
  ]
  (#set! priority 130))

; Raw C/C++ arrays such as `int arr[10]` are containers too.
((array_declarator
  declarator: (identifier) @variable.container)
  (#set! priority 130))
