from .gojo.bytes import buffer
from .gojo.builtins._bytes import Bytes, to_bytes, to_string
from .gojo.io import traits
from .ansi import writer
from .ansi.ansi import is_terminator, Marker
from .utils import __string__mul__, strip


@value
struct Writer(traits.Writer):
    var buf: buffer.Buffer
    var pw: padding.Writer
    var iw: indent.Writer

    fn __init__(inout self, inout pw: padding.Writer, inout iw: indent.Writer):
        var buf = Bytes()
        self.buf = buffer.Buffer(buf ^)
        self.pw = pw
        self.iw = iw

    # close will finish the margin operation. Always call it before trying to
    # retrieve the final result.
    fn close(inout self) raises:
        _ = self.pw.close()
        _ = self.buf.write(self.pw.bytes())

    # Bytes returns the result as a byte slice.
    fn bytes(self) raises -> Bytes:
        return self.buf.bytes()

    # String returns the result as a string.
    fn string(self) raises -> String:
        return self.buf.string()

    fn write(inout self, src: Bytes) raises -> Int:
        _ = self.iw.write(src)
        let n = self.pw.write(self.iw.bytes())

        return n


fn new_writer(width: UInt8, margin: UInt8) raises -> Writer:
    var pw = padding.new_writer(width)
    var iw = indent.new_writer(margin)

    return Writer(pw, iw)


# Bytes is shorthand for declaring a new default margin-writer instance,
# used to immediately apply a margin to a byte slice.
fn bytes(b: Bytes, width: UInt8, margin: UInt8) raises -> Bytes:
    var f = new_writer(width, margin)
    _ = f.write(b)
    _ = f.close()

    return f.bytes()


# String is shorthand for declaring a new default margin-writer instance,
# used to immediately apply margin a string.
fn string(s: String, width: UInt8, margin: UInt8) raises -> String:
    var buf = to_bytes(s)
    let b = bytes(buf, width, margin)

    return to_string(b)
