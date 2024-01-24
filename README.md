# weave
A collection of (ANSI-sequence aware) text reflow operations &amp; algorithms. A project to learn Mojo, Go, and how to work with buffers.

Ported from/inspired by: https://github.com/muesli/reflow/tree/master

> NOTE: This is not a 1:1 port or stable due to missing features in Mojo, and the fact that I'm learning how to work with buffers as I go!

## Wrap (Unconditional Wrapping)
The `wrap` module lets you unconditionally wrap strings or entire blocks of text.

```python
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(wrap.to_string("Hello Sekai!", 5))
```

Output
```txt
Hello
Sekai
!
```

## Wordwrap
The `wordwrap` package lets you word-wrap strings or entire blocks of text.

TODO: Doesn't work correctly with ANSI sequences yet.

```python
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(wordwrap.to_string("Hello Sekai!", 6))
```

Output
```txt
Hello
Sekai!
```

## Indent
The `indent` module lets you indent strings or entire blocks of text.

```python
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(indent.to_string("Hello\nWorld\n  TEST!", 5))
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

```python
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(dedent.to_string("    Line 1!\n  Line 2!"))
```

Output
```txt
  Line 1!
Line 2!
```

## Padding
The `padding` module lets you right pad strings or entire blocks of text.

```python
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(padding.to_string("Hello\nWorld\nThis is my text!", 15))
```

Output
```txt
Hello
World
This is my text!
```

## Truncate
```python
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(truncate.to_string("abcdefghikl\nasjdn", 5))
```

Output
```txt
abcde
```

## Chaining outputs
```python
from weave import wrap
from weave import padding


fn main() raises:
    print(padding.to_string(wrap.to_string("Hello Sekai!", 5), 5))
```

Output
```txt
Hello
Sekai
!   
```