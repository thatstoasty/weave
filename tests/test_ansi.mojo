from tests.wrapper import MojoTest
from weave.ansi import printable_rune_width, is_terminator, Writer


fn test_is_terminator():
    var test = MojoTest("Testing ansi.is_terminator")
    test.assert_true(is_terminator(ord("m")))
    test.assert_false(is_terminator(0x20))


fn test_printable_rune_length():
    var test = MojoTest("Testing ansi.printable_rune_width")
    test.assert_equal(printable_rune_width("🔥"), 2)
    test.assert_equal(printable_rune_width("こんにちは, 世界!"), 17)


# fn test_writer():
#     var test = MojoTest("Testing ansi.Writer")
#     var writer = new_default_writer()
#     _ = writer.write(String("I really \x1B[38;2;249;38;114mlove\x1B[0m Mojo!").as_bytes())
#     test.assert_equal(len(writer.forward), 19)
#     test.assert_equal(len(writer.last_seq), 10)


fn main():
    test_is_terminator()
    test_printable_rune_length()
    # test_writer()
