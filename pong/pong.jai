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

PADDLE_OFFSET :: 75;
PADDLE_WIDTH :: 10;
PADDLE_HEIGHT :: 400;
PADDLE_SPEED :: 200.0;

BALL_HEIGHT :: 10;
BALL_WIDTH :: 10;

Paddle :: struct {
    x : float = PADDLE_OFFSET;
    y : float = #run window_height/2.0 - PADDLE_HEIGHT/2.0;
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

player1_score : int = 0;
player2_score : int = 0;

main :: ()
{
    // setup window
    last_time = get_time();

    ball.x = cast(float) window_width/2;
    ball.y = cast(float) window_height/2;
    ball.xv = 250;
    ball.yv = 250;

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
        //print("%\n", 1.0/time_per_loop);
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

    // Collision with paddles
    handle_paddle_ball_collision(left_paddle, *ball);
    handle_paddle_ball_collision(right_paddle, *ball);

    // Collision with walls
    if ball.x < 0 {
        ball.x = window_width/2.0;
        ball.y = window_height/2.0;
        player2_score += 1;
        ball.xv *= -1;

        print("Player 1:%, Player 2:%\n", player1_score, player2_score);
    }
    if ball.x > cast(float) window_width {
        ball.x = window_width/2.0;
        ball.y = window_height/2.0;
        player1_score += 1;
        ball.xv *= -1;

        print("Player 1:%, Player 2:%\n", player1_score, player2_score);
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
        right_paddle.y -= dt*PADDLE_SPEED;
    if key_up
        right_paddle.y += dt*PADDLE_SPEED;

    if right_paddle.y < 0
        right_paddle.y = 0;

    if right_paddle.y + PADDLE_HEIGHT > cast(float) window_height
        right_paddle.y = cast(float) window_height - PADDLE_HEIGHT;

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

handle_paddle_ball_collision :: (paddle: Paddle, ball: *Ball)
{
    if (ball.x >= paddle.x && ball.x <= paddle.x + PADDLE_WIDTH &&
        ball.y >= paddle.y && ball.y <= paddle.y + PADDLE_HEIGHT)
    {
        ball.xv *= -1;

        incoming_angle := Math.PI - Math.atan(ball.yv/ball.xv);
        how_high_on_paddle := (ball.y - paddle.y)/paddle.y - 0.5;

        delta_angle := Math.atan(how_high_on_paddle) - Math.PI;
        final_angle := incoming_angle;

        speed := Math.sqrt(ball.yv * ball.yv + ball.xv * ball.xv);
        ball.xv = speed * Math.sin(final_angle);
        ball.yv = speed * Math.cos(final_angle);
    }
}
