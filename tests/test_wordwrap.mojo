from weave import wordwrap
from testing import testing


fn test_wordwrap() raises:
    testing.assert_equal(
        wordwrap.string("Hello Sekai!", 6),
        String("Hello \nSekai!")
    )
