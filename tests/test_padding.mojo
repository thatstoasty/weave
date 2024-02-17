from weave import padding
from testing import testing


fn test_padding() raises:
    testing.assert_equal(
        padding.string("Hello\nWorld\nThis is my text!", 15),
        String("Hello               \nWorld               \nThis is my text!               ")
    )

