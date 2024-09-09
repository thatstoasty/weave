from weave import wordwrap
from tests.wrapper import MojoTest


fn test_wordwrap():
    var test = MojoTest("Testing wordwrap")
    test.assert_equal(wordwrap("Hello Sekai!", 6), String("Hello\nSekai!"))


fn test_unicode():
    var test = MojoTest("Testing wordwrap with unicode characters")
    test.assert_equal(wordwrap("Hello Sekai! 🔥", 6), String("Hello\nSekai!\n🔥"))


fn main() raises:
    test_wordwrap()
    test_unicode()
