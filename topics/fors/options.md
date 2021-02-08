Scala provides convenient syntax for working with monads, though before we begin to look in depth

Before we discover what a monad is, it is useful to see a few examples

## Option

Frequently we find that a type describes exactly the set of instances we want to represent, but has no way of
representing a "missing" value; a value which represents the state that—for some reason—there is no value of
that particular type.

There are numerous reasons that we might need to represent the absence of a value.

For example, if a user submits a form (perhaps on a website, but it's not important!) and they may have
specified their email address, or they may have left that field blank. An `EmailAddress` type should represent
every possible email address, but has no way of representing the state that an email address has not been given.

Or, if we attempt to access a string value in a map by its index, but the map does not contain a string at that
index, we would need a type which represents that fact in the form of a value that can be returned.

`Option` is a generic type which can provide exactly this functionality. It can effectively transform any type,
`T`, into a type which means "either an instance of `T` or nothing", which we write as `Option[T]`.

So, an optional email address on a form could be represented by the type `Option[EmailAddress]` and an attempt
to get a string from a map would be an `Option[String]`.

However, an instance of an instance of `T` is not interchangeable with an instance of `Option[T]`; they are
different types with different properties, and have to be treated differently.

An instance of an `Option[T]` must be one of two possibilities: either `Some` instance of `T` (that is,
`Some[T]`) or the value `None`. For an optional string, we would have to write these two possibilities as:
```scala
val noString: Option[String] = None
val someString: Option[String] = Some("Hello World!")
```

### Working with `Option`s

Since an `Option[String]` is not a `String`, we cannot just use it as we would use a `String`; we must first
check that the `String` value is present, and provide alternative behavior in the event that it is not.

One of the clearest ways to achieve this is through pattern matching, like in this example where `name` is an
`Option[String]`.
```scala
name match
   case Some(value) => println(s"Your name is $name.")
   case None        => println("You have not specified a name.")
```

However, a `Option`s have a few other methods which make working with them easier.

The method `Option#getOrElse` can be used to convert any `Option[T]` into a `T`, by providing a default instance
of `T` in the event that the value is `None`.

Its implementation (simplified here) is quite easy to understand,
```scala
trait Option[+T]:
   def getOrElse(default: T): T = this match
      case None        => default
      case Some(value) => value
```
and we can use it in expressions like `title.getOrElse("Untitled")` or `color.getOrElse(Red)`, which remove the
`Option` wrapper around the type, meaning that the values can no longer be `None`, the absence of a value.

It's also very common to want to modify an optional value, or if the `Option` value is `None`, leave it as
`None`. Imagine, for example, that we would like to capitalize an `Option[String]`, `firstName`. It is not
possible to write `firstName.capitalize` because `capitalize` is a method of `String`, not of `Option[String]`.

As usual, we could write this as a pattern match,
```scala
firstName match
   case None        => None
   case Some(value) => Some(value.capitalize)
```
but this is such a common operation that the method `map` is provided, which takes the lambda that should apply
to the value (if it exists), and we can write this as `firstName.map { n => n.capitalize }`, or even more
concisely, `firstName.map(_.capitalize)`.

Another convenience method for `Option`s is `fold`, which combines `map` and `getOrElse` in a single operation.

We could capitalize the optional `firstName` value, defaulting to the string `"Unnamed"` if it's not specified
with `firstName.map(_.capitalize).getOrElse("Unnamed")`, but would could simplify that to,
`firstName.fold("Unnamed")(_.capitalize)`, noting that the order of the parameters gets switched.

In general, any expression of the form `value.map(lambda).getOrElse(default)` can be written as,
`value.fold(default)(lambda)`.

Finally, the method `flatMap` behaves a lot like `map`, but where the function being applied to the value inside
the `Option` (if there is one) to itself return another `Option`.

Imagine an optional value, `filename`, which contains a filename (if a user specified one) and a method, `load`
which takes a filename as a parameter, and loads it from disk, if it exists. We could combine these two
operations together to get a value if and only if both of them succeed,
```scala
filename match
   case None    => None
   case Some(f) => load(f)
```

but that can be written more simply as, `filename.flatMap { f => load(f) }`, or just, `filename.flatMap(load)`.

It's common to want to work with a series of operations, each of which returns an `Option` of some type, and the
`flatMap` method provides a convenient way to combine them.

You may have noticed that the choices of names in the examples above do not generally make reference to the fact
that their values are optional. It's standard practice in Scala that as this information is included in the
value's type, it is not useful to duplicate it in the value's identifier.

### Null

Unfortunately, it has been common practice in many programming languages—most notably Java, since Scala reuses
much of Java's ecosystem—to use the value `null` to represent an absent value of a type.

The special value `null` is an instance of every reference type (whether we want it to be or not!), which
theoretically means that every single reference type can potentially be equal to `null`.

That can be hugely problematic since any attempt to dereference a `null` value will cause a runtime exception to
be thrown, which can cause a program to terminate unexpectedly unless it is carefully handled.

Having a program which has the potential to fail on every single method call or field access is such a risk that
the use of `null` has been described by Tony Hoare, who first added `null` to a language in 1965, as his
["billion-dollar mistake"](https://bit.ly/36UUE2l), and consequently Scala programmers should do everything we
can to avoid its use.

Thankfully, the problem can be mitigated by combining two different approaches.

The first is to avoid assigning the value `null`, (which is the easy part) and to be aware of which methods in
other external libraries may return the value `null`, and to be careful to handle it.

The second approach is to ensure that we always take full advantage of the `Option` type to represent any value
which may be absent.

`Option` provides a special constructor which takes a single parameter, for example, `value`. Normally this
constructor simply returns `Some(value)`, but if the `value` is equal to `null`, then it returns `None`. This
means that any value constructed with `Option(expression)` is guaranteed to hold a non-null value, or to be
`None`.

## Try

One use of an `Option[T]` is to provide a result, `Some(value)`, when an operation succeeds, or to return
`None` if it fails. While this is a perfectly valid use for an `Option`, the "failure" value, `None`, cannot
provide us with any information about the failure.

For example, if we call a method to download and read a JSON file from a URL, and a value of `None` is returned,
we cannot inspect that value to know whether the file was the wrong format, the file could not be found at the
given URL, or if the computer has no internet connection.

We would like different failure values for different types of error.

The type `Try` serves exactly this function. While it shares its name with the keyword, `try`, which is part of
the `try`/`catch`/`finally` construction, and both deal with error handling, they are not the same thing! `Try`
is a datatype, like `Option`, which can hold a successful value, or a failure value—specifically an exception.

`Try` is in the `scala.util` package, so it must be imported before it's used, with,
```scala
import scala.util.Try
```

Exceptions, or any instance of the `Throwable` type, have a special status on the JVM. They are values with
their own types, and behave just like other values, but they can additionally be _thrown_. A method which throws
an exception does not exit _normally_ and does not return a value. Moreover, the thrown exception represents the
inability to return a value.

A `Try` instance can be constructed using the `Try(expression)` constructor. Whether the `expression` evaluates
successfully or throws an exception, `Try` will nevertheless return a value. Most exceptions thrown by the
expression will be safely captured, and only certain "fatal" exceptions—those which likely indicate a terminal
failure, such as running out of memory—will be thrown by an expression wrapped in the `Try` constructor.

Much like an `Option[T]`, an instance of `Try[T]` must be one of two possibilities: `Success`, which corresponds
directly to `Some`, and `Failure`, which is equivalent to `None` but as well as indicating the absence of a
value (or more precisely, a _successful_ value) holds the `Throwable` value which was the cause of the failure.

And much like an `Option` we can pattern match on a `Try`, noting that our failure case must handle a
`Throwable` value everywhere, for example, we can match on `getName`, a method which gets a name as a
`Try[String]`,
```scala
getName match
   case Success(name)  => name.capitalize
   case Failure(error) => s"Could not get the name. Cause: ${error.getMessage}"
```

While the type of the `Success` parameter will be the same as the type parameter of the `Try`—a `String` in this
example—the type of the `Failure` parameter is known to be a `Throwable`, so we can call methods like
`Throwable#getMessage` on `error`.

The behavior of many of `Try`'s methods, like `getOrElse`, `map` and `flatMap`, also mirror `Option`'s. Our
earlier example of `filename.flatMap(load)` will work unchanged if both `filename` and the method `load` return
`Try` instances instead of `Option` instances.

Note that `fold` has a different signature for `Try`, and pattern matching on the `Try` instance is usually
clearer than using its `fold` method, so we won't examine it.

## Future

The `Future` type, like `Option` and `Try`, is another "container" type that can hold a successful instance of
the `Future`'s parameter type—or no value.

But it has a powerful difference from `Option` and `Try`: a `Future`'s value will be calculated
_asynchronously_.

That means we can construct a `Future` value, such as,
```scala
val future: Future[String] = Future { Http.download(url) }
println("Started downloading")
```
and we will **instantly** have a value representing a `String` value which may or may not have been computed
yet. The expression `Http.download(url)`, which may take a second or two to complete and return a string value,
will start running concurrently, but we do not need to wait for it to finish before printing the text,
`"Started downloading"`.

We can do other things while waiting for the `Future` to _complete_, which is the word we use to describe the
concurrent provision of a value that gets held by a `Future`.

That completion happens in the background, and at some point—maybe 10ms later or maybe ten seconds later—the
`Future`'s state will be mutated internally to hold a reference to a value on the heap.

It may seem complicated to have to manage a value whose internal state may change at an unknown point, later in
time. And that should not be overlooked. But `Future` hides most of its complexity through a functional
interface that uses many of the same methods as `Option` and `Try`.

The methods `map` and `flatMap` exist on the `Future` type, and behave in the same way.

Both methods take a lambda; an inline _function value_, whose execution could happen immediately, or at some
time in the future. That means that the lambda can be applied to the `Future`'s value as and when it completes,
and not before. Both methods return `Future` values, which means they can be returned immediately, safe in the
knowledge that the execution of the initial `Future` and the execution of the applied lambdas can happen
asynchronously, and the resultant `Future` will be completed eventually.

## For Comprehensions

This just touches the surface of what can be achieved with `Future`s, but it illustrates that two methods—`map`
and `flatMap`—are versatile enough to model optionality, fallibility and asynchronicity. And, in fact, many
other datatypes exist with these same two methods.

This gives rise to the abstraction of a _functor_ and a _monad_, which will be covered later in this topic.

But Scala also provides special syntax for working with functors and monads, using for-comprehension syntax.

Earlier we saw an example using `flatMap`, which combined a `filename` expression and a `load` function. This
same expression works equally well, whether `filename` and `load` return `Option`s, `Try`s or `Future`s (though
does require that both return the _same_ container type).

But the same expression may also be written in for-comprehension style, like so:
```scala
for
  f    <- filename
  file <- load(f)
yield file
```

This is clearly more verbose, but it is a useful and powerful construct in Scala which can abstract over
datatypes with `map` and `flatMap` methods. It can easily scale to more complex sequences of operations. It can
bring clarity to code which would otherwise be harder to understand. And it will be the subject of the lessons
in this topic.

?---?
