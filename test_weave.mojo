from weave import wrap, wordwrap, indent, dedent, pad


fn main() raises:
    print(wrap("Hello\tWorld!", 6))
    print(wordwrap("Hello World!", 7))
    print(indent("Hello\nWorld!", 3))
    print(dedent("    Line 1!\n  Line 2!"))
    print(pad("Hello\nWorld!\nThis is my text.", 15))