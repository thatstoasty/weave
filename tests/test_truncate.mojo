from weave import truncate
from testing import testing


fn test_truncate() raises:
    print("Testing truncate")
    testing.assert_equal(
        truncate.apply_truncate("abcdefghikl\nasjdn", 5),
        String("abcde")
    )