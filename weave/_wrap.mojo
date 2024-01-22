alias tab_width: String = "    "


fn wrap(s: String, limit: Int) -> String:
    let temp: String = s.replace("\t", tab_width)

    var modified: String = ""
    var line_length: Int = 0

    for i in range(len(temp)):
        # At the end of the line, add a newline and reset the line length
        if line_length >= limit:
            modified += "\n"
            line_length = 0

        # If the character being written is a newline, reset the line length first.
        if temp[i] == "\n":
            line_length = 0

        modified += temp[i]
        line_length += 1

    return modified
