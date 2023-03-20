#import "Basic";
#import "Input";
#import "Math";
#import "Random";
#import "Window_Creation";

Simp :: #import "Simp";

window_width  : s32 = 1280; 
window_height : s32 = 720;

main :: () {
    width  := window_width;
    height := window_height;

    window := create_window(window_name="Invaders", width=window_width, height=window_height);
    Simp.set_render_target(window);

	x := 0.0;
	y := 0.0;
	dx := 5;
	dy := 5;
	r := random_get_zero_to_one();
	g := random_get_zero_to_one();
	b := random_get_zero_to_one();

	should_quit_game := false;
	while !should_quit_game {
		Simp.clear_render_target(.2, .3, .3, 1);
		update_window_events();

		x += dx;
		y += dy;
		if x > cast(float) width || x < 0
		{
			dx = -dx;
			r = random_get_zero_to_one();
			g = random_get_zero_to_one();
			b = random_get_zero_to_one();
		}
		if y > cast(float) height || y < 0
		{
			dy = -dy;
			r = random_get_zero_to_one();
			g = random_get_zero_to_one();
			b = random_get_zero_to_one();
		}
		Simp.set_shader_for_color();
		Simp.immediate_quad(x, y, 100 + x, 100 + y, make_vector4(r, g, b, 1));

		// @Incomplete: Handle resizes in the actual scene drawing, which we currently don't.
        for get_window_resizes() {
            Simp.update_window(it.window);
            if it.window == window {
                window_width  = it.width;
                window_height = it.height;
            }
        }

		for event : events_this_frame {
			if event.type == .QUIT {
				should_quit_game = true;
				break;
			}
		}

		Simp.swap_buffers(window);
	}
}

#run main();