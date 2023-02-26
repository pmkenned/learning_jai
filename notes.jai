#import "Basic";

main :: () {

    // To compile this file, do:
    //  jai notes.jai
    // Or, on linux:
    //  jai-linux notes.jai
    // You can use -quiet to silence the compiler output

    // The syntax for declaring and initializing a variable is:
    // <name> : <type> = <value>;
    // For example:
    my_int : int = 2;

    // The value is optional:
    my_int2 : int;

    // If an initial value is unspecified, it will be the default value:
    assert(my_int2 == 0);

    // If the type is unspecified, it will be inferred:
    my_float := 1.0;

    // Here is the list of integer types:
    //  u8  s8  : unsigned and signed 8 bit
    //  u16 s16
    //  u32 s32
    //  u64 s64
    //  int: an alias for s64
    // And float types:
    //  float32
    //  float64
    //  float: alias for float32

    // Once declared, assignment is done using =
    my_int = 3;

    // The usual +=, -=, etc. are available:
    my_int += 1;

    // but not x++, etc.:
    // my_int++;

    // To declare a constant, use : instead of =
    // <name> : <type> : <value>;
    // For example:
    MY_CONSTANT : int : 3;
    MY_CONSTANT2 :: 4;

    // Use type_of() to get the type of something
    assert(type_of(my_float) == float);

    // Note that types exist at run-time, so we can declare
    // a variable to be of the 'Type' type:
    my_type : Type = float;
    assert(type_of(my_type) == Type);

    assert(type_of(Type) == Type);

    // If we make a constant type, we can even use it to
    // declare another variable:
    MY_CONSTANT_TYPE :: int;
    foo : MY_CONSTANT_TYPE = 1;

    // Use size_of() to get the size of things in bytes:
    assert(size_of(int) == 8);

    // Note that unlike in C, if my_int is an int, you cannot
    // say size_of(my_int), you would need to first get the type:
    assert(size_of(type_of(my_int)) == 8);

    // However, this is fine because MY_CONSTANT_TYPE is already
    // a type, and it's a constant:
    size_of(MY_CONSTANT_TYPE);

    // This would not be allowed because my_type isn't a constant:
    // size_of(my_type);

    // is_constant() will tell you if something is constant:
    assert(is_constant(MY_CONSTANT));

    // Some casting is implicit. This is done, for example, when
    // casting between built-in types when information would not be lost:
    my_u8 : u8 = 3;
    my_u16 : u16 = my_u8;

    // When information would be lost, an explicit cast is required:
    my_u8 = cast(u8) my_u16;

    // In such cases, run-time checks are inserted to make sure information isn't lost:
    my_u16 = 256;
    // my_u8 = cast(u8) my_u16; // would generate a run-time error

    // TODO:
    //  xx
    //  run-time and compile-time errors
    //  #location
    //  polymorphic function
    //  for loops, it, it_index
    //  arrays
    //  array views
    //  resizable arrays, array_add
    //  casting [..] to []
    //  pointers
    //  strings
    //  .count, sprint
    //  String_Builder
    //   init_string_builder
    //   append
    //   builder_string_length
    //   print_to_builder
    //   builder_to_string
    //  s.data, s.count
    //  #string
    //  structs
    //   defaults
    //   using
    //   literals, .{, .[
    //  multiple return values, like out parameters
    //  ifx
    //  ---
    //  operator overloading
    //  #as
    //  $T: Type
    //  defer
    //  <<
    //  case
    //  default arguments
    //  enum
    //  named-arguments and return values
    //  variadic functions, ..
    //  Any type
    //  Default return values
    //  New(), NewArray()
    //  #must
    //  context, push_context
    //  *void
    //  #c_call
    //  Temporary_Storage, reset_temporary_storage

    // Things to learn about:
    //  #place
    //  #insert, SoA, AoS
    //  #bake_arguments
    //  #modify
    //  #expand
    //  remove
    //  for *
    //  AST
    //  compiler message loop
    //  stack trace
    //  relative pointers
    //  inline assembly
    //  build program
    //  for_expansion
    //  if case
    //  @notes
    //  serialize

    // Questions:
    // - How to format print?
    // - Can print be extended for custom types?
    // - Why doesn't double-free crash?
    // - Get type from Type_Info?
    // - Why don't arrays of floats implicitly cast to array of Any?
    // - Any vs $T?
    // - Deep copying of structs?
}
