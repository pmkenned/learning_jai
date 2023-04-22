#import "Basic";
Math :: #import "Math";
WinCreate :: #import "Window_Creation";
Simp :: #import "Simp";
Input :: #import "Input";

DT_MAX : float : 0.15;
MAX_FRAMERATE : float : 60.0;

done := false;

window_width  : s32 = 1280; 
window_height : s32 = 720;

key_up    : u32;
key_down  : u32;

last_time:  float64;
dt: float = 0.016667;

PADDLE_OFFSET :: 10;
PADDLE_WIDTH :: 10;
PADDLE_HEIGHT :: 100;
PADDLE_SPEED :: 200.0;

BALL_HEIGHT :: 10;
BALL_WIDTH :: 10;

Paddle :: struct {
    x : float = PADDLE_OFFSET;
    y : float = 50.0;
}

left_paddle : Paddle;
right_paddle : Paddle;

Ball :: struct {
    x : float;
    y : float;
    xv : float;
    yv : float;
}

ball : Ball;

main :: ()
{
    // setup window
    last_time = get_time();

    ball.x = cast(float) window_width/2;
    ball.y = cast(float) window_height/2;
    ball.xv = 500;
    ball.yv = 500;

    right_paddle.x = cast(float) window_width - PADDLE_WIDTH - PADDLE_OFFSET;

    window := WinCreate.create_window(window_name="Invaders", width=window_width, height=window_height);
    Simp.set_render_target(window);

    while !done {
        reset_temporary_storage();
        Simp.clear_render_target(.2, .3, .3, 1);
        Input.update_window_events();

        simulate();

		Simp.set_shader_for_color();
		Simp.immediate_quad(left_paddle.x, left_paddle.y, left_paddle.x + PADDLE_WIDTH, left_paddle.y + PADDLE_HEIGHT, Math.make_vector4(128, 0, 0, 1));
		Simp.immediate_quad(right_paddle.x, right_paddle.y, right_paddle.x + PADDLE_WIDTH, right_paddle.y + PADDLE_HEIGHT, Math.make_vector4(128, 0, 0, 1));
		Simp.immediate_quad(ball.x, ball.y, ball.x + BALL_WIDTH, ball.y + BALL_HEIGHT, Math.make_vector4(0, 0, 128, 1));

        Simp.swap_buffers(window);

        min_delta := 1.0/MAX_FRAMERATE;
        time_per_loop := max(min_delta, dt);
        print("%\n", 1.0/time_per_loop);
        sleep_milliseconds(cast(s32) (time_per_loop - dt));
    }
}

simulate :: ()
{
    now := get_time();
    dt = cast(float) (now - last_time);

    if dt > DT_MAX dt = DT_MAX;

    last_time = now;

    ball.x += dt*ball.xv;
    ball.y += dt*ball.yv;
    if ball.x < 0 {
        ball.x = 0;
        ball.xv *= -1;
    }
    if ball.x > cast(float) window_width {
        ball.x = cast(float) window_width;
        ball.xv *= -1;
    }
    if ball.y < 0 {
        ball.y = 0;
        ball.yv *= -1;
    }
    if ball.y > cast(float) window_height {
        ball.y = cast(float) window_height;
        ball.yv *= -1;
    }

    if key_down
        left_paddle.y -= dt*PADDLE_SPEED;
    if key_up
        left_paddle.y += dt*PADDLE_SPEED;

    if left_paddle.y < 0
        left_paddle.y = 0;

    if left_paddle.y + PADDLE_HEIGHT > cast(float) window_height
        left_paddle.y = cast(float) window_height - PADDLE_HEIGHT;

    for event : Input.events_this_frame {
        if event.type == .QUIT {
            done = true;
            break;
        }

        if event.key_code == .ESCAPE {
            if event.key_pressed
                done = true;
        }

        if event.type == .KEYBOARD {
            key := event.key_code;

            if key == .ARROW_DOWN   key_down  = event.key_pressed;
            if key == .ARROW_UP     key_up    = event.key_pressed;
        }
    }
}
