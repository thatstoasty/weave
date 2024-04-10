from weave import padding
from tests.wrapper import MojoTest


fn test_padding() raises:
    var test = MojoTest("Testing padding.apply_padding")
    test.assert_equal(
        padding.apply_padding("Hello\nWorld\nThis is my text!", 20),
        String(
            "Hello               \nWorld               \nThis is my text!    "
        ),
    )


fn main() raises:
    test_padding()
