import benchmark
from benchmark import ThroughputMeasure, BenchMetric, Bencher, Bench, BenchId, BenchConfig

import pathlib
import time
from weave import dedent, indent, margin, padding, truncate, word_wrap, wrap
from weave.bytes import ByteWriter


fn benchmarks() raises:
    var buffer = ByteWriter(capacity=4423106 * 10)
    var path = String(pathlib._dir_of_current_file()) + "/data/big.txt"
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


fn get_gbs_measure(input: String) raises -> ThroughputMeasure:
    return ThroughputMeasure(BenchMetric.bytes, input.byte_length())


fn run[func: fn (mut Bencher, String) raises capturing, name: String](mut m: Bench, data: String) raises:
    m.bench_with_input[String, func](BenchId(name), data, get_gbs_measure(data))


@parameter
fn test_indent(mut b: Bencher, s: String) raises:
    @always_inline
    @parameter
    fn do() raises:
        _ = indent(s, 4)

    b.iter[do]()


@parameter
fn test_dedent(mut b: Bencher, s: String) raises:
    @always_inline
    @parameter
    fn do() raises:
        _ = dedent(s)

    b.iter[do]()


@parameter
fn test_margin(mut b: Bencher, s: String) raises:
    @always_inline
    @parameter
    fn do() raises:
        _ = margin(s, 4, 4)

    b.iter[do]()


@parameter
fn test_word_wrap(mut b: Bencher, s: String) raises:
    @always_inline
    @parameter
    fn do() raises:
        _ = word_wrap(s, 100)

    b.iter[do]()


@parameter
fn test_wrap(mut b: Bencher, s: String) raises:
    @always_inline
    @parameter
    fn do() raises:
        _ = wrap(s, 100)

    b.iter[do]()


@parameter
fn test_truncate(mut b: Bencher, s: String) raises:
    @always_inline
    @parameter
    fn do() raises:
        _ = truncate(s, 100)

    b.iter[do]()


@parameter
fn test_padding(mut b: Bencher, s: String) raises:
    @always_inline
    @parameter
    fn do() raises:
        _ = padding(s, 4)

    b.iter[do]()


fn main() raises:
    var config = BenchConfig()
    config.verbose_timing = True
    config.tabular_view = True
    config.flush_denormals = True
    config.show_progress = True
    var bench_config = Bench(config)

    var path = String(pathlib._dir_of_current_file()) + "/data/big.txt"
    var data: String
    with open(path, "r") as file:
        data = file.read()

    run[test_indent, "Indent"](bench_config, data)
    run[test_dedent, "Dedent"](bench_config, data)
    run[test_margin, "Margin"](bench_config, data)
    run[test_word_wrap, "WordWrap"](bench_config, data)
    run[test_wrap, "Wrap"](bench_config, data)
    run[test_truncate, "Truncate"](bench_config, data)
    run[test_padding, "Padding"](bench_config, data)

    bench_config.dump_report()
