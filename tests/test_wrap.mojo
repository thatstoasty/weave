from weave import wrap
from testing import testing


fn test_wrap() raises:
    print("Testing wrap")
    testing.assert_equal(
        wrap.apply_wrap("Hello Sekai!", 5),
        String("Hello\nSekai\n!")
    )
