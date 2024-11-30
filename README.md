# weave

A collection of (ANSI-sequence aware) text reflow operations & algorithms.

Ported from/inspired by: <https://github.com/muesli/reflow/tree/master>

TODO:

- Handle different types of whitespace.

## Installation

1. First, you'll need to configure your `mojoproject.toml` file to include my Conda channel. Add `"https://repo.prefix.dev/mojo-community"` to the list of channels.
2. Next, add `weave` to your project's dependencies by running `magic add weave`.
3. Finally, run `magic install` to install in `weave` and its dependencies. You should see the `.mojopkg` files in `$CONDA_PREFIX/lib/mojo/` (usually resolves to `.magic/envs/default/lib/mojo`).

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

## Word wrap

The `word_wrap` package lets you word-wrap strings or entire blocks of text.

```mojo
from weave import word_wrap

fn main():
    print(word_wrap("Hello Sekai!", 6))
```

Output

```txt
Hello
Sekai!
```

### ANSI Example

```mojo
print(word_wrap("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 10))
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
