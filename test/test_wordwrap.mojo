from weave import wordwrap
import testing


def test_wordwrap():
    testing.assert_equal(wordwrap("Hello Sekai!", 6), String("Hello\nSekai!"))


def test_unicode():
    testing.assert_equal(wordwrap("Hello Sekai! 🔥", 6), String("Hello\nSekai!\n🔥"))
