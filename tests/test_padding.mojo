from weave import padding
from testing import testing


fn test_padding() raises:
    print("Testing padding")
    testing.assert_equal(
        padding.apply_padding("Hello\nWorld\nThis is my text!", 20),
        String("Hello               \nWorld               \nThis is my text!    ")
    )

