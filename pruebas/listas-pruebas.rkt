#lang racket

;; Pruebas del tema 1. No modifique este archivo.
;;
;; Se corren con `raco test pruebas/` desde la raíz del repositorio, y también
;; solas desde DrRacket abriendo este archivo y pulsando Ejecutar.

(require rackunit
         rackunit/text-ui
         "../src/listas.rkt")

;; Envuelve una llamada que todavía no está implementada para que la prueba
;; falle con un mensaje legible en vez de reventar la corrida entera.
(define-syntax-rule (verificar nombre esperado expresion)
  (test-case nombre
    (check-equal? (with-handlers ([exn:fail? (lambda (e) (list 'sin-implementar))])
                    expresion)
                  esperado)))

(define suite-entorno
  (test-suite
   "Entorno"
   (verificar "el ejemplo resuelto repite el símbolo tres veces"
              '(a a a) (ejemplo-duple 3 'a))
   (verificar "el ejemplo resuelto devuelve la lista vacía en cero"
              '() (ejemplo-duple 0 'a))))

(define suite-invert
  (test-suite
   "Punto 1 — invert"
   (verificar "lista vacía"
              '() (invert '()))
   (verificar "un solo par"
              '((1 a)) (invert '((a 1))))
   (verificar "el ejemplo del enunciado"
              '((1 a) (2 a) (b 1) (b 2))
              (invert '((a 1) (a 2) (1 b) (2 b))))
   (verificar "los pares pueden repetirse"
              '((x y) (x y)) (invert '((y x) (y x))))))

(define suite-filter-in
  (test-suite
   "Punto 2 — filter-in"
   (verificar "lista vacía"
              '() (filter-in number? '()))
   (verificar "se queda con los números"
              '(2 7) (filter-in number? '(a 2 (1 3) b 7)))
   (verificar "se queda con los símbolos"
              '(a foo) (filter-in symbol? '(a (b c) 17 foo)))
   (verificar "ninguno pasa el filtro"
              '() (filter-in number? '(a b c)))
   (verificar "todos pasan el filtro"
              '(1 2 3) (filter-in number? '(1 2 3)))))

(define suite-count-occurrences
  (test-suite
   "Punto 3 — count-occurrences"
   (verificar "lista vacía"
              0 (count-occurrences 'x '()))
   (verificar "el ejemplo del enunciado"
              3 (count-occurrences 'x '((f x) y (((x z) x)))))
   (verificar "el símbolo no aparece"
              0 (count-occurrences 'w '((f x) y (((x z) x)))))
   (verificar "en el primer nivel"
              2 (count-occurrences 'x '(x y x)))
   (verificar "anidado hasta el fondo"
              1 (count-occurrences 'x '(((((x)))))))))

(define suite-flatten
  (test-suite
   "Punto 4 — flatten"
   (verificar "lista vacía"
              '() (flatten '()))
   (verificar "ya venía plana"
              '(a b c) (flatten '(a b c)))
   (verificar "sublistas vacías por todas partes"
              '(a b c) (flatten '((a) () (b ()) () (c))))
   (verificar "anidamiento irregular"
              '(a b c d e) (flatten '((a b) c (((d)) e))))
   (verificar "solo listas vacías"
              '() (flatten '(() (()) ())))))

(define suite-occurs-free
  (test-suite
   "Punto 5 — occurs-free?"
   (verificar "la variable sola"
              #t (occurs-free? 'x 'x))
   (verificar "otra variable"
              #f (occurs-free? 'x 'y))
   (verificar "el lambda la liga"
              #f (occurs-free? 'x '(lambda (x) (x y))))
   (verificar "el lambda liga otra variable"
              #t (occurs-free? 'x '(lambda (y) (x y))))
   (verificar "libre en el operando de la aplicación"
              #t (occurs-free? 'x '((lambda (x) x) x)))
   (verificar "el lambda interior la oculta"
              #f (occurs-free? 'x '(lambda (y) (lambda (x) (x y)))))
   (verificar "libre en el fondo del anidamiento"
              #t (occurs-free? 'x '(lambda (y) (lambda (z) (x z)))))))

(define suite-occurs-bound
  (test-suite
   "Punto 6 — occurs-bound?"
   (verificar "una variable sola no está ligada"
              #f (occurs-bound? 'x 'x))
   (verificar "el lambda la liga y el cuerpo la usa"
              #t (occurs-bound? 'x '(lambda (x) x)))
   (verificar "el lambda la liga pero el cuerpo no la usa"
              #f (occurs-bound? 'x '(lambda (x) y)))
   (verificar "bajo un lambda que liga otra variable"
              #f (occurs-bound? 'x '(lambda (y) x)))
   (verificar "ligada en el operador de la aplicación"
              #t (occurs-bound? 'x '((lambda (x) x) x)))
   (verificar "la liga el lambda interior"
              #t (occurs-bound? 'x '(lambda (y) (lambda (x) (x y)))))
   (verificar "solo aparece como argumento"
              #f (occurs-bound? 'y '((lambda (x) x) y)))))

(module+ test
  (run-tests suite-entorno)
  (run-tests suite-invert)
  (run-tests suite-filter-in)
  (run-tests suite-count-occurrences)
  (run-tests suite-flatten)
  (run-tests suite-occurs-free)
  (run-tests suite-occurs-bound))
