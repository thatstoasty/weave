# weave
A collection of (ANSI-sequence aware) text reflow operations &amp; algorithms.

Ported from/inspired by: https://github.com/muesli/reflow/tree/master

> NOTE: This is not a 1:1 port or stable due to missing features in Mojo, and the fact that I'm learning how to work with buffers as I go!

## Wrap
```rust
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(wrap.to_string("Hello Sekai!", 5))
    print(wordwrap.to_string("Hello Sekai!", 6))
    print(indent.to_string("Hello\nWorld\n  TEST!", 5))
    print(dedent.to_string("    Line 1!\n  Line 2!"))
    print(padding.to_string("Hello\nWorld\nThis is my text!", 15, True))
    print(truncate.to_string("abcdefghikl\nasjdn", 5))
    print(padding.to_string(wrap.to_string("Hello Sekai!", 5), 5))
```

Output
```txt
Hello
Sekai
!
```

## Wordwrap
```rust
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(wrap.to_string("Hello Sekai!", 5))
    print(wordwrap.to_string("Hello Sekai!", 6))
    print(indent.to_string("Hello\nWorld\n  TEST!", 5))
    print(dedent.to_string("    Line 1!\n  Line 2!"))
    print(padding.to_string("Hello\nWorld\nThis is my text!", 15, True))
    print(truncate.to_string("abcdefghikl\nasjdn", 5))
    print(padding.to_string(wrap.to_string("Hello Sekai!", 5), 5))
```

Output
```txt
Hello
Sekai!
```

## Indent
```rust
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(wrap.to_string("Hello Sekai!", 5))
    print(wordwrap.to_string("Hello Sekai!", 6))
    print(indent.to_string("Hello\nWorld\n  TEST!", 5))
    print(dedent.to_string("    Line 1!\n  Line 2!"))
    print(padding.to_string("Hello\nWorld\nThis is my text!", 15, True))
    print(truncate.to_string("abcdefghikl\nasjdn", 5))
    print(padding.to_string(wrap.to_string("Hello Sekai!", 5), 5))
```

## Dedent
```rust
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(wrap.to_string("Hello Sekai!", 5))
    print(wordwrap.to_string("Hello Sekai!", 6))
    print(indent.to_string("Hello\nWorld\n  TEST!", 5))
    print(dedent.to_string("    Line 1!\n  Line 2!"))
    print(padding.to_string("Hello\nWorld\nThis is my text!", 15, True))
    print(truncate.to_string("abcdefghikl\nasjdn", 5))
    print(padding.to_string(wrap.to_string("Hello Sekai!", 5), 5))
```

Output
```txt
  Line 1!
Line 2!
```

## Padding
```rust
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(padding.to_string("Hello\nWorld\nThis is my text!", 15, True))
    print(padding.to_string("Hello\nWorld\nThis is my text!", 15))
```

Output
```txt
               Hello
               World
               This is my text!
Hello
World
This is my text!
```

## Truncate
```rust
from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate

fn main() raises:
    print(wrap.to_string("Hello Sekai!", 5))
    print(wordwrap.to_string("Hello Sekai!", 6))
    print(indent.to_string("Hello\nWorld\n  TEST!", 5))
    print(dedent.to_string("    Line 1!\n  Line 2!"))
    print(padding.to_string("Hello\nWorld\nThis is my text!", 15, True))
    print(truncate.to_string("abcdefghikl\nasjdn", 5))
    print(padding.to_string(wrap.to_string("Hello Sekai!", 5), 5))
```

Output
```txt
abcde
```

## Chaining outputs
```rust
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