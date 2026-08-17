#lang eopl

;; Tema 1 — Recursión sobre listas, alcance y ligadura
;; Fundamentos de Interpretación y Compilación de Lenguajes de Programación
;; Universidad del Valle, sede Tuluá
;;
;; Escriba aquí las seis funciones. No modifique la carpeta pruebas/.
;;
;; Los puntos 1 a 4 son recursión estructural sobre listas y s-lists. Los
;; puntos 5 y 6 son la otra mitad del tema: alcance y ligadura de variables,
;; sobre expresiones lambda representadas como listas de Scheme.
;;
;; Reglas del curso que aplican desde esta primera sesión:
;;   - recursión estructural sobre la lista, nada de bucles;
;;   - sin `set!` ni ninguna otra asignación destructiva;
;;   - las funciones de la biblioteca que resuelven el ejercicio de un golpe
;;     (`reverse`, `filter`, `flatten`, `append*`) quedan descartadas: lo que
;;     se está practicando es escribir la recursión, no encontrar quién la
;;     escribió por uno;
;;   - nada de `eval` ni de expandir el código con las herramientas de Racket:
;;     la respuesta de los puntos 5 y 6 se calcula recorriendo la expresión.

(provide ejemplo-duple invert filter-in count-occurrences flatten
         occurs-free? occurs-bound?)

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

;; ---------------------------------------------------------------------------
;; Alcance y ligadura
;;
;; Los dos puntos que siguen trabajan sobre expresiones del cálculo lambda con
;; la gramática de la sección 1.2.4 de EOPL:
;;
;;   LcExp ::= Identifier
;;         ::= (lambda (Identifier) LcExp)
;;         ::= (LcExp LcExp)
;;
;; En listas de Scheme son tres formas: un símbolo, `(lambda (x) cuerpo)` y
;; `(e1 e2)`. La recursión tiene entonces tres casos, uno por producción, y en
;; cada uno se pregunta lo mismo a las subexpresiones.
;;
;;   '(lambda (x) (x y))          una abstracción: liga x, y queda suelta
;;   '((lambda (x) x) x)          una aplicación de una abstracción a x
;;
;; Una variable está ligada donde un lambda que la declara la alcanza, y libre
;; donde no. Las dos cosas pueden pasarle a la misma variable en la misma
;; expresión: en `((lambda (x) x) x)` la primera x está ligada por el lambda y
;; la segunda, la del argumento, no la alcanza ningún lambda.

;; ---------------------------------------------------------------------------
;; Punto 5
;;
;; occurs-free? : Sym × LcExp -> Bool
;; Dice si la variable aparece libre en la expresión, es decir si hay una
;; ocurrencia suya que ningún lambda liga. La definición de EOPL, sección
;; 1.2.4, va por los tres casos de la gramática:
;;
;;   - la expresión es un identificador: libre si es esa misma variable;
;;   - es `(lambda (y) cuerpo)`: libre si la variable no es y y aparece libre
;;     en el cuerpo, porque el lambda liga y y solo a y;
;;   - es `(e1 e2)`: libre si aparece libre en e1 o en e2.
;;
;; (occurs-free? 'x 'x)                       =>  #t
;; (occurs-free? 'x '(lambda (x) (x y)))      =>  #f
;; (occurs-free? 'x '(lambda (y) (x y)))      =>  #t
;; (occurs-free? 'x '((lambda (x) x) x))      =>  #t

(define occurs-free?
  (lambda (var exp)
    (eopl:error 'occurs-free? "sin implementar")))

;; ---------------------------------------------------------------------------
;; Punto 6
;;
;; occurs-bound? : Sym × LcExp -> Bool
;; Dice si la variable aparece ligada en la expresión, es decir si hay una
;; ocurrencia suya dentro del cuerpo de un lambda que la declara. Los tres
;; casos otra vez:
;;
;;   - un identificador solo nunca está ligado: no hay lambda alrededor;
;;   - en `(lambda (y) cuerpo)` está ligada si ya lo estaba dentro del cuerpo,
;;     o si y es la variable y esta aparece libre en el cuerpo, que es
;;     justamente lo que este lambda liga;
;;   - en `(e1 e2)` está ligada si lo está en e1 o en e2.
;;
;; El segundo caso es el que separa las dos funciones: `(lambda (x) y)` liga x
;; pero no la usa en ninguna parte, así que x no aparece ligada ahí.
;;
;; (occurs-bound? 'x 'x)                      =>  #f
;; (occurs-bound? 'x '(lambda (x) x))         =>  #t
;; (occurs-bound? 'x '(lambda (x) y))         =>  #f
;; (occurs-bound? 'x '((lambda (x) x) x))     =>  #t

(define occurs-bound?
  (lambda (var exp)
    (eopl:error 'occurs-bound? "sin implementar")))
