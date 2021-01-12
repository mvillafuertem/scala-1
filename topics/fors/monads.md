The abstraction of a _monad_ is one of the most useful we will encounter when writing Scala, at the same time as
being one of the hardest to relate to. The challenge of understanding what monads are arises from their highly
abstract nature, and the fact that many of the concrete examples of monads we will learn can seem so different
that the essence of what makes them _monadic_ can be hard to discern.

It is useful to first clarify some nomenclature. A monad is a set of rules which govern instances of a
particular type. We can say that that type _has a monad_, or sometimes, _has a monad instance_. And while it is
very common to hear that the particular type _is a monad_ or that instances of that type _are monads_, we are
not going to adopt that convention.

For example, the `List` type has a monad. We can also say that `List` is a _monadic type_.

Monads concern the sequencing of computations.