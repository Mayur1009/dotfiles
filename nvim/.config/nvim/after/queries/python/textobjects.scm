;extends

(
(comment) @content1
(#match? @content1 "^\\# ?\\%\\%") 
) @class.outer

; (
;  (comment) @_start (#match? @_start "^\\# ?\\%\\%")
;  (_)*
;  (_) @_in2 .
;  (comment) @_end (#match? @_end "^\\# ?\\%\\%")
;  (#make-range! "code_cell.inner" @_start @_in2)
;  (#make-range! "code_cell.outer" @_start @_end)
; )
