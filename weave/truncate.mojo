from math.bit import ctlz
from external.gojo.bytes import buffer
from external.gojo.builtins import Result, Byte
import external.gojo.io
from .ansi import writer, is_terminator, Marker, printable_rune_width
from .strings import repeat, strip


@value
struct Writer(Stringable, io.Writer):
    var width: UInt8
    var tail: String

    var ansi_writer: writer.Writer
    var ansi: Bool

    fn __init__(inout self, width: UInt8, tail: String, ansi: Bool = False):
        self.width = width
        self.tail = tail
        self.ansi = ansi

        # I think it's copying the buffer for now instead of using the actual buffer
        self.ansi_writer = writer.new_default_writer()

    # write truncates content at the given printable cell width, leaving any
    # ansi sequences intact.
    fn write(inout self, src: List[Int8]) -> Result[Int]:
        var tw = printable_rune_width(self.tail)
        if self.width < UInt8(tw):
            return self.ansi_writer.forward.write_string(self.tail)

        self.width -= UInt8(tw)
        var cur_width: UInt8 = 0

        # Rune iterator
        var bytes = len(src)
        var p = DTypePointer[DType.int8](src.data.value).bitcast[DType.uint8]()
        while bytes > 0:
            var char_length = ((p.load() >> 7 == 0).cast[DType.uint8]() * 1 + ctlz(~p.load())).to_int()
            var sp = DTypePointer[DType.int8].alloc(char_length + 1)
            memcpy(sp, p.bitcast[DType.int8](), char_length)
            sp[char_length] = 0

            # Functional logic
            var char = String(sp, char_length + 1)
            if char == Marker:
                # ANSI escape sequence
                self.ansi = True
            elif self.ansi:
                if is_terminator(ord(char)):
                    # ANSI sequence terminated
                    self.ansi = False
            else:
                cur_width += UInt8(printable_rune_width(char))

            if cur_width > self.width:
                var n = self.ansi_writer.forward.write_string(self.tail)
                if self.ansi_writer.last_sequence() != "":
                    self.ansi_writer.reset_ansi()
                return n

            _ = self.ansi_writer.write(char.as_bytes())

            bytes -= char_length
            p += char_length

        return len(src)

    # List[Byte] returns the truncated result as a byte slice.
    fn bytes(self) -> List[Byte]:
        return self.ansi_writer.forward.bytes()

    # String returns the truncated result as a string.
    fn __str__(self) -> String:
        return str(self.ansi_writer.forward)


fn new_writer(width: UInt8, tail: String) -> Writer:
    return Writer(width, tail)


# fn NewWriterPipe(forward io.Writer, width: UInt8, tail string)-> Writer:
# 	return &Writer
# 		width: width,
# 		tail:  tail,
# 		ansi_writer: &ansi.Writer
# 			Forward: forward,
# 		,


# List[Byte] is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a byte slice.
fn apply_truncate_to_bytes(owned b: List[Byte], width: UInt8) -> List[Byte]:
    return apply_truncate_to_bytes_with_tail(b^, width, "")


# List[Byte] is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a byte slice. A tail is then added to the
# end of the byte slice.
fn apply_truncate_to_bytes_with_tail(
    owned b: List[Byte], width: UInt8, tail: String
) -> List[Byte]:
    var f = new_writer(width, str(tail))
    _ = f.write(b)

    return f.bytes()


# String is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a string.
fn apply_truncate(owned s: String, width: UInt8) -> String:
    return apply_truncate_with_tail(s^, width, "")


# string_with_tail is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a string. A tail is then added to the end of the
# string.
fn apply_truncate_with_tail(
    owned s: String, width: UInt8, tail: String
) -> String:
    var buf = s.as_bytes()
    var b = apply_truncate_to_bytes_with_tail(buf^, width, tail)
    b.append(0)
    return String(b)
