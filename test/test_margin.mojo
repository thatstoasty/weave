from weave import margin
import testing


def test_margin():
    testing.assert_equal(
        margin("Hello\nWorld\n  TEST!", 5, 2),
        String("  Hello\n  World\n    TEST!"),
    )


def test_unicode():
    testing.assert_equal(
        margin("Hello🔥\nWorld\n  TEST!🔥", 5, 2),
        String("  Hello🔥\n  World\n    TEST!🔥"),
    )
