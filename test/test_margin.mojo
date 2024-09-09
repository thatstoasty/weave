from weave import margin
from tests.wrapper import MojoTest


fn test_margin():
    var test = MojoTest("Testing margin")
    test.assert_equal(
        margin("Hello\nWorld\n  TEST!", 5, 2),
        String("  Hello\n  World\n    TEST!"),
    )


fn test_unicode():
    var test = MojoTest("Testing margin with unicode characters")
    test.assert_equal(
        margin("Hello🔥\nWorld\n  TEST!🔥", 5, 2),
        String("  Hello🔥\n  World\n    TEST!🔥"),
    )


fn main():
    test_margin()
    test_unicode()
