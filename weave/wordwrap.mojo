from weave.gojo.bytes import buffer
from weave.gojo.bytes import bytes as bt
from weave.gojo.bytes.bytes import Byte
from weave.gojo.bytes.util import trim_null_characters
from weave.ansi import writer
from weave.ansi.ansi import is_terminator, Marker
from weave.stdlib.builtins.string import __string__mul__, strip, _ALL_WHITESPACES
from weave.stdlib.builtins.vector import contains


alias default_newline = "\n"
alias default_tab_width = 4
alias default_breakpoint = "-"


# WordWrap contains settings and state for customisable text reflowing with
# support for ANSI escape sequences. This means you can style your terminal
# output without affecting the word wrapping algorithm.
struct WordWrap:
	var limit: Int
	var breakpoint: String
	var newline: String
	var keep_newlines: Bool

	var buf: buffer.Buffer
	var space: buffer.Buffer
	var word: buffer.Buffer

	var line_len: Int
	var ansi: Bool

	fn __init__(
		inout self,
		limit: Int,
		breakpoint: String = default_breakpoint,
		newline: String = default_newline,
		keep_newlines: Bool = True,
		line_len: Int = 0,
		ansi: Bool = False,
	):
		self.limit = limit
		self.breakpoint = breakpoint
		self.newline = newline
		self.keep_newlines = keep_newlines
		var buf = DynamicVector[Byte]()
		self.buf = buffer.new_buffer(buf=buf)

		var space = DynamicVector[Byte]()
		self.space = buffer.Buffer(buf=space)

		var word = DynamicVector[Byte]()
		self.word = buffer.Buffer(buf=word)

		self.line_len = line_len
		self.ansi = ansi

	fn add_space(inout self) raises:
		self.line_len += self.space.len()
		_ = self.buf.write(self.space.bytes())
		self.space.reset()

	fn add_word(inout self) raises:
		print(self.word.string())
		if self.word.len() > 0:
			self.add_space()
			self.line_len += self.word.len()
			_ = self.buf.write(self.word.bytes())
			self.word.reset()

	fn add_newline(inout self) raises:
		_ = self.buf.write_byte(ord(self.newline))
		self.line_len = 0
		self.space.reset()

	# write is used to write more content to the word-wrap buffer.
	fn write(inout self, b: DynamicVector[Byte]) raises -> Int:
		if self.limit == 0:
			return self.buf.write(b)

		var s = bt.to_string(b)
		if not self.keep_newlines:
			s = strip(s)
			s = s.replace("\n", " ")

		for i in range(len(s)):
			let c = ord(s[i])
			if c == ord(Marker):
                # ANSI escape sequence
				_ = self.word.write_byte(c)
				self.ansi = True
			elif self.ansi:
				_ = self.word.write_byte(c)
				if is_terminator(c):
					# ANSI sequence terminated
					self.ansi = False
			elif c == ord(self.newline):
				# end of current line
				# see if we can add the content of the space buffer to the current line
				if self.word.len() == 0:
					if self.line_len + self.space.len() > self.limit:
						self.line_len = 0
					else:
						# preserve whitespace
						_ = self.buf.write(self.space.bytes())

					self.space.reset()

				self.add_word()
				self.add_newline()
			# elif contains(String(_ALL_WHITESPACES), s[i]):
			elif s[i] == " ":
				# end of current word
				self.add_word()
				_ = self.space.write_byte(c)
			elif s[i] == self.breakpoint:
				# valid breakpoint
				self.add_space()
				self.add_word()
				_ = self.buf.write_byte(c)
			else:
				# any other character
				_ = self.word.write_byte(c)

				# add a line break if the current word would exceed the line's
				# character limit
				print(self.word.string(), self.line_len + self.space.len() + self.word.len(), self.limit, self.word.len())
				print(self.line_len + self.space.len() + self.word.len() > self.limit, self.word.len() < self.limit)
				if (
					self.line_len + self.space.len() + self.word.len() > self.limit
					and self.word.len() < self.limit
				):
					print("limit reached")
					self.add_newline()

		return len(b)

	# close will finish the word-wrap operation. Always call it before trying to
	# retrieve the final result.
	fn close(inout self) raises:
		self.add_word()

	# bytes returns the word-wrapped result as a byte slice.
	fn bytes(inout self) -> DynamicVector[Byte]:
		return self.buf.bytes()

	# String returns the word-wrapped result as a string.
	fn string(inout self) -> String:
		return self.buf.string()


# new_writer returns a new instance of a word-wrapping writer, initialized with
# default settings.
fn new_writer(limit: Int) -> WordWrap:
    return WordWrap(limit=limit)


# bytes is shorthand for declaring a new default WordWrap instance,
# used to immediately word-wrap a byte slice.
fn bytes(b: DynamicVector[Byte], limit: Int) raises -> DynamicVector[Byte]:
    var f = new_writer(limit)
    _ = f.write(b)
    _ = f.close()

    return f.bytes()


# String is shorthand for declaring a new default WordWrap instance,
# used to immediately wrap a string.
fn to_string(s: String, limit: Int) raises -> String:
    var buf = s._buffer
    buf = trim_null_characters(buf)
    let b = bytes(buf, limit)

    return bt.to_string(b)


fn in_group(a: DynamicVector[Byte], c: Byte) -> Bool:
    for i in range(len(a)):
        let v = a[i]
        if v == c:
            return True
    return False
