## Scope of the benchmark suite

We want the benchmark suite to focus exclusively on problems that need
induction. Functional programs that don't use inductive data types probably
fit better elsewhere. Also, although we support higher-order functions and
quantification over functions, problems that need a lot of higher-order
reasoning (e.g. synthesis of functions) are probably better suited for THF.

## Criteria

When designing our language extensions, we had these criteria in mind:

1. The problem format should not look like an encoding: features such as
   data types and pattern matching should be supported natively rather
   than encoded. We should not have to throw away any information that might
   be useful to the prover when translating a functional program to TIP.
2. As far as possible, the syntax should be compatible with SMT-LIB.
   So we do not introduce new features just for the sake of it.
   We are however incompatible with SMT-LIB whenever it's needed to avoid
   breaking the first criterion.
3. The format should be accessible: easy to understand and easy for other
   tools to use.

## Example 1

This example specifies the commutativity of plus over natural numbers:

```tip-include
nat.smt2
```

The syntax should be familiar to users of SMT-LIB.
Natural numbers are defined with `declare-datatypes`.
This is not in the SMT-LIB standard, but is accepted by
many SMT solvers, including Z3 and CVC4.

The function is declared using `define-funs-rec` as proposed in the SMT-LIB v2.5 draft (@smtlib25).
We define `plus` rather than axiomatising it because,
if the problem is from a functional program, we want to be explicit about
which axioms are function definitions. 

The `match` expression is our proposed extension for match-expressions.
The first argument to match is the scrutinee, followed by a list of 
branches, all starting with the word `case` (for ease of reading). 
The first argument to `case` is the constructor and bound variables
(their types are not indicated, as they are inferrable from the
type of the scrutinee and the data type declarations).

TIP also allows the user to define their functions in a more traditional
SMT-LIB syntax, using if-then-else with discriminator and projector functions
(in this case `is-nat` and `pred`). The TIP tool is able to translate between
these syntaxes. Here is how the example above looks with
match removed:

```{.tip-include .match-to-if}
nat.smt2
```

Some provers like to distinguish between axioms and conjectures, and in many
inductive problems we have a distinguished conjecture. Following our principle
not to throw away information from the input problem, TIP has a `assert-not`
construct which identifies the goal, akin to `conjecture` in TPTP, or `goal`
in Why3. The declaration `(assert-not p)` means the same as `(assert (not p))`,
except that it marks `p` as a goal. It can easily be removed by the TIP tool:

```{.tip-include .negate-conjecture}
nat.smt2
```

The tool can also translate the example to Why3 syntax.
It then looks like this:

```{.tip-include .why3}
nat.smt2
```

### Complaints

(Data type declarations are already parametric, but the syntax is a bit broken.
It does not support declaring mutually recursive datatypes that differ in the amount of
type arguments.)

It is a bit broken because you have to first define all the signatures, and then the bodies.

 
## Example 2

This is an example of right identity of append over polymorphic lists:

```tip-include
list.smt2
```

We allow parametric declarations and assertions
(\cite{smtlam}, and suggested for inclusion in CVC4 \cite{cvc4parPR}),
using the @par@ keyword.

Expressions can be annotated with their type with the `as` keyword.
When an identifier of function application does not fully specify the 
type instantiations of its arguments by only looking at its type
and the types of its arguments, this type information is added.

Polymorphism can be removed by specialising the program at some ground
types, but this is not necessarily complete. Another method is to 
encode typing information over monomorphic terms. We want to add
techniques for this ton the tip toolchain.

When removing a polymorphic `assert-not`, new skolem types needs to be
introduced:

```{.tip-include .negate-conjecture}
list.smt2
```

This is the same problem in Why3 syntax:

```{.tip-include .why3}
list.smt2
```

## Example 3

This is an example property about mapping functions over lists: 

```{.tip-include}
map.smt2
```

Lambdas are introduced much like lets, with an identifier list with
explicit types. Note that the function spaces are a family of types,
with different arities. Thus, for some types `a`, `b` and `c`, there is a type `(=> a b c)`,
which is different from its curried version `(=> a (=> b c)`. Lambdas for the first
type are constructed with `lambda ((x a) (y b)) ...`, and for the second with 
`lambda ((x a)) (lambda ((y b)) ...)`. To apply a lambda, you explicitly
use the `@` function, which also come at a family of types:
`((=> a b) a) b`, `((=> a b c) a b) c`, and so on.

In some cases, higher order functions can be removed with specialisation, 
like in the example above. They can always be removed by defunctionalisation,
which is implemented in our tool chain. This pass transforms the above program into this:

```{.tip-include .lambda-lift}
map.smt2
```

Here, `=>` with one argument is replaced with `fun1`, `@` with one argument
is replaced with `apply1`. The lambda in the property has become a new function,
`lam`, which closes over the free variables `f` and `g`.

HO-function (with a closure)

default

mutual recusion

partial branches

