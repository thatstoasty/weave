# from memory.unsafe import Reference

# # @value
# # struct Thing():
# #     var value: Int

# # @value
# # struct ThingHolder[L: __lifetime_of(Thing(1).value)]():
# #     var thing: Reference[L, Thing]


fn main() raises:
    var vals: String = "ABC123"
    print(len(vals.as_bytes()))