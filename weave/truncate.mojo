from weave.gojo.bytes import buffer
from weave.gojo.bytes import bytes as bt
from weave.gojo.bytes.bytes import Byte
from weave.gojo.bytes.util import trim_null_characters
from weave.ansi import writer
from weave.ansi.ansi import is_terminator, Marker
from weave.stdlib.builtins.string import __string__mul__, strip
from weave.stdlib.builtins.vector import contains


struct Writer():
    var width: UInt8
    var tail: String

    var ansi_writer: writer.Writer
    var buf: buffer.Buffer
    var ansi: Bool

    fn __init__(inout self):
        pass
    
    # write truncates content at the given printable cell width, leaving any
    # ansi sequences intact.
    fn write(b: DynamicVector[Byte]) -> Int:
        tw := ansi.PrintableRuneWidth(self.tail)
        if self.width < UInt8(tw) 
            return self.buf.WriteString(self.tail)
        

        self.width -= UInt8(tw)
        var curWidth UInt8

        for _, c := range string(b) 
            if c == ansi.Marker 
                # ANSI escape sequence
                self.ansi = True
            else if self.ansi 
                if ansi.IsTerminator(c) 
                    # ANSI sequence terminated
                    self.ansi = False
                
            else 
                curWidth += UInt8(runewidth.RuneWidth(c))
            

            if curWidth > self.width 
                n, err := self.buf.WriteString(self.tail)
                if self.ansi_writer.LastSequence() != "" 
                    self.ansi_writer.reset_ansi()
                
                return n, err
            

            _, err := self.ansi_writer.write([]byte(string(c)))
            if err != nil 
                return 0, err
            
        

        return len(b), nil


    # Bytes returns the truncated result as a byte slice.
    fn bytes() -> DynamicVector[Byte]:
        return self.buf.bytes()


    # String returns the truncated result as a string.
    fn -> String:() -> String: 
        return self.buf.String()



fn new_writer(width: UInt8, tail string)-> Writer:
	w := &Writer
		width: width,
		tail:  tail,
	
	self.ansi_writer = &ansi.Writer
		Forward: &self.buf,
	
	return w


fn NewWriterPipe(forward io.Writer, width: UInt8, tail string)-> Writer:
	return &Writer
		width: width,
		tail:  tail,
		ansi_writer: &ansi.Writer
			Forward: forward,
		,
	


# Bytes is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a byte slice.
fn bytes(b: DynamicVector[Byte], width: UInt8) -> DynamicVector[Byte]:
	return BytesWithTail(b, width, []byte(""))


# Bytes is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a byte slice. A tail is then added to the
# end of the byte slice.
fn BytesWithTail(b: DynamicVector[Byte], width: UInt8, tail []byte) -> DynamicVector[Byte]:
	f := new_writer(width, string(tail))
	_, _ = f.write(b)

	return f.bytes()


# String is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a string.
fn String(s: String, width: UInt8) -> String: 
	return StringWithTail(s, width, "")


# StringWithTail is shorthand for declaring a new default truncate-writer instance,
# used to immediately truncate a string. A tail is then added to the end of the
# string.
fn StringWithTail(s: String, width: UInt8, tail string) -> String: 
	return string(BytesWithTail([]byte(s), width, []byte(tail)))


