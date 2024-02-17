from weave import truncate
from testing import testing


fn test_truncate() raises:
    testing.assert_equal(
        truncate.string("abcdefghikl\nasjdn", 5),
        String("abcde")
    )