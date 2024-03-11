from weave import wordwrap
from .wrapper import MojoTest


fn test_wordwrap() raises:
    var test = MojoTest("Testing wordwrap.apply_wordwrap")
    test.assert_equal(
        wordwrap.apply_wordwrap("Hello Sekai!", 6),
        String("Hello\nSekai!")
    )
