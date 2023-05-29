#import "Basic";

/*

foo :: () -> int {
    return 3;
}

Foo :: struct {
    count: s64;
    data: *int;
}

bar :: () {
    //x : u32 = 2;
    //print("%\n", #location().line_number);
    //print("% % % %\n", type_of(type_of(type_of(x))), type_of(type_of(x)), type_of(x), x);
    //print("%s\n", foo());
    //print("%\n", type_of(main));

    //res: [..] int;
    //array_add(*res, 1);
    //for v, i: res {
    //    print("%: %\n", i, v);
    //}
    //print("%\n", res.count);
    //for 1..10 print("%\n", it);

    //f :: (array: [] int) {
    //    for array print("array[%] is %.\n", it_index, it);
    //}

    resizable: [..] int;
    array_add(*resizable, 1);
    array_add(*resizable, 4);
    array_add(*resizable, 9);
    array_add(*resizable, 16);

    pointer_a: *[..] int = *resizable;
    print("pointer_a.count is %; pointer_a.data is %.\n", pointer_a.count, pointer_a.data);

/*
    convert :: (arg: $T) {
        print("% (type %), cast to bool, is %\n", arg, type_of(arg), cast(bool) arg);
    }

    print("\n");

    x : [8] int;
    y : [] int;
    x[0] = 3;
    x[1] = 2;
    x[2] = 5;
    y = x;

    print("% %\n", x, type_of(x));
    print("% %\n", y, type_of(y));

    print("%\n", type_of(x));

    for i: 0..7 {
        print("%\n", x[i]);
    }

    for v, i: x {
        print("%: %\n", i, v);
    }

    // Now let's cast various things to bool and see the result.

    //convert(0);
    //convert(1);
    //convert(cast(s16) -37);
    //convert(69105.33);
    //convert("Hello, Sailor!");
    */
}

my_to_c_string :: (s: string) -> *u8 {
    result := cast(*u8) alloc(s.count + 1);
    memcpy(result, s.data, s.count);
    result[s.count] = 0;

    return result;
}

Rectangle :: struct {  // It is my personal style to capitalize the names of my structs, but it's not required.
    x0: float;   // X coordinate of lower-left corner.
    y0: float;   // Y coordinate of lower-left corner.
    x1: float;   // X coordinate of upper-right corner.
    y1: float;   // Y coordinate of upper-right corner.

    color_name: string;   // Maybe the name of a color we use to draw this, or ... something.
}

//Bar :: struct {
//    x: int = #run foo();
//    y: int = 2;
//}

Header :: struct {
    name     := "Fred";
    duration := 3.5;
}

Body :: struct {
    using header: Header;

    values: [3] int;
    postscript := "Bye.";
}

main :: () {
    r: Rectangle;
    print("Initially, r is: %\n", r);
    r.x0 = 10;
    r.y0 = 5;
    r.x1 = 50;
    r.y1 = 55;
    r.color_name = "chartreuse";
    print("Later, r is: %\n", r);

    //print("%\n", is_constant(Foo));

    //t : Type : type_of(r);
    t : Type : Type;
    sz := size_of(t);
    print("%\n", size_of(Rectangle));
    print("%\n", sz);

    b: Bar;
    print("%\n", b);

    x: string = "hello";
    p: *u8 = to_c_string(x);
    print("%\n", p[0]);
    print("%\n", type_of(my_to_c_string));

    y: string = "what's up";
    z: [] u8 = cast([] u8) y;
    for c: z print("%\n", c);

    SOME_STRING := "hello";
    print("%\n", type_of(SOME_STRING));
    write_string("Here is a secret message for you: \x48\x65\x6c\x6c\x6f\x2c\x20\x53\x61\x69\x6c\x6f\x72\x21\n");

    STRING_WITH_IMPLICIT_CR :: #string,cr END
    This line ends with carriage-return+line-feed:
    This one too
    END

    write_string(STRING_WITH_IMPLICIT_CR);


}
*/

String :: struct {
    s : string;
}

string_concat :: (s1: string, s2: string) -> string {
    s3 : string;
    s3.data = alloc(s1.count + s2.count);
    memcpy(s3.data, s1.data, s1.count);
    memcpy(s3.data + s1.count, s2.data, s2.count);
    s3.count = s1.count + s2.count;
    return s3;
}

//my_swap :: (a: *Any, b: *Any) {
//    t := <<a;
//    <<a = <<b;
//    <<b = t;
//}

//my_swap :: (a: *Any, b: *Any) {
//    t := <<a;
//    <<a = <<b;
//    <<b = t;
//}

//my_swap :: (a: $T, b: T) {
//    t := a;
//    a = b;
//    b = t;
//}

//my_swap :: (a: $T, b: T) {
//    t : T = alloc();
//    memcpy(t, a, size_of(T));
//    memcpy(a, b, size_of(T));
//    memcpy(b, t, size_of(T));
//    free(t);
//}

