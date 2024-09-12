from weave import padding
import testing


def test_padding():
    testing.assert_equal(
        padding("Hello\nWorld\nThis is my text!", 20),
        String("Hello               \nWorld               \nThis is my text!    "),
    )


def test_unicode():
    testing.assert_equal(
        padding("Hello\nWorld\nThis is my text! 🔥", 20),
        String("Hello               \nWorld               \nThis is my text! 🔥 "),
    )
