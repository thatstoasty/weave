from math.bit import ctlz
from external.gojo.bytes import buffer
from external.gojo.builtins import Result, Byte
import external.gojo.io
from .ansi import writer, is_terminator, Marker, printable_rune_width
from .strings import repeat, strip


@value
struct Writer(Stringable, io.Writer):
    var padding: UInt8

    var ansi_writer: writer.Writer
    var cache: buffer.Buffer
    var line_len: Int
    var ansi: Bool

    fn __init__(
        inout self,
        padding: UInt8,
        line_len: Int = 0,
        ansi: Bool = False,
    ):
        self.padding = padding
        self.line_len = line_len
        self.ansi = ansi

        self.cache = buffer.new_buffer()
        self.ansi_writer = writer.new_default_writer()

    # write is used to write content to the padding buffer.
    fn write(inout self, src: List[Byte]) -> Result[Int]:
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
                self.ansi = True
            elif self.ansi:
                if is_terminator(ord(char)):
                    self.ansi = False
            else:
                if char == "\n":
                    # end of current line, if pad right then add padding before newline
                    self.pad()
                    self.ansi_writer.reset_ansi()
                    self.line_len = 0
                else:
                    self.line_len += printable_rune_width(char)

            var result = self.ansi_writer.write(char.as_bytes())
            if result.error:
                return result

            # Move iterator forward
            bytes -= char_length
            p += char_length

        return len(src)

    fn pad(inout self):
        if self.padding > 0 and UInt8(self.line_len) < self.padding:
            var padding = repeat(
                " ", int(self.padding) - self.line_len
            )
            _ = self.ansi_writer.write(padding.as_bytes())

    # close will finish the padding operation.
    fn close(inout self):
        return self.flush()

    # List[Byte] returns the padded result as a byte slice.
    fn bytes(self) -> List[Byte]:
        return self.cache.bytes()

    # String returns the padded result as a string.
    fn __str__(self) -> String:
        return str(self.cache)

    # flush will finish the padding operation. Always call it before trying to
    # retrieve the final result.
    fn flush(inout self):
        if self.line_len != 0:
            self.pad()

        self.cache.reset()
        _ = self.ansi_writer.forward.write_to(self.cache)
        self.line_len = 0
        self.ansi = False


fn new_writer(width: UInt8) -> Writer:
    return Writer(padding=width)


# fn NewWriterPipe(forward io.Writer, width: UInt8) -> Writer:
# 	return &Writer
# 		padding: width,
# 		Padfn: paddingfn,
# 		ansi_writer: &ansi.Writer
# 			Forward: forward,
# 		,


# List[Byte] is shorthand for declaring a new default padding-writer instance,
# used to immediately pad a byte slice.
fn apply_padding_to_bytes(owned b: List[Byte], width: UInt8) -> List[Byte]:
    var f = new_writer(width)
    _ = f.write(b)
    _ = f.flush()

    return f.bytes()


# String is shorthand for declaring a new default padding-writer instance,
# used to immediately pad a string.
fn apply_padding(owned s: String, width: UInt8) -> String:
    var buf = s.as_bytes()
    var b = apply_padding_to_bytes(buf^, width)
    b.append(0)

    return String(b)
