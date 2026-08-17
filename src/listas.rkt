#lang eopl

;; Clase 1 — Recursión sobre listas
;; Fundamentos de Interpretación y Compilación de Lenguajes de Programación
;; Universidad del Valle, sede Tuluá
;;
;; Escriba aquí las cuatro funciones. No modifique la carpeta pruebas/.
;;
;; Reglas del curso que aplican desde esta primera sesión:
;;   - recursión estructural sobre la lista, nada de bucles;
;;   - sin `set!` ni ninguna otra asignación destructiva;
;;   - las funciones de la biblioteca que resuelven el ejercicio de un golpe
;;     (`reverse`, `filter`, `flatten`, `append*`) quedan descartadas: lo que
;;     se está practicando es escribir la recursión, no encontrar quién la
;;     escribió por uno.

(provide ejemplo-duple invert filter-in count-occurrences flatten)

;; ---------------------------------------------------------------------------
;; Ejemplo resuelto: así se ve una recursión estructural sobre un número
;;
;; duple : Int × A -> (List A)
;; (ejemplo-duple 3 'a)   =>  (a a a)
;; (ejemplo-duple 0 'a)   =>  ()
;;
;; El caso base es el cero y el caso recursivo baja de uno en uno hasta él.
;; Sus cuatro funciones tienen la misma forma, salvo que descienden por una
;; lista en vez de por un número.

(define ejemplo-duple
  (lambda (n x)
    (if (zero? n)
        '()
        (cons x (ejemplo-duple (- n 1) x)))))

;; ---------------------------------------------------------------------------
;; Punto 1
;;
;; invert : (List (List A B)) -> (List (List B A))
;; Recibe una lista de listas de dos elementos y devuelve otra donde cada par
;; quedó al revés.
;;
;; (invert '((a 1) (a 2) (1 b) (2 b)))  =>  ((1 a) (2 a) (b 1) (b 2))
;; (invert '())                         =>  ()

(define invert
  (lambda (lst)
    (eopl:error 'invert "sin implementar")))

;; ---------------------------------------------------------------------------
;; Punto 2
;;
;; filter-in : (A -> Bool) × (List A) -> (List A)
;; Devuelve los elementos de la lista que satisfacen el predicado, en el mismo
;; orden en que venían.
;;
;; (filter-in number? '(a 2 (1 3) b 7))       =>  (2 7)
;; (filter-in symbol? '(a (b c) 17 foo))      =>  (a foo)

(define filter-in
  (lambda (pred lst)
    (eopl:error 'filter-in "sin implementar")))

;; ---------------------------------------------------------------------------
;; Punto 3
;;
;; count-occurrences : Sym × S-list -> Int
;; Cuenta cuántas veces aparece el símbolo, mirando también dentro de las
;; sublistas. Una s-list es una lista cuyos elementos son símbolos u otras
;; s-lists.
;;
;; (count-occurrences 'x '((f x) y (((x z) x))))  =>  3
;; (count-occurrences 'w '((f x) y (((x z) x))))  =>  0
;;
;; Aquí la recursión se abre en dos: por el `car`, que puede ser una lista, y
;; por el `cdr`, que siempre lo es.

(define count-occurrences
  (lambda (s slist)
    (eopl:error 'count-occurrences "sin implementar")))

;; ---------------------------------------------------------------------------
;; Punto 4
;;
;; flatten : S-list -> (List Sym)
;; Devuelve los símbolos de la s-list en el orden en que aparecen, sin ninguna
;; de las sublistas que los envolvían.
;;
;; (flatten '(a b c))                      =>  (a b c)
;; (flatten '((a) () (b ()) () (c)))       =>  (a b c)
;; (flatten '((a b) c (((d)) e)))          =>  (a b c d e)

(define flatten
  (lambda (slist)
    (eopl:error 'flatten "sin implementar")))
