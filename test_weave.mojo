from weave import wrap, wordwrap, indent, dedent, pad, truncate
from weave._ansi import is_terminator

fn main() raises:
    print(wrap("Hello Sekai!", 20))
    print(wordwrap("Hello Sekai!", 20))
    # print(indent("Hello\nWorld!", 3))
    # print(dedent("    Line 1!\n  Line 2!"))
    # print(pad("Hello\nWorld!\nThis is my text.", 15))
    # print(truncate("abcdefghikl\nasjdn", 5))
    # print(is_terminator(123))