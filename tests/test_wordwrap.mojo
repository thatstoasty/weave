from weave import wordwrap
from testing import testing


fn test_wordwrap() raises:
    print("Testing wordwrap")
    testing.assert_equal(
        wordwrap.apply_wordwrap("Hello Sekai!", 6),
        String("Hello\nSekai!")
    )
