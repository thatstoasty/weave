from utils import Span, StringSlice
import .ansi
from .bytes import ByteWriter
from .unicode import string_width


struct Writer(Stringable, Movable):
    """A truncating writer that truncates content at the given printable cell width.

    Example Usage:
    ```mojo
    from weave import truncater as truncate

    fn main():
        var writer = truncate.Writer(4, tail=".")
        writer.write("Hello, World!")
        print(writer.consume())
    ```
    .
    """

    var width: Int
    """The maximum printable cell width."""
    var tail: String
    """The tail to append to the truncated content."""
    var ansi_writer: ansi.Writer
    """The ANSI aware writer that stores the text content."""
    var in_ansi: Bool
    """Whether the current character is part of an ANSI escape sequence."""

    fn __init__(out self, width: Int, tail: String, *, in_ansi: Bool = False):
        """Initializes a new truncate-writer instance.

        Args:
            width: The maximum printable cell width.
            tail: The tail to append to the truncated content.
            in_ansi: Whether the current character is part of an ANSI escape sequence.
        """
        self.width = width
        self.tail = tail
        self.in_ansi = in_ansi
        self.ansi_writer = ansi.Writer()

    fn __moveinit__(out self, owned other: Self):
        """Constructs a new `Writer` by taking the content of the other `Writer`.

        Args:
            other: The other `Writer` to take the content from.
        """
        self.width = other.width
        self.tail = other.tail
        self.ansi_writer = other.ansi_writer^
        self.in_ansi = other.in_ansi

    fn __str__(self) -> String:
        """Returns the truncated result as a string by copying the content of the internal buffer.

        Returns:
            The truncated string.
        """
        return str(self.ansi_writer.forward)

    fn consume(inout self) -> String:
        """Returns the truncated result as a string by taking the data from the internal buffer.

        Returns:
            The truncated string.
        """
        return self.ansi_writer.forward.consume()

    fn as_bytes(self) -> Span[Byte, __origin_of(self.ansi_writer.forward)]:
        """Returns the truncated result as a byte list.

        Returns:
            The truncated result as a Byte Span.
        """
        return self.ansi_writer.forward.as_bytes()

    fn write[T: Stringable, //](inout self, content: T) -> None:
        """Writes the text, `content`, to the writer, truncating content at the given printable cell width,
        leaving any ANSI sequences intact.

        Parameters:
            T: The type of the Stringable object.

        Args:
            content: The content to write.
        """
        var text = str(content)
        var tw = ansi.printable_rune_width(self.tail)
        if self.width < tw:
            self.ansi_writer.forward.write(self.tail)
            return

        self.width -= tw
        var cur_width = 0

        for char in text:
            if char == ansi.ANSI_MARKER:
                # ANSI escape sequence
                self.in_ansi = True
            elif self.in_ansi:
                if ansi.is_terminator(ord(char)):
                    # ANSI sequence terminated
                    self.in_ansi = False
            else:
                cur_width += string_width(char)

            if cur_width > self.width:
                self.ansi_writer.forward.write(self.tail)
                if self.ansi_writer.last_sequence() != "":
                    self.ansi_writer.reset_ansi()
                return

            self.ansi_writer.write(char)


fn truncate[T: Stringable, //](text: T, width: Int, tail: String = "") -> String:
    """Truncates `text` at `width` characters. A tail is then added to the end of the string.

    Parameters:
        T: The type of the Stringable object.

    Args:
        text: The string to truncate.
        width: The maximum printable cell width.
        tail: The tail to append to the truncated content.

    Returns:
        A new truncated string.

    ```mojo
    from weave import truncate

    fn main():
        var truncated = truncate("Hello, World!", 5, ".")
        print(truncated)
    ```
    .
    """
    var writer = Writer(width, tail)
    writer.write(text)
    return writer.consume()
