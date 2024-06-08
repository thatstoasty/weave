from weave import indent
from tests.wrapper import MojoTest


fn test_indent():
    var test = MojoTest("Testing indent")
    test.assert_equal(
        indent("Hello\nWorld\n  TEST!", 5),
        String("     Hello\n     World\n       TEST!"),
    )


fn test_unicode():
    var test = MojoTest("Testing indent with unicode characters")
    test.assert_equal(
        indent("Hello🔥\nWorld\n  TEST!🔥", 5),
        String("     Hello🔥\n     World\n       TEST!🔥"),
    )


fn main():
    test_indent()
    test_unicode()
