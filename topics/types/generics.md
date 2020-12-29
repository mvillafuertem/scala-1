## Parameterized Types

We should think of a type as a shorthand for a set of properties which are true about all of its instances. For
simple types, like `String`, `Boolean` or `scala.Range`, all of those properties will be defined in terms of
other known and invariant types.

For example, the method `Range#by` takes an `Int` and returns a `Range`, and `String#capitalize` takes no
parameters and returns a `String`.

Other types, like `Option[T]`, will have some properties, like `Option#isEmpty`, which consistently return a
`Boolean`, but others, like `Option#get` which return `T`—a type which will be different for different
instances—and which depends directly on the type parameter, `T`.

For example, the method `Option[Int]#get` will return an `Int`, and `Option[String]#get` will return a `String`.



## Covariance