my_swap :: (a: $T, b: T) {
    t := <<a;
    <<a = <<b;
    <<b = t;
}

partition :: (xs: [] $T) -> int {
    pivot := xs.count/2;
    pivot_val := xs[pivot];
    my_swap(*xs[xs.count-1], *xs[pivot]);
    lo := 0;
    for xs {
        if it < pivot_val {
            my_swap(*xs[it_index], *xs[lo]);
            lo += 1;
        }
    }
    my_swap(*xs[lo], *xs[xs.count-1]);
    return lo;
}

sort :: (xs: [] $T) {
    if xs.count <= 1 return;
    pivot := partition(xs);
    left := xs;
    left.count = pivot;
    right := xs;
    right.data += pivot;
    right.count -= pivot;
    sort(left);
    sort(right);
}

median :: (xs : [] $T) -> T {
    assert(xs.count > 0);
    tmp : [] T;
    tmp.count = xs.count;
    tmp.data = cast(*T) alloc(size_of(type_of(xs)) * xs.count);
    memcpy(tmp.data, xs.data, xs.count*size_of(type_of(xs)));
    sort(tmp);
    defer free(tmp.data);
    return tmp[tmp.count/2];
}

variadic_func :: (things : .. Any) {

    using Type_Info_Tag;

    print("====\n");

    //for things {
    //    print("% %\n", <<it.type, it);
    //}
    //print("\n");

    // print the strings
    for things {
        if it.type.type == STRING {
            print("% ", it);
        }
    }
    print("\n");

    // print the ints
    print("[");
    for things {
        if it.type.type == INTEGER {
            print("%, ", it);
        }
    }
    print("]\n");

    print("====\n");
}

#add_context silly_number : int = 4;

proc2 :: () {
    print("proc2 says context.silly_number is %\n", context.silly_number);
}

proc1 :: () {
    print("Before calling proc2, proc1 says context.silly_number is %\n", context.silly_number);
    new_context := context;
    new_context.silly_number += 1;
    push_context new_context {
        proc2();
    }
    print("After  calling proc2, proc1 says context.silly_number is %\n", context.silly_number);
}

proc0 :: () {
    print("Before calling proc1, proc0 says context.silly_number is %\n", context.silly_number);
    proc1();
    print("After  calling proc1, proc0 says context.silly_number is %\n", context.silly_number);
}

FooStruct :: struct ($T: Type, $N: s64) {
    array: [N] T;
}

BarStruct :: struct ($T: Type, $N: s64) {
    array: [N+1] T;
}

ross :: ($T : Type, $N : s64, val : FooStruct(T, N)) -> BarStruct(T, N) {
    return .{ array = .[1, 2, 3] };
}

strcpy :: (dst: *u8, src: *u8) {
    while (true) {
        <<dst = <<src;
        if <<dst == 0 break;
        dst, src += 1;
    }
}

main :: () {

    context.print_style.default_format_struct.use_long_form_if_more_than_this_many_members = 0;
    proc0();

    MyStruct2 :: struct {
        x, y: int;
    }

    MyStruct1 :: struct {
        ms2 : *MyStruct2;
        z: int;
    }

    ms1a : MyStruct1;
    ms1a.ms2 = New(MyStruct2);
    ms1b := ms1a;
    print("%\n", ms1a);
    print("%\n", ms1b);

    xs := int.[5, 12, 3, 6, 7, 0, 4];
    //xs[0], xs[1] = swap(xs[0], xs[1]);
    //my_swap(*xs[0], *xs[1]);

    print("median of %: %\n", xs, median(xs));
    print("median: %\n", median(float.[1.0, 2.0, 3.0]));

    x : int;
    xp := *x;
    x = 5;
    print("% %\n", x, << xp);

    y : [3] int = .[1, 2, 3];
    for y print("%\n", it);

    variadic_func(5, "hello", 27, "how", "are", 100, "you?");

    tit : Type_Info_Tag;
    print("%\n", tit);

    s1 : string = "hello, ";
    s2 : string = "paul";
    s3 := string_concat(s1, s2);
    print("%\n", s3);
    free(s3.data);

    names : [..] string;
    array_add(*names, "paul");
    array_add(*names, "john");
    array_add(*names, "bob");

    for names print("names[%] is %.\n", it_index, it);

    Holder :: struct ($T: Type, $N: s64) {
        array: [N] T;
    }

    my_floats : Holder(float, 5) = .{ array = .[1.0, 2.0, 3.0, 4.0, 5.0] };

    v : FooStruct(int, 2);
    ross(int, 2, v);

    src := cast(*u8) alloc(size_of(u8)*10);
    dst := cast(*u8) alloc(size_of(u8)*10);
    //for 65..74 src[it_index] = cast(u8) it; // why is it_index undeclared?
    for 0..9 src[it] = cast(u8) it+65;
    src[9] = 0;
    strcpy(dst, src);
    print("dst:\n");
    for 0..9 print("%\n", dst[it]);
    free(src);
}
