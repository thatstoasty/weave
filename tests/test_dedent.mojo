from testing import testing
from weave import dedent


fn test_dedent() raises:
    let result: String = dedent.string("    Line 1!\n  Line 2!")
    testing.assert_equal(result, String("  Line 1!\nLine 2!"))
