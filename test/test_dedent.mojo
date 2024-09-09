from weave import dedent
from tests.wrapper import MojoTest


fn test_dedent():
    var test = MojoTest("Testing dedent")
    test.assert_equal(
        dedent("    Line 1!\n  Line 2!"),
        String("  Line 1!\nLine 2!"),
    )


fn test_unicode():
    var test = MojoTest("Testing dedent with unicode characters")
    test.assert_equal(
        dedent("    Line 1🔥!\n  Line 2🔥!"),
        String("  Line 1🔥!\nLine 2🔥!"),
    )


fn main():
    test_dedent()
    test_unicode()
