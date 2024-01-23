from weave.gojo.io import io
from weave.gojo.bytes import buffer
from weave.gojo.bytes import bytes as bt
from weave.gojo.bytes.bytes import Byte
from weave.ansi import writer
from weave.ansi.ansi import is_terminator
from weave.stdlib.builtins.string import __string__mul__


struct Writer():
	var indent: UInt8

	var ansi_writer: writer.Writer
	var buf: buffer.Buffer
	var skip_indent: Bool
	var ansi: Bool

	fn __init__(inout self, indent: UInt8) raises:
		self.indent = indent

		self.buf = buffer.new_buffer(DynamicVector[Byte]())
		self.ansi_writer = writer.Writer(self.buf) # This copies the buffer? I should probably try redoing this all with proper pointers
		self.skip_indent = False
		self.ansi = False

	# Bytes returns the indented result as a byte slice.
	fn bytes(self) -> DynamicVector[Byte]:
		return self.ansi_writer.forward.bytes()


	# String returns the indented result as a string.
	fn string(self) -> String:
		return self.ansi_writer.forward.string()
	
	# Write is used to write content to the indent buffer.
	fn write(inout self, b: DynamicVector[Byte]) raises -> Int:
		for i in range(len(b)):
			let c = chr(int(b[i]))
			if c == '\x1B':
				# ANSI escape sequence
				self.ansi = True
			elif self.ansi:
				if is_terminator(b[i]):
					# ANSI sequence terminated
					self.ansi = False
			else:
				if not self.skip_indent:
					self.ansi_writer.reset_ansi()
					let indent = __string__mul__(" ", int(self.indent))._buffer
					_ = self.ansi_writer.write(indent)

					self.skip_indent = True
					self.ansi_writer.restore_ansi()

				if c == '\n':
					# end of current line
					self.skip_indent = False

			_ = self.ansi_writer.write(c._buffer)

		return len(b)


fn new_writer(indent: UInt8) raises -> Writer:
	return Writer(
		indent=indent,
	)


# fn NewWriterPipe(forward io.Writer, indent UInt8, indent_func IndentFunc) *Writer {
# 	return &Writer{
# 		Indent:     indent,
# 		IndentFunc: indent_func,
# 		ansi_writer: &ansi.Writer{
# 			Forward: forward,
# 		},
# 	}
# }

# Bytes is shorthand for declaring a new default indent-writer instance,
# used to immediately indent a byte slice.
fn bytes(inout b: DynamicVector[Byte], indent: UInt8) raises -> DynamicVector[Byte]:
	var f = new_writer(indent)
	_ = f.write(b)

	return f.bytes()


# String is shorthand for declaring a new default indent-writer instance,
# used to immediately indent a string.
fn to_string(s: String, indent: UInt8) raises -> String:
	var buf = s._buffer
	let b = bytes(buf, indent)

	return bt.to_string(b)
