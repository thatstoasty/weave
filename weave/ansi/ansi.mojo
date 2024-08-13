from gojo.unicode import string_width


alias Marker = "\x1B"


fn is_terminator(c: Int) -> Bool:
    return (c >= 0x40 and c <= 0x5A) or (c >= 0x61 and c <= 0x7A)


fn printable_rune_width(text: String) -> Int:
    """Returns the cell width of the given string.

    Args:
        text: String to calculate the width of.

    Returns:
        The printable cell width of the string.
    """
    var length = 0
    var ansi = False

    for rune in text:
        if rune == Marker:
            # ANSI escape sequence
            ansi = True
        elif ansi:
            if is_terminator(ord(String(rune))):
                # ANSI sequence terminated
                ansi = False
        else:
            length += string_width(rune)

    return length
