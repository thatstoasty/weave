import testing
from weave.ansi import printable_rune_width, is_terminator, Writer


def test_is_terminator():
    testing.assert_true(is_terminator(ord("m")))
    testing.assert_false(is_terminator(0x20))


def test_printable_rune_length():
    testing.assert_equal(printable_rune_width("🔥"), 2)
    testing.assert_equal(printable_rune_width("こんにちは, 世界!"), 17)
    testing.assert_equal(printable_rune_width("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!"), 19)


# def test_writer():
#     var writer = Writer()
#     _ = writer.write("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!")
#     testing.assert_equal(len(writer.forward), 19)
#     testing.assert_equal(len(writer.last_seq), 10)
