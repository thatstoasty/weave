from .gojo.bytes import buffer
from .gojo.builtins._bytes import Bytes, to_bytes, to_string
from .ansi import writer
from .ansi.ansi import is_terminator
from .utils import __string__mul__


@value
struct Writer():
    var indent: UInt8

    var ansi_writer: writer.Writer
    var buf: buffer.Buffer
    var skip_indent: Bool
    var ansi: Bool

    fn __init__(inout self, indent: UInt8) raises:
        self.indent = indent

        var buf = Bytes()
        self.buf = buffer.new_buffer(buf)
        self.ansi_writer = writer.Writer(
            self.buf
        )  # This copies the buffer? I should probably try redoing this all with proper pointers
        self.skip_indent = False
        self.ansi = False

    # Bytes returns the indented result as a byte slice.
    fn bytes(self) raises -> Bytes:
        return self.ansi_writer.forward.bytes()

    # String returns the indented result as a string.
    fn string(self) raises -> String:
        return self.ansi_writer.forward.string()

    # write is used to write content to the indent buffer.
    fn write(inout self, b: Bytes) raises -> Int:
        for i in range(len(b)):
            let c = chr(int(b[i]))
            if c == "\x1B":
                # ANSI escape sequence
                self.ansi = True
            elif self.ansi:
                if is_terminator(b[i]):
                    # ANSI sequence terminated
                    self.ansi = False
            else:
                if not self.skip_indent:
                    self.ansi_writer.reset_ansi()
                    let indent = to_bytes(
                        __string__mul__(String(" "), int(self.indent))
                    )
                    _ = self.ansi_writer.write(indent)

                    self.skip_indent = True
                    self.ansi_writer.restore_ansi()

                if c == "\n":
                    # end of current line
                    self.skip_indent = False

            _ = self.ansi_writer.write(to_bytes(c))

        return len(b)


fn new_writer(indent: UInt8) raises -> Writer:
    return Writer(
        indent=indent,
    )


# fn NewWriterPipe(forward io.Writer, indent UInt8, indent_fn Indentfn)-> Writer:
# 	return &Writer
# 		Indent:     indent,
# 		Indentfn: indent_fn,
# 		ansi_writer: &ansi.Writer
# 			Forward: forward,
# 		,
#
#


# Bytes is shorthand for declaring a new default indent-writer instance,
# used to immediately indent a byte slice.
fn bytes(inout b: Bytes, indent: UInt8) raises -> Bytes:
    var f = new_writer(indent)
    _ = f.write(b)

    return f.bytes()


# String is shorthand for declaring a new default indent-writer instance,
# used to immediately indent a string.
fn string(s: String, indent: UInt8) raises -> String:
    var buf = to_bytes(s)
    let b = bytes(buf, indent)

    return to_string(b)
