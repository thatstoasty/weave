from collections.string import StringSlice
from memory import Span
from weave.bytes import ByteWriter
from weave.traits import AsStringSlice


fn min_indent(text: StringSlice) -> Int:
    """Detects the indentation level shared by all lines.

    Args:
        text: The text to dedent.

    Returns:
        The minimum indentation level.
    """
    var cur_indent = 0
    var min_indent = 0
    var should_append = True

    for char in text.char_slices():
        if char == "\t" or char == " ":
            if should_append:
                cur_indent += 1
        elif char == "\n":
            cur_indent = 0
            should_append = True
        else:
            if should_append and (min_indent == 0 or cur_indent < min_indent):
                min_indent = cur_indent
                cur_indent = 0
            should_append = False

    return min_indent


fn apply_dedent(text: StringSlice, indent: Int) -> String:
    """Returns a copy `text` that's been dedented
    by removing the shared indentation level.

    Args:
        text: The text to dedent.
        indent: The number of spaces to remove from the beginning of each line.

    Returns:
        A new dedented string.
    """
    var should_omit = True
    var omitted = 0
    var buf = ByteWriter(capacity=Int(text.byte_length() * 1.25))

    for char in text.char_slices():
        if char == "\t" or char == " ":
            if should_omit:
                if omitted < indent:
                    omitted += 1
                    continue
                should_omit = False
            buf.write(char)
        elif char == "\n":
            omitted = 0
            should_omit = True
            buf.write(char)
        else:
            buf.write(char)

    return buf.consume()


fn _dedent(text: StringSlice) -> String:
    """Automatically detects the maximum indentation shared by all lines and
    trims them accordingly.

    Args:
        text: The text to dedent.

    Returns:
        A copy of the original text that's been dedented.
    """
    var indent = min_indent(text)
    if indent == 0:
        return String(text)

    return apply_dedent(text, indent)


# TODO: StringLiteral.as_string_slice() does not conform to the typical
# as_string_slice() function signature. This is a temporary workaround.
fn dedent(text: StringLiteral) -> String:
    """Automatically detects the maximum indentation shared by all lines and
    trims them accordingly.

    Args:
        text: The text to dedent.

    Returns:
        A copy of the original text that's been dedented.

    Examples:
    ```mojo
    from weave import dedent

    fn main() -> None:
        var text = dedent("    Hello, World!\\n    This is a test.\\n    \\n")
        print(text)
    ```
    .
    """
    return _dedent(text.as_string_slice())


fn dedent[T: AsStringSlice, //](text: T) -> String:
    """Automatically detects the maximum indentation shared by all lines and
    trims them accordingly.

    Parameters:
        T: The type of the AsStringSlice object.

    Args:
        text: The text to dedent.

    Returns:
        A copy of the original text that's been dedented.

    Examples:
    ```mojo
    from weave import dedent

    fn main() -> None:
        var text = dedent("    Hello, World!\\n    This is a test.\\n    \\n")
        print(text)
    ```
    .
    """
    return _dedent(text.as_string_slice())
