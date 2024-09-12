from weave import indent
import testing


def test_indent():
    testing.assert_equal(
        indent("Hello\nWorld\n  TEST!", 5),
        String("     Hello\n     World\n       TEST!"),
    )


def test_unicode():
    testing.assert_equal(
        indent("Hello🔥\nWorld\n  TEST!🔥", 5),
        String("     Hello🔥\n     World\n       TEST!🔥"),
    )
