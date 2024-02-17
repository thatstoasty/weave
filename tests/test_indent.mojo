from weave.indent import string
from testing import testing


fn test_indent() raises:
    let result: String = string("Hello\nWorld\n  TEST!", 5)
    testing.assert_equal(result, String("     Hello\n     World\n       TEST!"))

