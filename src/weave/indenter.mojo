from utils import StringSlice
from memory import Span
import .ansi


struct Writer(Stringable, Movable):
    """A writer that indents content by a given number of spaces.

    Example Usage:
    ```mojo
    from weave import indenter as indent

    fn main():
        var writer = indent.Writer(4)
        writer.write("Hello, World!")
        print(str(writer))
    ```
    """

    var indent: Int
    """The number of spaces to indent each line."""
    var ansi_writer: ansi.Writer
    """The ANSI aware writer that stores the text content."""
    var skip_indent: Bool
    """Whether to skip the indentation for the next line."""
    var in_ansi: Bool
    """Whether the current character is part of an ANSI escape sequence."""

    fn __init__(out self, indent: Int):
        """Initializes a new indent-writer instance.

        Args:
            indent: The number of spaces to indent each line.
        """
        self.indent = indent
        self.ansi_writer = ansi.Writer()
        self.skip_indent = False
        self.in_ansi = False

    fn __moveinit__(out self, owned other: Self):
        """Constructs a new `Writer` by taking the content of the other `Writer`.

        Args:
            other: The other `Writer` to take the content from.
        """
        self.indent = other.indent
        self.ansi_writer = other.ansi_writer^
        self.skip_indent = other.skip_indent
        self.in_ansi = other.in_ansi

    fn __str__(self) -> String:
        """Returns the indented result as a string by copying the content of the internal buffer.

        Returns:
            The indented string.
        """
        return str(self.ansi_writer.forward)

    fn consume(mut self) -> String:
        """Returns the indented result as a string by taking the data from the internal buffer.

        Returns:
            The indented string.
        """
        return self.ansi_writer.forward.consume()

    fn write[T: Stringable, //](mut self, content: T) -> None:
        """Writes the text, `content`, to the writer,
        indenting each line by `self.indent` spaces.

        Parameters:
            T: The type of the Stringable object.

        Args:
            content: The String to write.
        """
        var text = str(content)
        for char in text:
            # ANSI escape sequence
            if char == ansi.ANSI_MARKER:
                self.in_ansi = True
            elif self.in_ansi:
                # ANSI sequence terminated
                if ansi.is_terminator(ord(char)):
                    self.in_ansi = False
            else:
                if not self.skip_indent:
                    self.ansi_writer.reset_ansi()
                    self.ansi_writer.write(SPACE * int(self.indent))
                    self.skip_indent = True
                    self.ansi_writer.restore_ansi()

                # end of current line
                if char == NEWLINE:
                    self.skip_indent = False

            self.ansi_writer.write(char)


fn indent[T: Stringable, //](text: T, indent: Int) -> String:
    """Indents `text` with a `indent` number of spaces.

    Parameters:
        T: The type of the Stringable object.

    Args:
        text: The string to indent.
        indent: The number of spaces to indent.

    Returns:
        A new indented string.

    Examples:
    ```mojo
    from weave import indent

    fn main():
        print(indent("Hello, World!", 4))
    ```
    .
    """
    var writer = Writer(indent)
    writer.write(text)
    return writer.consume()
