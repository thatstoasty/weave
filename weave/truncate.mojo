from .gojo.bytes import buffer
from .gojo.builtins._bytes import Bytes, to_bytes, to_string
from .gojo.io import traits
from .ansi import writer
from .ansi.ansi import is_terminator, Marker, printable_rune_width
from .utils import __string__mul__, strip


@value
struct Writer(traits.Writer):
    var width: UInt8
    var tail: String

    var ansi_writer: writer.Writer
    var buf: buffer.Buffer
    var ansi: Bool

    fn __init__(inout self, width: UInt8, tail: String, ansi: Bool = False) raises:
        self.width = width
        self.tail = tail
        self.ansi = ansi

        var buf = Bytes()
        self.buf = buffer.Buffer(buf ^)

        # I think it's copying the buffer for now instead of using the actual buffer
        self.ansi_writer = writer.Writer(self.buf)

    # write truncates content at the given printable cell width, leaving any
    # ansi sequences intact.
    fn write(inout self, src: Bytes) raises -> Int:
        # TODO: Normally rune length
        let tw = printable_rune_width(self.tail)
        if self.width < UInt8(tw):
            return self.ansi_writer.forward.write_string(self.tail)

        self.width -= UInt8(tw)
        var cur_width: UInt8 = 0

        for i in range(len(src)):
            let c = chr(int(src[i]))
            if c == Marker:
                # ANSI escape sequence
                self.ansi = True
            elif self.ansi:
                if is_terminator(src[i]):
                    # ANSI sequence terminated
                    self.ansi = False
            else:
                cur_width += UInt8(len(c))

            if cur_width > self.width:
                let n = self.ansi_writer.forward.write_string(self.tail)
                if self.ansi_writer.last_sequence() != "":
                    self.ansi_writer.reset_ansi()
                return n

            _ = self.ansi_writer.write_byte(src[i])

        return len(src)

    # Bytes returns the truncated result as a byte slice.
    fn bytes(self) raises -> Bytes:
        return self.ansi_writer.forward.bytes()

    # String returns the truncated result as a string.
    fn string(self) raises -> String:
        return self.ansi_writer.forward.string()


fn new_writer(width: UInt8, tail: String) raises -> Writer:
    return Writer(width, tail)


# fn NewWriterPipe(forward io.Writer, width: UInt8, tail string)-> Writer:
# 	return &Writer
# 		width: width,
# 		tail:  tail,
# 		ansi_writer: &ansi.Writer
# 			Forward: forward,
# 		,


# Bytes is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a byte slice.
fn bytes(b: Bytes, width: UInt8) raises -> Bytes:
    let tail = Bytes()
    return bytes_with_tail(b, width, tail)


# Bytes is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a byte slice. A tail is then added to the
# end of the byte slice.
fn bytes_with_tail(b: Bytes, width: UInt8, tail: Bytes) raises -> Bytes:
    var f = new_writer(width, to_string(tail))
    _ = f.write(b)

    return f.bytes()


# String is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a string.
fn string(s: String, width: UInt8) raises -> String:
    return string_with_tail(s, width, "")


# string_with_tail is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a string. A tail is then added to the end of the
# string.
fn string_with_tail(s: String, width: UInt8, tail: String) raises -> String:
    var buf = to_bytes(s)
    var tail_bytes = to_bytes(tail)
    let b = bytes_with_tail(buf, width, tail_bytes)
    return to_string(b)
