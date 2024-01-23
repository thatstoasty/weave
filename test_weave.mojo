from weave import wrap, wordwrap, dedent, pad, truncate
import weave.indent

fn main() raises:
    # print(wrap("Hello Sekai!", 20))
    # print(wordwrap("Hello Sekai!", 20))
    print(indent.to_string("Hello\nWorld!", 5))
    # print(dedent("    Line 1!\n  Line 2!"))
    # print(pad("Hello\nWorld!\nThis is my text.", 15))
    # print(truncate("abcdefghikl\nasjdn", 5))
    # print(is_terminator(123))