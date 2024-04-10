from weave import truncate
from tests.wrapper import MojoTest


fn test_truncate() raises:
    var test = MojoTest("Testing truncate.apply_truncate")
    test.assert_equal(
        truncate.apply_truncate("abcdefghikl\nasjdn", 5), String("abcde")
    )


fn main() raises:
    test_truncate()
