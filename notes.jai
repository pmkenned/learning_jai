#import "Basic";
#import "String";

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

    // Unless you specifically indicate that it should be unitialized:
    my_int3 : int = ---;

    // If the type is unspecified, it will be inferred:
    my_float := 1.0;
    assert(type_of(my_float) == float);

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

    // On the subject of casting, xx does an automatic casting
    my_u16 = 5;
    my_u8 = xx my_u16; // same as cast(u8) in this case

    // Use print() to output text. To print variables, use %.
    print("my_u8: %\n", my_u8);

    // Mismatching the number of % will result in a compile error
    //print("%\n");

    // Printing line number
    print("%\n", #location().line_number);

    // The # indicates something that will execute during compilation
    // For example, the #run directive below causes this fibonacci number to be calculated during compilation
    print("%\n", #run fib(90));
    // This will compile result into program as if you had written print("%\n", 4660046610375530309);
    // Anything you can program at runtime, you can also program at compile-time

    // Private functions are allowed
    fib :: (n : int) -> int {
        a, b := 1;
        for i : 1..n {
            t := a;
            a = b;
            b += t;
        }
        return a;
    }

    // Arrays

    // There are a few kinds of arrays: static arrays, array views, and resizable arrays

    // We'll start with static arrays
    xs : [3] int;
    xs[0] = 2;
    xs[1] = 1;
    xs[2] = 3;

    // Arrays know how long they are
    print("xs has % items\n", xs.count);

    // So this would be a compile-time error, unlike in C
    // xs[3] = 4;

    // You can iterate over an array like this:
    for x : xs {
        print("%\n", x);
    }

    // With only one statement in the body of the loop, the curly braces are optional
    // And we can use default variable names it and it_index
    for xs print("xs[%]: %\n", it_index, it);

    // Another way to do the loop (note the range is inclusive)
    for i : 0..xs.count-1 {
        print("xs[%]: %\n", i, xs[i]);
    }

    // Array literal syntax
    xs = int.[1, 2, 3];

    // Because the type of xs has already been declared, the type of the literal can be inferred
    xs = .[4, 5, 6];
    // ys := .[1, 2, 3]; // the type would be required here, though, since it cannot be inferred

    // Next, array views. They are declared with this syntax:
    ys : [] int;

    // Like static arrays, array views have a count and data pointer
    ys = xs; // this sets the count and and data pointer to match xs
    assert(ys.count == xs.count);
    assert(ys.data == xs.data);

    // Print knows how to print an array, by the way
    print("ys: %\n", ys);

    // Unlike with static arrays, we can modify the count and data pointers for array views
    // For example, this will make the array view just look at the last two elements of xs
    ys.data += 1; // pointer arithmetic similar to C
    ys.count -= 1;
    print("ys: %\n", ys);

    // Array views are also useful in that static arrays implicitly cast to them, which
    // means we can write a procedure that accepts static arrays of any length
    // Note that static arrays do not "decay" to pointers as they do in C, so the procedure
    // still knows how many elements in the array without needing a separate parameter
    sum :: (xs : [] int) -> int {
        sum := 0;
        for xs sum += it;
        return sum;
    }

    assert(sum(xs) == 15);
    assert(sum(ys) == 11);

    // Note that the size of a static array is the size of all the elements, as in C
    assert(size_of([10] int) == size_of(int)*10);
    // But the size of an array view is always 16 since it contains an 8 byte count
    // and an 8 byte data pointer
    assert(size_of([] int) == 16);

    // Lastly, resizable arrays. They are declared with this syntax:
    zs : [..] int;

    // Adding some elements to the resizable array (the * gets a pointer to zs)
    for 1..3 array_add(*zs, it);

    // Resizable arrays are dynamically allocated, so in addition to a count and data
    // pointer, they also have a capacity
    print("%\n", zs.allocated);

    // Resizable arrays also implicitly cast to array views, so we can use our same
    // sum procedure from above:
    print("%\n", sum(zs));

    // The implicit casting of [..] to [] is made possible by the fact that the two
    // have common data layout.

    // Pointers

    // NOTE: The syntax for pointers differs from C!
    // In C, the * is used to dereference and it is used to declare a pointer type, while &
    // is used to get the address of something:
    //  int * xp = &x;
    // In Jai, the * is still used to declare a pointer type, but it is also used to get
    // the address of something (which is more consistent if you think about it):
    int_ptr : *int = *my_int; // (the type could be inferred but making it explicit here)
    my_int4 := <<int_ptr; // And << is used to dereference

    // Strings

    my_string : string = "hello!";
    print("'%' is % bytes long, at %\n", my_string, my_string.count, my_string.data);

    // You can think of strings as actually just being [] u8
    for cast([] u8) my_string
        print("% ", it);
    print("\n");

    // As such, strings are similar to C strings in that they do not require any heap
    // allocations. The compiler places the string in program memory and the string
    // simply points to it
    my_string2 := "good morning";

    // We can do all the normal things that we can do with array views
    my_string2.data += 5;
    my_string2.count -= 5;
    assert(my_string2 == "morning"); // == operator is overloaded to do string compare

    // Note that strings are not nul-terminated as in C since the count makes that unnecessary.
    //
    // This makes it much easier to make substrings without modifying the original string (as would
    // happen with strtok() in C) or allocating new strings (as would happen in most other languages)
    //
    // In this example, we use split() from the String module to tokenize a string. Note that
    // the resulting substrings are just array views onto the original string, we are not
    // allocating new strings.
    s1 := "hello, how are you?";
    words := split(s1, " ");
    for words print("% %\n", it, it.count);
    // Of course, space does have to be allocated for the array views themselves since there can
    // be an arbitrary number of substrings. If you consult the documentation in
    // modules/String/module.jai, you'll see that it uses "temporary storage" to perform this
    // allocation. More on that later.

    // Though strings do not need to be nul-terminated, to make C interop more convenient,
    // string literals are automatically suffixed with a nul byte.
    assert(<<(s1.data + s1.count) == 0);
    // This means you can pass them to functions that expect C-strings

    // TODO: sprint
    // TODO: String_Builder
    //   init_string_builder
    //   append
    //   builder_string_length
    //   print_to_builder
    //   builder_to_string
    // TODO: #string

    // Structs

    // struct types are declared using this syntax:
    Vector3 :: struct {
        x : float;
        y : float;
        z : float;
    }

    // struct literal syntax is the same as array literal syntax
    my_vec3 := Vector3.{1, 2, 3};

    // print also knows how to print structs
    print("my_vec3: %\n", my_vec3);

    // Can specify field values by name, others will use default values
    my_vec3b := Vector3.{ y=1 };
    print("my_vec3b: %\n", my_vec3b);

    // structs can specify the default values for their fields
    Employee :: struct {
        name : string = "John Smith";
        salary : int = 100000;
        years_employed : int; // default will be 0

        // struct types can be anonymous
        // here, misc is an instance of an anonymous struct
        misc : struct {
            id : int;
            building: int;
        }

        // this is an anonymous instance of an anonymous struct!
        // in which case the members can be referred to directly
        struct {
            vacation_days : int;
            vacation_used : int;
        }
    }

    // This will use the default values:
    new_employee : Employee = .{};
    print("%\n", new_employee);

    // Here, some default values can be overridden
    new_employee2 : Employee = .{
        name = "Harry Truman",
        misc.id = 2,
        vacation_days = 15
    };
    print("%\n", new_employee2);

    // block scopes can be introduced with curly braces
    {
        // using will allow you to refer directly to the field names
        // of a struct
        using my_vec3;
        x += 1;
        y *= 2;
        z -= 1;
        print("%\n", my_vec3);

        // using can apply to a sub-struct
        using new_employee.misc;
        print("id: % building: %\n", id, building);

        // you can also use using on a struct type (as opposed to an instance of a struct)
        using Employee;
        print("%\n", type_of(name));
    }

    // TODO: procedures
    //  named arguments
    //  default arguments
    //  named return values
    //  multiple return values
    //  default return values
    //  variadic procedures

    // Polymorphic procedures

    // The $ indicates we're introducing a compile-time known type
    // Only one T should have the $.
    my_min :: (a : $T, b : T) -> T {
        if a < b
            return a;
        return b;
    }

    assert(my_min(2, 3) == 2);
    assert(my_min(2.1, 2.2) == 2.1);
    assert(my_min(2.1, 3) == 2.1); // the type for 3 will be inferred as float
    assert(my_min(2.1, cast(float) my_int) == 2.1); // explicit cast required

    // When defining polymorphic procedures, a separate concrete procedure is created
    // for each unique set of types, which we'll demonstrate below

    // You can use #procedure_of_call to get the procedure that *would* be called
    // given the arguments provided
    my_func_ptr1 := #procedure_of_call my_min(2, 3);
    my_func_ptr2 := #procedure_of_call my_min(2.1, 2.2);
    my_func_ptr3 := #procedure_of_call my_min(2.1, 3);
    my_func_ptr4 := #procedure_of_call my_min(2.1, cast(float) my_int);

    // Notice that the addresses of the functions with the same types are the same
    print("% %\n", my_func_ptr1, type_of(my_func_ptr1));
    print("% %\n", my_func_ptr2, type_of(my_func_ptr2));
    print("% %\n", my_func_ptr3, type_of(my_func_ptr3));
    print("% %\n", my_func_ptr4, type_of(my_func_ptr4));

    // The #bake_constants directive can be used to specify one or more compile-time constants
    // In this case, we give a name to a concrete representation of my_min
    min_ints :: #bake_constants my_min(T=int);
    print("% %\n", min_ints, type_of(min_ints));

    // Similarly, #bake_arguments can be used to specify one or more arguments
    min_of_x_and_100 := #bake_arguments min_ints(b=100);
    assert(min_of_x_and_100(50) == 50);
    assert(min_of_x_and_100(200) == 100);

    // TODO: polymorphic structs

    // TODO: defer

    // TODO: context
    //  context, push_context
    //  context.print_style.default_format_struct.use_long_form_if_more_than_this_many_members = 0;

    // TODO:
    //  ifx
    //  operator overloading
    //  #as
    //  $T: Type
    //  case
    //  enum
    //  Any type
    //  New(), NewArray()
    //  #must
    //  *void
    //  #c_call
    //  Temporary_Storage, reset_temporary_storage

    // Things to learn about:
    //  #place
    //  #insert, SoA, AoS
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
