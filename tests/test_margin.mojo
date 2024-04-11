from weave import margin
from tests.wrapper import MojoTest


fn test_margin():
    var test = MojoTest("Testing margin.apply_margin")
    test.assert_equal(
        margin.apply_margin("Hello\nWorld\n  TEST!", 5, 2),
        String("  Hello\n  World\n    TEST!"),
    )


fn test_unicode():
    var test = MojoTest("Testing margin.apply_margin with unicode characters")
    test.assert_equal(
        margin.apply_margin("Hello🔥\nWorld\n  TEST!🔥", 5, 2),
        String("  Hello🔥\n  World\n    TEST!🔥"),
    )


fn main():
    test_margin()
    test_unicode()
