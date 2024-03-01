from weave.indent import string
from testing import testing


fn main() raises:
    var result: String = string("Hello\nWorld\n  TEST!", 5)
    testing.assert_equal(result, String("     Hello\n     World\n       TEST!"))

