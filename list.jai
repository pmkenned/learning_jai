#import "Basic";
#import "String";

ListNode :: struct ($T : Type) {
    next : * ListNode(T);
    data : T;
}

LinkedList :: struct($T : Type) {
    head : * ListNode(T);
}

Base :: struct {
    t : Type;
    n: int;
}

Derived :: struct {
    #as using base : Base;
    t = Derived;
    n = 3;
    s : string;
}

foo :: (b : Base) {
    print("%\n", b);
}

main :: () {
    list : LinkedList(int);

    list.head = alloc(size_of(ListNode(int)));

    list.head.data = 3;
    list.head.next = alloc(size_of(ListNode(int)));
    list.head.next.data = list.head.data + 1;

    print("%\n", list.head.next.data);

    d: Derived;
    foo(d);

    args := get_command_line_arguments();

    //if args.count < 2 {
    //    print("usage: % [FILE]\n", args[0], to_standard_error=true);
    //    exit(1);
    //}

    //for args {
    //    print("%\n", it);
    //}

    my_str := "hello";
    // my_str[0] -= 32; // seg faults

    my_str.data = alloc(5);
    memcpy(my_str.data, "hello".data, 5);
    my_str[0] -= 32; // fine

    print("my_str: %\n", my_str);

    substrings := split("hello, there", " ");

    for substrings {
        print("%\n", it);
    }
}
