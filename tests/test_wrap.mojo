from weave import wrap
from testing import testing


fn test_wrap() raises:
    testing.assert_equal(
        wrap.string("Hello Sekai!", 5),
        String("Hello\nSekai!")
    )
