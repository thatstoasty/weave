from utils import StringSlice
from memory import Span
from weave.unicode import string_width, char_width
from weave.bytes import ByteWriter
from weave.traits import AsStringSlice


alias ANSI_ESCAPE = "[0m"
alias ANSI_ESCAPE_BYTE = ord(ANSI_ESCAPE)
alias ANSI_MARKER = "\x1b"
alias ANSI_MARKER_BYTE = ord(ANSI_MARKER)
alias SGR_COMMAND = ord("m")


fn equals(left: Span[Byte], right: Span[Byte]) -> Bool:
    """Reports if `left` and `right` are equal.

    Args:
        left: The first bytes to compare.
        right: The second bytes to compare.

    Returns:
        True if the bytes are equal, False otherwise.
    """
    if len(left) != len(right):
        return False

    for i in range(len(left)):
        if left[i] != right[i]:
            return False
    return True


fn has_suffix(bytes: Span[Byte], suffix: Span[Byte]) -> Bool:
    """Reports if the list ends with suffix.

    Args:
        bytes: The bytes to search.
        suffix: The suffix to search for.

    Returns:
        True if the bytes end with the suffix, False otherwise.
    """
    if len(bytes) < len(suffix):
        return False

    if not equals(bytes[len(bytes) - len(suffix) : len(bytes)], suffix):
        return False
    return True


fn is_terminator(c: Char) -> Bool:
    """Reports if the rune is a terminator.

    Args:
        c: The rune to check.

    Returns:
        True if the rune is a terminator, False otherwise.
    """
    var rune = c.to_u32()
    return (rune >= 0x40 and rune <= 0x5A) or (rune >= 0x61 and rune <= 0x7A)


fn printable_rune_width(text: StringSlice) -> Int:
    """Returns the cell width of the given string.

    Args:
        text: String to calculate the width of.

    Returns:
        The printable cell width of the string.
    """
    var length = 0
    var ansi = False

    for char in text.chars():
        if char.utf8_byte_length() > 1:
            length += char_width(char)
            continue

        if char.to_u32() == ANSI_MARKER_BYTE:
            # ANSI escape sequence
            ansi = True
        elif ansi:
            if is_terminator(char):
                # ANSI sequence terminated
                ansi = False
        else:
            length += char_width(char)

    return length


fn printable_rune_width(text: StringLiteral) -> Int:
    """Returns the cell width of the given string.

    Args:
        text: String to calculate the width of.

    Returns:
        The printable cell width of the string.
    """
    return printable_rune_width(text.as_string_slice())


fn printable_rune_width[T: AsStringSlice, //](text: T) -> Int:
    """Returns the cell width of the given string.

    Parameters:
        T: The type of the AsStringSlice object.

    Args:
        text: String to calculate the width of.

    Returns:
        The printable cell width of the string.
    """
    return printable_rune_width(text.as_string_slice())


struct Writer:
    """A writer that handles ANSI escape sequences in the content.

    Example Usage:
    ```mojo
    from weave import ansi

    fn main():
        var writer = ansi.Writer()
        writer.write("Hello, World!")
        print(writer.forward)
    ```
    .
    """

    var forward: ByteWriter
    """The buffer that stores the text content."""
    var ansi: Bool
    """Whether the current character is part of an ANSI escape sequence."""
    var ansi_seq: ByteWriter
    """The buffer that stores the ANSI escape sequence."""
    var last_seq: ByteWriter
    """The buffer that stores the last ANSI escape sequence."""
    var seq_changed: Bool
    """Whether the ANSI escape sequence has changed."""

    fn __init__(out self, owned forward: ByteWriter = ByteWriter()):
        """Initializes a new ANSI-writer instance.

        Args:
            forward: The buffer that stores the text content.
        """
        self.forward = forward^
        self.ansi = False
        self.ansi_seq = ByteWriter(capacity=128)
        self.last_seq = ByteWriter(capacity=128)
        self.seq_changed = False

    fn __moveinit__(out self, owned other: Writer):
        """Constructs a new `Writer` by taking the content of the other `Writer`.

        Args:
            other: The other `Writer` to take the content from.
        """
        self.forward = other.forward^
        self.ansi = other.ansi
        self.ansi_seq = other.ansi_seq^
        self.last_seq = other.last_seq^
        self.seq_changed = other.seq_changed

    fn write(mut self, content: StringSlice) -> None:
        """Write content to the ANSI buffer.

        Args:
            content: The content to write.
        """
        for char in content.chars():
            self.write(char)

    fn write(mut self, char: Char) -> None:
        """Write char to the ANSI buffer.

        Args:
            char: The content to write.
        """
        # ANSI escape sequence
        if char.to_u32() == ANSI_MARKER_BYTE:
            self.ansi = True
            self.seq_changed = True
            self.ansi_seq.write(char)
        elif self.ansi:
            self.ansi_seq.write(char)
            if is_terminator(char):
                self.ansi = False
                if self.ansi_seq.as_string_slice().startswith(ANSI_ESCAPE):
                    # reset sequence
                    self.last_seq.reset()
                    self.seq_changed = False
                elif char.to_u32() == SGR_COMMAND:
                    # color code
                    self.last_seq.write(self.ansi_seq)

                self.forward.write(self.ansi_seq)
        else:
            self.forward.write(char)

    fn last_sequence(self) -> StringSlice[__origin_of(self.last_seq)]:
        """Returns the last ANSI escape sequence.

        Returns:
            The last ANSI escape sequence.
        """
        return self.last_seq.as_string_slice()

    fn reset_ansi(mut self) -> None:
        """Resets the ANSI escape sequence."""
        if not self.seq_changed:
            return

        self.forward.write(ANSI_MARKER + ANSI_ESCAPE)

    fn restore_ansi(mut self) -> None:
        """Restores the last ANSI escape sequence."""
        self.forward.write(self.last_seq)
