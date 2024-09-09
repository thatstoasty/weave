from weave import wrap
from tests.wrapper import MojoTest


fn test_wrap() raises:
    var test = MojoTest("Testing wrap")
    test.assert_equal(wrap("Hello Sekai!", 5), String("Hello\nSekai\n!"))


fn test_unicode():
    var test = MojoTest("Testing wrap with unicode characters")
    test.assert_equal(wrap("Hello Sekai! 🔥", 5), String("Hello\nSekai\n! 🔥"))


fn main() raises:
    test_wrap()
    test_unicode()
