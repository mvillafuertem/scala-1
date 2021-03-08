## Strings as Binary

When we work with strings in Scala, we almost never have to worry about how the characters which make up the
string are stored in memory: Scala gives us a `Char` type for representing different characters in `String`
instances, and in can represent any _Unicode_ character.

But all the data we process in a Scala program must ultimately be stored in memory and processed as binary
(which we can think of as an `Array[Byte]`) so while the character abstraction hides this detail from us, a
translation between characters and their binary representations is nevertheless happening whenever strings are
placed in or retrieved from memory.

This abstraction works seamlessly _within_ any Scala program, because strings of text are always represented
internally in exactly the same binary format, and are presented to us consistently through the `String` type.
When we print a string of text from Scala, it will need to be passed to the underlying operating system, which
may involve converting it to a format the operating system understands. But that is also handled seamlessly.

The process of translating from strings of characters to binary data is called _encoding_, whereas the reverse
process from binary data to strings of characters is called _decoding_. The algorithm that defines the mapping
is called a _character encoding_.

## Information Interchange

But when we need to exchange character data with other systems, sending or receiving it across the network or
by storing it on disk, we need to consider how the data can be exchanged such that the other system is able to
read it correctly, and unfortunately, different answers will apply in different scenarios.

For many tasks that involve information interchange, we will use a third-party library which provides us with
a high-level interface for exchanging character data, and there is no need to consider what encoding is used.
Assuming we trust the library to do the right thing (which should not necessarily be taken for granted!) this
is ideal because it avoids the potentially-problematic choice of character encoding.

Other libraries may choose a default character encoding for us, while offering an option to override that
default with a specific choice.

And some libraries may require a character encoding to be specified, or may offer only interfaces defined in
terms of `Array[Byte]` rather than `String`, thereby forcing the encoding to be performed beforehand.

All these varieties exist commonly, and it helps to be aware of when encoding or decoding is necessary, and
also when we should be explicit about specifying a character encoding, and when it's acceptable to accept a
default.

## Encoding and Decoding

In general, when exchanging character data between different systems, there will either be a common, invariant
and pre-established character encoding agreed between the source and the destination, or the encoding used will
be send along with the character data, often within the character data itself in a machine-readable header (that
the destination system expects to interpret), or established in 

## Character Encodings

It is useful to know about three different character encodings that are currently in widespread usage today: `ASCII`, `UTF-8` and `ISO-8859-1`.


