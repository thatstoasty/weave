from weave.gojo.bytes import buffer
from weave.gojo.bytes import bytes as bt
from weave.gojo.bytes.bytes import Byte
from weave.ansi import writer
from weave.ansi.ansi import is_terminator, Marker
from weave.stdlib.builtins.string import __string__mul__


alias default_newline = '\n'
alias default_tab_width = 4


struct Wrap():
    var limit: Int
    var newline: String
    var keep_newlines: Bool
    var preserve_space: Bool
    var tab_width: Int

    var buf: buffer.Buffer
    var line_len: Int
    var ansi: Bool
    var forceful_newline: Bool

    fn __init__(
        inout self, 
        limit: Int,
        newline: String = default_newline,
        keep_newlines: Bool = True,
        preserve_space: Bool = False,
        tab_width: Int = default_tab_width,
        line_len: Int = 0,
        ansi: Bool = False,
        forceful_newline: Bool = False
        ):
        self.limit = limit
        self.newline = newline
        self.keep_newlines = keep_newlines
        self.preserve_space = preserve_space
        self.tab_width = tab_width

        # TODO: Ownership of the DynamicVector should be moved to the buffer
        var buf = DynamicVector[Byte]()
        self.buf = buffer.new_buffer(buf=buf)
        self.line_len = line_len
        self.ansi = ansi
        self.forceful_newline = forceful_newline
    
    fn add_new_line(inout self) raises:
        _ = self.buf.write_byte(ord('\n'))
        self.line_len = 0
    
    fn write(inout self, b: DynamicVector[Byte]) raises -> Int:
        let tab_space = __string__mul__(' ', self.tab_width)
        var s = bt.to_string(b)

        s = s.replace("\t", tab_space)
        if not self.keep_newlines:
            s = s.replace("\n", "")
        
        let width = len(s)
        if self.limit <= 0 or self.line_len + width <= self.limit:
            self.line_len += width
            return self.buf.write(b)

        for i in range(len(s)):
            let c = s[i]
            if c == Marker:
                self.ansi = True
            elif self.ansi:
                if is_terminator(ord(c)):
                    self.ansi = False
            elif c == "\n":
                self.add_new_line()
                self.forceful_newline = False
            else:
                let width = len(c)

                if self.line_len + width > self.limit:
                    self.add_new_line()
                    self.forceful_newline = True
                
                if self.line_len == 0:
                    if self.forceful_newline and not self.preserve_space and c == " ":
                        continue
                else:
                    self.forceful_newline = False
                
                self.line_len += width
            
            _ = self.buf.write_string(c)
            # _ = self.buf.write_byte(ord(c))

        return len(b)

    # Bytes returns the wrapped result as a byte slice.
    fn bytes(self) -> DynamicVector[Byte]:
        return self.buf.bytes()

    # String returns the wrapped result as a string.
    fn string(self) -> String:
        return self.buf.string()


# new_writer returns a new instance of a wrapping writer, initialized with
# default settings.
fn new_writer(limit: Int) -> Wrap:
    return Wrap(
        limit=limit
    )

# Bytes is shorthand for declaring a new default Wrap instance,
# used to immediately wrap a byte slice.
fn bytes(inout b: DynamicVector[Byte], limit: Int) raises -> DynamicVector[Byte]:
	var f = new_writer(limit)
	_ = f.write(b)

	return f.bytes()


# String is shorthand for declaring a new default Wrap instance,
# used to immediately wrap a string.
fn to_string(s: String, limit: Int) raises -> String:
	var buf = s._buffer
	let b = bytes(buf, limit)

	return bt.to_string(b)


fn in_group(a: DynamicVector[Byte], c: Byte) -> Bool:
    for i in range(len(a)):
        let v = a[i]
        if v == c:
            return True
    return False