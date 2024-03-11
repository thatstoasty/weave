from weave import wrap
from tests.wrapper import MojoTest


fn test_wrap() raises:
    var test = MojoTest("Testing wrap.apply_wrap")
    test.assert_equal(
        wrap.apply_wrap("Hello Sekai!", 5),
        String("Hello\nSekai\n!")
    )


fn main() raises:
    test_wrap()