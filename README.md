# Tema 1 — Recursión sobre listas en Racket

Fundamentos de Interpretación y Compilación de Lenguajes de Programación
Escuela de Ingeniería de Sistemas y Computación, Universidad del Valle
Carlos Andrés Delgado Saavedra

Ejercicio de autoseguimiento del tema 1. No se califica y no hay que
entregarlo: las pruebas le dicen solas si va bien. Sirve para dejar Racket
funcionando y la recursión estructural practicada, que es como se escribe todo
lo que viene después en el curso.

Las cuatro funciones salen de la sección 1.2 de *Essentials of Programming
Languages*, tercera edición, que es el libro del curso. Los nombres se dejaron
en inglés, tal como aparecen allá, para que pueda buscarlas en el texto.

## Cómo empezar

1. **Haga fork.** Botón *Fork* arriba a la derecha. El fork queda en su cuenta
   y usted trabaja ahí, no en este repositorio.

2. **Active las Actions.** Al hacer fork, GitHub deja los workflows apagados.
   Entre a la pestaña *Actions* de **su** fork y pulse el botón verde
   *I understand my workflows, go ahead and enable them*. Sin esto puede hacer
   todos los push que quiera y nunca se va a correr nada.

3. **Clone su fork** y ábralo en DrRacket:

   ```bash
   git clone https://github.com/SU-USUARIO/flp-2026-2-tema-01-recursion-listas.git
   cd flp-2026-2-tema-01-recursion-listas
   ```

4. **Resuelva** los cuatro puntos en `src/listas.rkt`.

5. **Haga push.** Cada push dispara las pruebas y en la pestaña *Actions* queda
   el chulo verde o la equis roja.

## Cómo está organizado

```
src/listas.rkt              el código que usted escribe
pruebas/listas-pruebas.rkt  las pruebas, que no se modifican
```

Si necesita instalar Racket, se baja de [racket-lang.org](https://racket-lang.org).
Instale la distribución completa: la versión mínima no trae `#lang eopl` y nada
de esto va a compilar.

## Cómo se ejecutan las pruebas

Desde la raíz del repositorio:

```bash
raco test pruebas/
```

O desde DrRacket, abriendo `pruebas/listas-pruebas.rkt` y pulsando *Ejecutar*.

## El punto de partida

Al clonar hay 21 pruebas: 2 en verde y 19 en rojo. Las dos verdes son las del
ejemplo resuelto, y que pasen significa que Racket y `eopl` quedaron bien
instalados. Las otras 19 están en rojo porque las cuatro funciones dicen
`eopl:error 'sin-implementar`. Su trabajo es reemplazar cada una de esas
líneas y ver las pruebas ponerse en verde.

## Las reglas

- Recursión estructural sobre la lista. Nada de `for` ni de bucles.
- Sin `set!` ni ninguna otra asignación destructiva.
- `reverse`, `filter`, `flatten` y `append*` quedan descartadas: resuelven el
  ejercicio de un golpe y lo que se está practicando es escribir la recursión.
  `null?`, `car`, `cdr`, `cons`, `append`, `equal?` y `eqv?` sí se usan.

## Los cuatro puntos

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
