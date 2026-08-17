# Tema 1 — Recursión sobre listas, alcance y ligadura

Fundamentos de Interpretación y Compilación de Lenguajes de Programación
Escuela de Ingeniería de Sistemas y Computación, Universidad del Valle
Carlos Andrés Delgado Saavedra

Ejercicio de autoseguimiento del tema 1. No se califica y no hay que
entregarlo: las pruebas le dicen solas si va bien. Sirve para dejar Racket
funcionando y la recursión estructural practicada, que es como se escribe todo
lo que viene después en el curso.

Son seis puntos en dos mitades. Los cuatro primeros son recursión sobre listas
y salen de la sección 1.2 de *Essentials of Programming Languages*, tercera
edición, que es el libro del curso. Los dos últimos son alcance y ligadura de
variables sobre expresiones lambda, sección 1.2.4 del mismo libro. Los nombres
se dejaron en inglés, tal como aparecen allá, para que pueda buscarlos en el
texto.

## Cómo empezar

1. **Haga fork.** Botón *Fork* arriba a la derecha. El fork queda en su cuenta
   y usted trabaja ahí, no en este repositorio.

2. **Active las Actions.** Al hacer fork, GitHub deja los workflows apagados.
   Entre a la pestaña *Actions* de **su** fork y pulse el botón verde
   *I understand my workflows, go ahead and enable them*. Sin esto puede hacer
   todos los push que quiera y nunca se va a correr nada.

3. **Clone su fork** y ábralo en DrRacket:

   ```bash
   git clone https://github.com/SU-USUARIO/flp-2026-2-tema-01-recursion-y-ligadura.git
   cd flp-2026-2-tema-01-recursion-y-ligadura
   ```

4. **Resuelva** los seis puntos en `src/listas.rkt`.

5. **Haga push.** Cada push dispara las pruebas y en la pestaña *Actions* queda
   el chulo verde o la equis roja.

## Cómo está organizado

```
src/listas.rkt              el código que usted escribe
pruebas/listas-pruebas.rkt  las pruebas, que no se modifican
verificar/reglas.rkt        revisa las reglas del curso sobre su código
```

