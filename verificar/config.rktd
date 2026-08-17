;; Reglas del tema 1. Cada entrada la lee verificar/reglas.rkt.
((archivos "src/listas.rkt")
 (prohibidos set! set-car! set-cdr! reverse filter flatten append*
             for for/list for/fold do while
             eval expand))
