from weave import wrap
import testing


def test_wrap():
    testing.assert_equal(wrap("Hello Sekai!", 5), String("Hello\nSekai\n!"))


def test_unicode():
    testing.assert_equal(wrap("Hello Sekai! 🔥", 5), String("Hello\nSekai\n! 🔥"))
