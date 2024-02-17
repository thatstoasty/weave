from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate
from weave import margin


fn main() raises:
    print(wrap.string("Hello Sekai!", 5))
    print(wordwrap.string("Hello Sekai!", 6))
    print(indent.string("Hello\nWorld\n  TEST!", 5))
    print(dedent.string("    Line 1!\n  Line 2!"))
    print(padding.string("Hello\nWorld\nThis is my text!", 15))
    # print(truncate.string("abcdefghikl\nasjdn", 5)) # OK
    # print(padding.string(wrap.string("Hello Sekai!", 5), 5))
    # print(wordwrap.string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 10))
