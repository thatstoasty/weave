from bit import countl_zero
from external.gojo.builtins import Byte, Rune
from external.gojo.unicode import rune_count_in_string

alias Marker = "\x1B"


fn is_terminator(c: UInt8) -> Bool:
    return (c >= 0x40 and c <= 0x5A) or (c >= 0x61 and c <= 0x7A)


fn printable_rune_width(s: String) -> Int:
    """Returns the cell width of the given string.

    Args:
        s: List of bytes to calculate the width of.
    """
    var length: Int = 0
    var ansi: Bool = False

    # Rune iterator for string
    var bytes = len(s)
    var p = DTypePointer[DType.uint8](s.unsafe_uint8_ptr())
    while bytes > 0:
        var char_length = int((p.load() >> 7 == 0).cast[DType.uint8]() * 1 + countl_zero(~p.load()))
        var sp = DTypePointer[DType.uint8].alloc(char_length + 1)
        memcpy(sp, p, char_length)
        sp[char_length] = 0

        # Functional logic
        var c = String(sp, char_length + 1)
        if c == Marker:
            # ANSI escape sequence
            ansi = True
        elif ansi:
            if is_terminator(ord(c)):
                # ANSI sequence terminated
                ansi = False
        else:
            length += rune_count_in_string(c)

        bytes -= char_length
        p += char_length

    return length


fn printable_rune_width(s: List[Byte]) -> Int:
    """Returns the cell width of the given string.

    Args:
        s: List of bytes to calculate the width of.
    """
    var length: Int = 0
    var ansi: Bool = False

    # Rune iterator for string
    var bytes = len(s)
    var p = DTypePointer[DType.uint8](s.unsafe_ptr())
    while bytes > 0:
        var char_length = int((p.load() >> 7 == 0).cast[DType.uint8]() * 1 + countl_zero(~p.load()))
        var sp = DTypePointer[DType.uint8].alloc(char_length + 1)
        memcpy(sp, p, char_length)
        sp[char_length] = 0

        # Functional logic
        var c = String(sp, char_length + 1)
        if c == Marker:
            # ANSI escape sequence
            ansi = True
        elif ansi:
            if is_terminator(ord(c)):
                # ANSI sequence terminated
                ansi = False
        else:
            length += rune_count_in_string(c)

        bytes -= char_length
        p += char_length

    return length
