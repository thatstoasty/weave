from utils import StringSlice
from collections import InlineArray
from weave._table import (
    Interval,
    narrow,
    combining,
    doublewidth,
    ambiguous,
    emoji,
    nonprint,
)
from weave.traits import AsStringSlice


@value
struct Condition[east_asian_width: Bool, strict_emoji_neutral: Bool]:
    """Conditions have the flag `east_asian_width` enabled if the current locale is `CJK` or not.

    Parameters:
        east_asian_width: Whether to use the East Asian Width algorithm to calculate the width of runes.
        strict_emoji_neutral: Whether to treat emoji as double-width characters.
    """

    fn char_width(self, char: Char) -> Int:
        """Returns the number of cells in `char`.
        See http://www.unicode.org/reports/tr11/.

        Args:
            char: The char to calculate the width of.

        Returns:
            The printable width of the rune.
        """
        var rune = char.to_u32()
        if rune < 0 or rune > 0x10FFFF:
            return 0

        @parameter
        if not east_asian_width:
            if rune < 0x20:
                return 0
            # nonprint
            elif (rune >= 0x7F and rune <= 0x9F) or rune == 0xAD:
                return 0
            elif rune < 0x300:
                return 1
            elif in_table(char, narrow):
                return 1
            elif in_table(char, nonprint):
                return 0
            elif in_table(char, combining):
                return 0
            elif in_table(char, doublewidth):
                return 2
            else:
                return 1
        else:
            if in_table(char, nonprint):
                return 0
            elif in_table(char, combining):
                return 0
            elif in_table(char, narrow):
                return 1
            elif in_table(char, ambiguous):
                return 2
            elif in_table(char, doublewidth):
                return 2
            elif in_table(char, ambiguous) or in_table(char, emoji):
                return 2

            @parameter
            if strict_emoji_neutral:
                return 1

            if in_tables(char, ambiguous):
                return 2
            elif in_table(char, emoji):
                return 2
            elif in_table(char, narrow):
                return 2

            return 1

    fn string_width(self, content: StringSlice) -> Int:
        """Return width as you can see.

        Args:
            content: The string to calculate the width of.

        Returns:
            The printable width of the string.
        """
        var width = 0
        for char in content.chars():
            width += self.char_width(char)
        return width

    fn string_width[T: AsStringSlice, //](self, content: T) -> Int:
        """Return width as you can see.

        Parameters:
            T: The type of the AsStringSlice object.

        Args:
            content: The string to calculate the width of.

        Returns:
            The printable width of the string.
        """
        return self.string_width(content.as_string_slice())

    fn string_width(self, content: StringLiteral) -> Int:
        """Return width as you can see.

        Args:
            content: The string to calculate the width of.

        Returns:
            The printable width of the string.
        """
        return self.string_width(content.as_string_slice())


fn in_tables(char: Char, *tables: InlineArray[Interval]) -> Bool:
    """Check if the char is in any of the tables.

    Args:
        char: The rune to check.
        tables: The tables to check.

    Returns:
        True if the char is in any of the tables, False otherwise.
    """
    for t in tables:
        if in_table(char, t[]):
            return True
    return False


fn in_table(char: Char, table: InlineArray[Interval]) -> Bool:
    """Check if the rune is in the table.

    Args:
        char: The char to check.
        table: The table to check.

    Returns:
        True if the char is in the table, False otherwise.
    """
    var rune = char.to_u32()
    if rune < table[0][0]:
        return False

    var bot = 0
    var top = len(table) - 1
    while top >= bot:
        var mid = (bot + top) >> 1
        if table[mid][1] < rune:
            bot = mid + 1
        elif table[mid][0] > rune:
            top = mid - 1
        else:
            return True

    return False


alias DEFAULT_CONDITION = Condition[east_asian_width=False, strict_emoji_neutral=True]()
"""The default configuration for calculating the width of runes and strings."""


fn string_width[T: AsStringSlice, //](content: T) -> Int:
    """Return width as you can see.

    Parameters:
        T: The type of the AsStringSlice object.

    Args:
        content: The string to calculate the width of.

    Returns:
        The printable width of the string.
    """
    return DEFAULT_CONDITION.string_width(content)


fn string_width(content: StringSlice) -> Int:
    """Return width as you can see.

    Args:
        content: The string to calculate the width of.

    Returns:
        The printable width of the string.
    """
    return DEFAULT_CONDITION.string_width(content)


fn string_width(content: StringLiteral) -> Int:
    """Return width as you can see.

    Args:
        content: The string to calculate the width of.

    Returns:
        The printable width of the string.
    """
    return DEFAULT_CONDITION.string_width(content)


fn char_width(char: Char) -> Int:
    """Return width as you can see.

    Args:
        char: The char to calculate the width of.

    Returns:
        The printable width of the char.
    """
    return DEFAULT_CONDITION.char_width(char)
