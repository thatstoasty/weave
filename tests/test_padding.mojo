from weave import padding
from tests.wrapper import MojoTest


fn test_padding() raises:
    var test = MojoTest("Testing padding")
    test.assert_equal(
        padding("Hello\nWorld\nThis is my text!", 20),
        String("Hello               \nWorld               \nThis is my text!    "),
    )


fn test_unicode():
    var test = MojoTest("Testing padding with unicode characters")
    test.assert_equal(
        padding("Hello\nWorld\nThis is my text! 🔥", 20),
        String("Hello               \nWorld               \nThis is my text! 🔥  "),
    )


fn main() raises:
    test_padding()
    test_unicode()
