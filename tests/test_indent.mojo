import weave.indent
from testing import testing


fn test_indent() raises:
    print("Testing indent")
    var result = indent.apply_indent("Hello\nWorld\n  TEST!", 5)
    testing.assert_equal(result, String("     Hello\n     World\n       TEST!"))

