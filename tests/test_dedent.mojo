from testing import testing
from weave import dedent


fn test_dedent() raises:
    print("Testing dedent")
    var result: String = dedent.apply_dedent("    Line 1!\n  Line 2!")
    testing.assert_equal(result, String("  Line 1!\nLine 2!"))
