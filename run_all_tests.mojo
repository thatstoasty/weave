from tests import test_indent
from tests import test_dedent
from tests import test_wrap
from tests import test_wordwrap
from tests import test_padding
from tests import test_truncate


fn main() raises:
    test_indent.test_indent()
    test_dedent.test_dedent()
    test_wrap.test_wrap()
    test_wordwrap.test_wordwrap()
    test_padding.test_padding()
    test_truncate.test_truncate()
    print("All tests passed!")
