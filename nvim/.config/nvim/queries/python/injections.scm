;extends

; CUDA injection
(
(comment) @com (#match? @com "# ?\\@cuda")
(expression_statement
  (assignment
    left: (identifier)
    right: (string
             (string_start)
             (string_content) @injection.content
             (string_end))))
    (#set! injection.language "cuda")
)
