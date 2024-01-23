from weave import indent
from weave import wrap

fn main() raises:
    print(wrap.to_string("Hello Sekai!", 5))
    # print(wordwrap("Hello Sekai!", 20))
    # print(indent.to_string("Hello\nWorld\n  TEST!", 5))
    # print(dedent("    Line 1!\n  Line 2!"))
    # print(pad("Hello\nWorld!\nThis is my text.", 15))
    # print(truncate("abcdefghikl\nasjdn", 5))
    # print(is_terminator(123))