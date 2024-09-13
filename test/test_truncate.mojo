from weave import truncate
import testing


def test_truncate():
    testing.assert_equal(truncate("abcdefghikl\nasjdn", 5), String("abcde"))


def test_unicode():
    testing.assert_equal(truncate("abcdefghikl🔥a\nsjdn🔥", 13), String("abcdefghikl🔥"))
