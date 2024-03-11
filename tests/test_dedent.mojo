from weave import dedent
from .wrapper import MojoTest


fn test_dedent() raises:
    var test = MojoTest("Testing dedent.apply_dedent")
    test.assert_equal(dedent.apply_dedent("    Line 1!\n  Line 2!"), String("  Line 1!\nLine 2!"))
