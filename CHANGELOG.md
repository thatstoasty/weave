# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] - yyyy-mm-dd

## [0.1.3] - 2024-12-17

- Remove `gojo` dependencies, any usage of `StringBuilder` now uses String streaming. Same with `bytes.Buffer` -> `ByteWriter`.
- Removed unused functions to simplify the user interface for the string transformation functions.
- Functions now accept `Stringable` types, instead of just `String`.
- Removed some additional allocations.

## [0.1.2] - 2024-09-23

- Use `consume()` instead of `__str__()` to render the result from the buffers.

## [0.1.1] - 2024-09-13

- First release with a changelog! Added rattler build and conda publish.
