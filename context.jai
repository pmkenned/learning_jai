// this file is not meant to compile, it's just meant to show the contents of the context
// structure for reference

context: {
    base = {
        thread_index = 0;
        allocator = {procedure 0x23_e210, null};
        logger = procedure 0x24_6c70;
        logger_data = null;
        log_source_identifier = 0;
        log_level = NORMAL;
        temporary_storage = 25_4000;
        dynamic_entries = [{(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}, {(null), null}];
        num_dynamic_entries = 0;
        stack_trace = 7ffd_7370_b168;
        assertion_failed = procedure 0x22_9cf0;
        handling_assertion_failure = false;
    };
    print_style = {
        default_format_int = {
            formatter = {(zero-initialized Any)};
            base = 10;
            minimum_digits = 1;
            padding = 48;
            digits_per_comma = 0;
            comma_string = "";
        };
        default_format_float = {{(zero-initialized Any)}, -1, -1, YES, DECIMAL};
        default_format_struct = {
            formatter = {(zero-initialized Any)};
            draw_type_name = false;
            use_long_form_if_more_than_this_many_members = 5;
            separator_between_name_and_value = " = ";
            short_form_separator_between_fields = ", ";
            long_form_separator_between_fields = "; ";
            begin_string = "{";
            end_string = "}";
            indentation_width = 4;
            use_newlines_if_long_form = false;
        };
        default_format_array = {
            formatter = {(zero-initialized Any)};
            separator = ", ";
            begin_string = "[";
            end_string = "]";
            printing_stopped_early_string = "...";
            draw_separator_after_last_element = false;
            stop_printing_after_this_many_elements = 100;
        };
        default_format_absolute_pointer = {
            formatter = {(zero-initialized Any)};
            base = 16;
            minimum_digits = 1;
            padding = 48;
            digits_per_comma = 4;
            comma_string = "_";
        };
        struct_printer = null;
        struct_printer_data = null;
        indentation_depth = 2;
        log_runtime_errors = true;
    };
}
