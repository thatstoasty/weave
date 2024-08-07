# weave

A collection of (ANSI-sequence aware) text reflow operations &amp; algorithms. A project to learn Mojo, Go, and how to work with buffers.

Ported from/inspired by: <https://github.com/muesli/reflow/tree/master>

I've only tested this on MacOS VSCode terminal so far, so your mileage may vary!

TODO:

- Handle different types of whitespace.

## Wrap (Unconditional Wrapping)

The `wrap` module lets you unconditionally wrap strings or entire blocks of text.

```mojo
from weave import wrap

fn main():
    print(wrap("Hello Sekai!", 5))
```

Output

```txt
Hello
Sekai
!
```

## Wordwrap

The `wordwrap` package lets you word-wrap strings or entire blocks of text.

```mojo
from weave import wordwrap

fn main():
    print(wordwrap("Hello Sekai!", 6))
```

Output

```txt
Hello
Sekai!
```

### ANSI Example

```mojo
print(wordwrap("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 10))
```

![ANSI Example Output](https://github.com/thatstoasty/weave/blob/main/weave.png)

## Indent

The `indent` module lets you indent strings or entire blocks of text.

```mojo
from weave import indent

fn main():
    print(indent("Hello\nWorld\n  TEST!", 5))
```

Output

```txt
     Hello
     World
       TEST!
```

## Dedent

The `dedent` module lets you dedent strings or entire blocks of text.
It takes the minimum indentation of all lines and removes that amount of leading whitespace from each line.

```mojo
from weave import dedent

fn main():
    print(dedent("    Line 1!\n  Line 2!"))
```

Output

```txt
  Line 1!
Line 2!
```

## Padding

The `padding` module lets you right pad strings or entire blocks of text.

```mojo
from weave import padding

fn main():
    print(padding("Hello\nWorld\nThis is my text!", 15))
```

Output

```txt
Hello
World
This is my text!
```

## Truncate

```mojo
from weave import truncate

fn main():
    print(truncate("abcdefghikl\nasjdn", 5))
```

Output

```txt
abcde
```

## Chaining outputs

```mojo
from weave import wrap
from weave import padding


fn main():
    print(padding(wrap("Hello Sekai!", 5), 5))
```

Output

```txt
Hello
Sekai
!
```
