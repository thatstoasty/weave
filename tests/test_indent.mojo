import weave.indent
from testing import testing


fn test_indent() raises:
    print("Testing indent")
    let result = indent.string("Hello\nWorld\n  TEST!", 5)
    testing.assert_equal(result, String("     Hello\n     World\n       TEST!"))

