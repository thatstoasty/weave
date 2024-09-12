from weave import dedent
import testing


def test_dedent():
    testing.assert_equal(
        dedent("    Line 1!\n  Line 2!"),
        String("  Line 1!\nLine 2!"),
    )


def test_unicode():
    testing.assert_equal(
        dedent("    Line 1🔥!\n  Line 2🔥!"),
        String("  Line 1🔥!\nLine 2🔥!"),
    )
