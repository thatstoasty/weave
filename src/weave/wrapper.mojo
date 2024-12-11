from utils import StringSlice
from memory import Span
from .unicode import string_width
from .bytes import ByteWriter
import .ansi
import .word_wrapper

alias DEFAULT_NEWLINE = "\n"
alias DEFAULT_TAB_WIDTH = 4


struct Writer(Stringable, Movable):
    """A line wrapping writer that wraps content based on the given limit.

    Example Usage:
    ```mojo
    from weave import wrapper as wrap

    fn main():
        var writer = wrap.Writer(5)
        writer.write("Hello, World!")
        print(writer.consume())
    ```
    """

    var limit: Int
    """The maximum number of characters per line."""
    var newline: String
    """The character to use as a newline."""
    var keep_newlines: Bool
    """Whether to keep newlines in the content."""
    var preserve_space: Bool
    """Whether to preserve space characters."""
    var tab_width: Int
    """The width of a tab character."""
    var buf: ByteWriter
    """The buffer that stores the wrapped content."""
    var line_len: Int
    """The current line length."""
    var ansi: Bool
    """Whether the current character is part of an ANSI escape sequence."""
    var forceful_newline: Bool
    """Whether to force a newline at the end of the line."""

    fn __init__(
        out self,
        limit: Int,
        *,
        newline: String = DEFAULT_NEWLINE,
        keep_newlines: Bool = True,
        preserve_space: Bool = False,
        tab_width: Int = DEFAULT_TAB_WIDTH,
        line_len: Int = 0,
        ansi: Bool = False,
        forceful_newline: Bool = False,
    ):
        """Initializes a new line wrap writer.

        Args:
            limit: The maximum number of characters per line.
            newline: The character to use as a newline.
            keep_newlines: Whether to keep newlines in the content.
            preserve_space: Whether to preserve space characters.
            tab_width: The width of a tab character.
            line_len: The current line length.
            ansi: Whether the current character is part of an ANSI escape sequence.
            forceful_newline: Whether to force a newline at the end of the line.
        """
        self.limit = limit
        self.newline = newline
        self.keep_newlines = keep_newlines
        self.preserve_space = preserve_space
        self.tab_width = tab_width
        self.buf = ByteWriter()
        self.line_len = line_len
        self.ansi = ansi
        self.forceful_newline = forceful_newline

    fn __moveinit__(out self, owned other: Self):
        """Constructs a new `Writer` by taking the content of the other `Writer`.

        Args:
            other: The other `Writer` to take the content from.
        """
        self.limit = other.limit
        self.newline = other.newline
        self.keep_newlines = other.keep_newlines
        self.preserve_space = other.preserve_space
        self.tab_width = other.tab_width
        self.buf = other.buf^
        self.line_len = other.line_len
        self.ansi = other.ansi
        self.forceful_newline = other.forceful_newline

    fn __str__(self) -> String:
        """Returns the wrapped result as a string by copying the content of the internal buffer.

        Returns:
            The wrapped string.
        """
        return str(self.buf)

    fn consume(mut self) -> String:
        """Returns the wrapped result as a string by taking the data from the internal buffer.

        Returns:
            The wrapped string.
        """
        return self.buf.consume()

    fn as_bytes(self) -> Span[Byte, __origin_of(self.buf)]:
        """Returns the result as a byte span.

        Returns:
            The wrapped result as a byte span.
        """
        return self.buf.as_bytes()

    fn add_newline(mut self) -> None:
        """Adds a newline to the buffer and resets the line length."""
        self.buf.write(self.newline)
        self.line_len = 0

    fn write[T: Stringable, //](mut self, content: T) -> None:
        """Writes the text, `content`, to the writer, wrapping lines once the limit is reached.

        Parameters:
            T: The type of the Stringable object to dedent.

        Args:
            content: The text to write to the writer.
        """
        var text = str(content)
        var tab_space = SPACE * self.tab_width
        text = text.replace("\t", tab_space)
        if not self.keep_newlines:
            text = text.replace("\n", "")

        var width = ansi.printable_rune_width(text)
        if self.limit <= 0 or self.line_len + width <= self.limit:
            self.line_len += width
            self.buf.write(text)
            return

        for char in text:
            if char == ansi.ANSI_MARKER:
                self.ansi = True
            elif self.ansi:
                if ansi.is_terminator(ord(char)):
                    self.ansi = False
            elif char == NEWLINE:
                self.add_newline()
                self.forceful_newline = False
                continue
            else:
                var width = string_width(char)

                if self.line_len + width > self.limit:
                    self.add_newline()
                    self.forceful_newline = True

                if self.line_len == 0:
                    if self.forceful_newline and not self.preserve_space and char == SPACE:
                        continue
                else:
                    self.forceful_newline = False

                self.line_len += width
            self.buf.write_bytes(char.as_bytes())


fn wrap[
    T: Stringable, //
](
    text: T,
    limit: Int,
    *,
    newline: String = DEFAULT_NEWLINE,
    keep_newlines: Bool = True,
    preserve_space: Bool = False,
    tab_width: Int = DEFAULT_TAB_WIDTH,
) -> String:
    """Wraps `text` at `limit` characters per line.

    Parameters:
        T: The type of the Stringable object to dedent.

    Args:
        text: The string to wrap.
        limit: The maximum line length before wrapping.
        newline: The character to use as a newline.
        keep_newlines: Whether to keep newlines in the content.
        preserve_space: Whether to preserve space characters.
        tab_width: The width of a tab character.

    Returns:
        A new wrapped string.

    ```mojo
    from weave import wrap

    fn main():
        var wrapped = wrap("Hello, World!", 5)
        print(wrapped)
    ```
    .
    """
    var writer = Writer(
        limit, newline=newline, keep_newlines=keep_newlines, preserve_space=preserve_space, tab_width=tab_width
    )
    writer.write(text)
    return writer.consume()
