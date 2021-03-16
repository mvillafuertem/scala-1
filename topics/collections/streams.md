## Lazy lists

Scala's `List` type provides a way to define sequences of elements as either the empty list, called `Nil`, or as
the "cons" of one "head" element to a "tail" which is just another `List` instance, thereby allowing sequences
of arbitrary length.

While the length of a `List` instance may be _arbitrary_, it is nevertheless fixed and finite: every "cons"
must include a tail which is a reference to another `List` existing on the heap, and is immutable, so after its
creation, it's not possible to change in any way.

Alternative mutable collections exist in Scala's standard library which can be modified after their creation,
but their mutable nature can bring its own challenges.

In fact, a data structure also exists which is both immutable and whose elements need not be fully specified at
the moment of its construction: `LazyList`.

A data structure which combines immutability without being fully-specified may seem like a contradiction, but it
is not! A `LazyList` is conceptually and structurally very similar to a `List`, but its value—either an empty
`LazyList` or the "cons" of a head value to a `LazyList` tail—is not calculated until it is needed.

So effectively, a `LazyList` represents a function which, the first time it is accessed, will calculate the
`LazyList`'s head and tail member values for that instance (or could potentially calculate the empty
`LazyList`). On subsequent accesses, the function will return simple references to these values, without any
calculation.

So, the head and tail of a `LazyList` may not be available instantaneously since it may need to be calculated,
but once calculated, they can never change or be recalculated to different values, and this guarantees
immutability.

We should pay close attention to what it means to calculate the remainder of the sequence, when accessing the
tail of a `LazyList`. In general, that does _not_ mean computing all the remaining elements of the sequence; it
just means constructing the `LazyList` instance for the tail. And we shouldn't forget that that `LazyList` is,
of course, lazy itself.

So calculating the _tail_ of one `LazyList` essentially requires us to calculate just the next element in the
sequence, because the _tail of the tail_ is lazy and will be computed only when required.

## Uses of `LazyList`s

The subtle change in the way the list's tail is specified introduces a wealth of possibilities that are not
available to us in a strictly-computed data structure like `List`.

The elements in a `LazyList` may depend on state which is not known (or not knowable) at the time it is
constructed, or which changes independently of the `LazyList` instance, such as user input from a keyboard or
the network. The ultimate length of a `LazyList` may be affected by events, or may even be effectively infinite.

Operations on `LazyList`s will compute as much of the sequence as necessary. So an operation such as accessing
the _n_th element will compute just the first _n_ elements of the `LazyList`, while calling `isEmpty` only needs
to compute the value for the current `LazyList`. Calculating the `length` of a `LazyList` requires the entire
sequence of elements to be calculated.




## Streaming

## `LazyList` References

