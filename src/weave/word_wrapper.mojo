from utils import StringSlice
from memory import Span
import .ansi
from .bytes import ByteWriter


alias DEFAULT_NEWLINE = "\n"
alias DEFAULT_BREAKPOINT = "-"


struct Writer(Stringable, Movable):
    """A word-wrapping writer that wraps content based on words at the given limit.

    Example Usage:
    ```mojo
    from weave import word_wrapper as word_wrap

    fn main():
        var writer = word_wrap.Writer(5)
        writer.write("Hello, World!")
        _ = writer.close()
        print(writer.consume())
    ```
    .
    """

    var limit: Int
    """The maximum number of characters per line."""
    var breakpoint: String
    """The character to use as a breakpoint."""
    var newline: String
    """The character to use as a newline."""
    var keep_newlines: Bool
    """Whether to keep newlines in the content."""
    var buf: ByteWriter
    """The buffer that stores the word-wrapped content."""
    var space: ByteWriter
    """The buffer that stores the space between words."""
    var word: ByteWriter
    """The buffer that stores the current word."""
    var line_len: Int
    """The current line length."""
    var ansi: Bool
    """Whether the current character is part of an ANSI escape sequence."""

    fn __init__(
        out self,
        limit: Int,
        *,
        breakpoint: String = DEFAULT_BREAKPOINT,
        newline: String = DEFAULT_NEWLINE,
        keep_newlines: Bool = True,
        line_len: Int = 0,
        ansi: Bool = False,
    ):
        """Initializes a new word wrap writer.

        Args:
            limit: The maximum number of characters per line.
            breakpoint: The character to use as a breakpoint.
            newline: The character to use as a newline.
            keep_newlines: Whether to keep newlines in the content.
            line_len: The current line length.
            ansi: Whether the current character is part of an ANSI escape sequence.
        """
        self.limit = limit
        self.breakpoint = breakpoint
        self.newline = newline
        self.keep_newlines = keep_newlines
        self.buf = ByteWriter()
        self.space = ByteWriter()
        self.word = ByteWriter()
        self.line_len = line_len
        self.ansi = ansi

    fn __moveinit__(out self, owned other: Self):
        """Constructs a new `Writer` by taking the content of the other `Writer`.

        Args:
            other: The other `Writer` to take the content from.
        """
        self.limit = other.limit
        self.breakpoint = other.breakpoint
        self.newline = other.newline
        self.keep_newlines = other.keep_newlines
        self.buf = other.buf^
        self.space = other.space^
        self.word = other.word^
        self.line_len = other.line_len
        self.ansi = other.ansi

    fn __str__(self) -> String:
        """Returns the word wrapped result as a string by copying the content of the internal buffer.

        Returns:
            The word wrapped string.
        """
        return str(self.buf)

    fn consume(mut self) -> String:
        """Returns the word wrapped result as a string by taking the data from the internal buffer.

        Returns:
            The word wrapped string.
        """
        return self.buf.consume()

    fn as_bytes(self) -> Span[Byte, __origin_of(self.buf)]:
        """Returns the word wrapped result as a byte list.

        Returns:
            The word wrapped result as a Byte Span.
        """
        return self.buf.as_bytes()

    fn add_space(mut self):
        """Write the content of the space buffer to the word-wrap buffer."""
        self.line_len += len(self.space)
        self.buf.write(self.space)
        self.space.reset()

    fn add_word(mut self):
        """Write the content of the word buffer to the word-wrap buffer."""
        if len(self.word) > 0:
            self.add_space()
            word = self.word.consume(reuse=True)
            self.line_len += ansi.printable_rune_width(word)
            self.buf.write(word)

    fn add_newline(mut self):
        """Write a newline to the word-wrap buffer and reset the line length & space buffer."""
        self.buf.write(NEWLINE)
        self.line_len = 0
        self.space.reset()

    fn write[T: Stringable, //](mut self, content: T) -> None:
        """Writes the text, `content`, to the writer, wrapping lines once the limit is reached.
        If the word cannot fit on the line, then it will be written to the next line.

        Parameters:
            T: The type of the Stringable object.

        Args:
            content: The content to write.
        """
        var text = str(content)
        if self.limit == 0:
            self.buf.write(text)
            return

        if not self.keep_newlines:
            text = str(text.strip()).replace("\n", " ")

        for char in text:
            # ANSI escape sequence
            if char == ansi.ANSI_MARKER:
                self.word.write_bytes(char.as_bytes())
                self.ansi = True
            elif self.ansi:
                self.word.write_bytes(char.as_bytes())

                # ANSI sequence terminated
                if ansi.is_terminator(ord(char)):
                    self.ansi = False

            # end of current line
            # see if we can add the content of the space buffer to the current line
            elif char == self.newline:
                if len(self.word) == 0:
                    if self.line_len + len(self.space) > self.limit:
                        self.line_len = 0

                    # preserve whitespace
                    else:
                        self.buf.write(self.space)
                    self.space.reset()
                self.add_word()
                self.add_newline()

            # end of current word
            elif char == SPACE:
                self.add_word()
                self.space.write(SPACE)

            # valid breakpoint
            elif char == self.breakpoint:
                self.add_space()
                self.add_word()
                self.buf.write(self.breakpoint)

            # any other character
            else:
                self.word.write_bytes(char.as_bytes())

                # add a line break if the current word would exceed the line's
                # character limit
                var word_width = ansi.printable_rune_width(str(self.word))
                if word_width < self.limit and self.line_len + len(self.space) + word_width > self.limit:
                    self.add_newline()

    fn close(mut self):
        """Finishes the word-wrap operation. Always call it before trying to retrieve the final result."""
        self.add_word()


fn word_wrap[
    T: Stringable, //
](
    text: T,
    limit: Int,
    *,
    newline: String = DEFAULT_NEWLINE,
    keep_newlines: Bool = True,
    breakpoint: String = DEFAULT_BREAKPOINT,
) -> String:
    """Wraps `text` at `limit` characters per line, if the word can fit on the line.
    Otherwise, it will break prior to adding the word, then add it to the next line.

    Parameters:
        T: The type of the Stringable object.

    Args:
        text: The string to wrap.
        limit: The maximum number of characters per line.
        newline: The character to use as a newline.
        keep_newlines: Whether to keep newlines in the content.
        breakpoint: The character to use as a breakpoint.

    Returns:
        A new word wrapped string.

    ```mojo
    from weave import word_wrap

    fn main():
        var wrapped = word_wrap("Hello, World!", 5)
        print(wrapped)
    ```
    .
    """
    var writer = Writer(limit, newline=newline, keep_newlines=keep_newlines, breakpoint=breakpoint)
    writer.write(text)
    writer.close()
    return writer.consume()
