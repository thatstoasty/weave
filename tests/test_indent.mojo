import weave.indent
from .wrapper import MojoTest


fn test_indent() raises:
    var test = MojoTest("Testing indent.apply_indent")
    test.assert_equal(indent.apply_indent("Hello\nWorld\n  TEST!", 5), String("     Hello\n     World\n       TEST!"))