Si necesita instalar Racket, se baja de [racket-lang.org](https://racket-lang.org).
Instale la distribución completa: la versión mínima no trae `#lang eopl` y nada
de esto va a compilar.

## Cómo se ejecutan las pruebas

Desde la raíz del repositorio:

```bash
raco test pruebas/
racket verificar/reglas.rkt
```

O desde DrRacket, abriendo `pruebas/listas-pruebas.rkt` y pulsando *Ejecutar*.

## El punto de partida

Al clonar hay 35 pruebas: 2 en verde y 33 en rojo. Las dos verdes son las del
ejemplo resuelto, y que pasen significa que Racket y `eopl` quedaron bien
instalados. Las otras 33 están en rojo porque las seis funciones dicen
`eopl:error 'sin-implementar`. Su trabajo es reemplazar cada una de esas
líneas y ver las pruebas ponerse en verde.

## Las reglas

- Recursión estructural sobre la lista. Nada de `for` ni de bucles.
- Sin `set!` ni ninguna otra asignación destructiva.
- `reverse`, `filter`, `flatten` y `append*` quedan descartadas: resuelven el
  ejercicio de un golpe y lo que se está practicando es escribir la recursión.
  `null?`, `car`, `cdr`, `cons`, `append`, `equal?` y `eqv?` sí se usan.
- Nada de `eval` ni de expandir el código con las herramientas de Racket: en
  los puntos 5 y 6 la respuesta se calcula recorriendo la expresión.

`racket verificar/reglas.rkt` revisa estas reglas sobre su código y le dice
qué falta. Lee el archivo como datos, así que un comentario que diga `set!` no
cuenta como uso de `set!`, y su propio `flatten` tampoco cuenta como el de la
biblioteca.

## Recursión sobre listas

### 1. `invert`

Recibe una lista de listas de dos elementos y devuelve otra donde cada par
quedó al revés.

```racket
(invert '((a 1) (a 2) (1 b) (2 b)))  ; => ((1 a) (2 a) (b 1) (b 2))
```

### 2. `filter-in`

Devuelve los elementos que satisfacen el predicado, en el orden en que venían.

```racket
(filter-in number? '(a 2 (1 3) b 7))   ; => (2 7)
(filter-in symbol? '(a (b c) 17 foo))  ; => (a foo)
```

### 3. `count-occurrences`

Cuenta cuántas veces aparece un símbolo, mirando también dentro de las
sublistas.

```racket
(count-occurrences 'x '((f x) y (((x z) x))))  ; => 3
```

Una *s-list* es una lista cuyos elementos son símbolos u otras s-lists. La
recursión se abre en dos: por el `car`, que puede ser una lista, y por el
`cdr`, que siempre lo es. Esa forma de doble recursión reaparece en el curso
cada vez que aparezca un árbol.

### 4. `flatten`

Devuelve los símbolos de la s-list en orden, sin las sublistas que los
envolvían.

```racket
(flatten '((a b) c (((d)) e)))     ; => (a b c d e)
(flatten '((a) () (b ()) () (c)))  ; => (a b c)
```

El segundo ejemplo es el que separa una solución que funciona de una que casi
funciona. Piense qué pasa cuando el `car` es la lista vacía.

## Alcance y ligadura

Los dos puntos que siguen trabajan sobre expresiones del cálculo lambda con la
gramática de la sección 1.2.4 de EOPL:

```text
LcExp ::= Identifier
      ::= (lambda (Identifier) LcExp)
      ::= (LcExp LcExp)
```

En listas de Scheme son tres formas: un símbolo como `'x`, una abstracción
como `'(lambda (x) e)` y una aplicación como `'(e1 e2)`. La recursión tiene
entonces tres casos, uno por producción, igual que en los puntos anteriores
solo que ahora la lista representa un programa.

Una variable está ligada donde la alcanza un lambda que la declara, y libre
donde no. A la misma variable pueden pasarle las dos cosas en la misma
expresión: en `'((lambda (x) x) x)` la `x` del cuerpo la liga el lambda y la
`x` del argumento no la liga nadie, así que ahí `x` aparece libre y ligada al
tiempo. Ese es el caso que hay que tener claro antes de escribir el código.

Las dos funciones reciben primero la expresión y después la variable, igual que
en la nota de clase y que el ejercicio del tema 2. EOPL las escribe con los
argumentos en el otro orden, así que si trabaja con el libro al lado tenga
presente el cambio. Ojo también con el punto 3: `count-occurrences` recibe
primero el símbolo.

### 5. `occurs-free?`

`occurs-free? : LcExp × Sym -> Bool`. Dice si la variable aparece libre en la
expresión. La definición de EOPL, sección 1.2.4, va por los tres casos de la
gramática: en un identificador es libre si es esa misma variable; en
`(lambda (y) cuerpo)` es libre si la variable no es `y` y aparece libre en el
cuerpo; en `(e1 e2)` es libre si aparece libre en alguna de las dos.

```racket
(occurs-free? 'x 'x)                   ; => #t
(occurs-free? '(lambda (x) (x y)) 'x)  ; => #f
(occurs-free? '(lambda (y) (x y)) 'x)  ; => #t
(occurs-free? '((lambda (x) x) x) 'x)  ; => #t
```

### 6. `occurs-bound?`

`occurs-bound? : LcExp × Sym -> Bool`. Dice si la variable aparece ligada, es
decir si hay una ocurrencia suya dentro del cuerpo de un lambda que la
declara. Un identificador solo nunca está ligado. En `(lambda (y) cuerpo)` lo
está si ya lo estaba dentro del cuerpo, o si `y` es la variable y esta aparece
libre en el cuerpo: eso es justamente lo que liga ese lambda. En `(e1 e2)`, si
lo está en alguna de las dos.

```racket
(occurs-bound? 'x 'x)                   ; => #f
(occurs-bound? '(lambda (x) x) 'x)      ; => #t
(occurs-bound? '(lambda (x) y) 'x)      ; => #f
(occurs-bound? '((lambda (x) x) x) 'x)  ; => #t
```

El tercer ejemplo es el que decide si entendió la definición: el lambda liga
`x`, pero en el cuerpo no hay ninguna ocurrencia de `x` que ligar. Y fíjese
que `occurs-bound?` no es la negación de `occurs-free?`: el último ejemplo
responde `#t` en las dos.
