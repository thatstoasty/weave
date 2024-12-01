import benchmark
import pathlib
import time
from weave import dedent, indent, margin, padding, truncate, word_wrap, wrap
from weave.bytes import ByteWriter


fn benchmarks() raises:
    var buffer = ByteWriter(capacity=4423106 * 10)
    var path = str(pathlib._dir_of_current_file()) + "/data/big.txt"
    with open(path, "r") as file:
        var data = file.read()
        for _ in range(1):
            buffer.write(data)

        var text = buffer.consume()
        var start = time.perf_counter_ns()
        var result = indent(text, 4)
        print("Indent duration:", (time.perf_counter_ns() - start) / 1000, "ms")

        start = time.perf_counter_ns()
        result = dedent(text)
        print("Dedent duration:", (time.perf_counter_ns() - start) / 1000, "ms")

        start = time.perf_counter_ns()
        result = margin(text, 4, 4)
        print("Margin duration:", (time.perf_counter_ns() - start) / 1000, "ms")

        start = time.perf_counter_ns()
        result = padding(text, 4)
        print("Padding duration:", (time.perf_counter_ns() - start) / 1000, "ms")

        start = time.perf_counter_ns()
        result = wrap(text, 100)
        print("Wrap duration:", (time.perf_counter_ns() - start) / 1000, "ms")

        start = time.perf_counter_ns()
        result = word_wrap(text, 100)
        print("Wordwrap duration:", (time.perf_counter_ns() - start) / 1000, "ms")

        start = time.perf_counter_ns()
        result = truncate(text, 100)
        print("Truncate duration:", (time.perf_counter_ns() - start) / 1000, "ms")


fn main() raises:
    print("Running benchmarks")
    benchmarks()
