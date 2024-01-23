from weave.gojo.bytes.bytes import Byte


fn to_string(b: DynamicVector[Byte]) -> String:
    var s: String = ""
    for i in range(b.size):
        # TODO: Resizing isn't really working rn. The grow functions return the wrong index to append new bytes to.
        # This is a hack to ignore the 0 null characters that are used to resize the dynamicvector capacity.
        if b[i] != 0:
            let char = chr(int(b[i]))
            s += char
    return s


fn copy(inout target: DynamicVector[Byte], source: DynamicVector[Byte]) -> Int:
    var count = 0

    # TODO: End of strings include a null character which terminates the string. This is a hack to not write those to the buffer for now.
    for i in range(source.size):
        if source[i] != 0:
            let element = source[i]
            target.append(element)
            count += 1

    return count


# # ErrTooLarge is passed to panic if memory cannot be allocated to store data in a buffer.
# var ErrTooLarge = errors.New("bytes.Buffer: too large")
# var errNegativeRead = errors.New("bytes.Buffer: reader returned negative count from read")


fn cap(buffer: DynamicVector[Byte]) -> Int:
    return buffer.capacity
