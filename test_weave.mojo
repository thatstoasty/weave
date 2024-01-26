from weave import indent
from weave import wrap
from weave import wordwrap
from weave import dedent
from weave import padding
from weave import truncate
from weave import margin

fn main() raises:    
    # print(wrap.to_string("Hello Sekai!", 5))
    # print(wordwrap.to_string("Hello Sekai!", 6))
    # print(wrap.to_string("Hello Sekai!", 5))
    print(indent.to_string("Hello\nWorld\n  TEST!", 5))
    # print(dedent.to_string("    Line 1!\n  Line 2!"))
    # print(padding.to_string("Hello\nWorld\nThis is my text!", 15))
    # print(truncate.to_string("abcdefghikl\nasjdn", 5))
    # print(padding.to_string(wrap.to_string("Hello Sekai!", 5), 5))
    # print(wordwrap.to_string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 10))
    # print(wrap.to_string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 8))
    # print(indent.to_string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 6))
    # print(dedent.to_string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!"))
    # print(padding.to_string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 30))
    # print(padding.to_string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 30, True))
    # print(truncate.to_string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 6))
    # print(margin.to_string("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!", 6, 3))
