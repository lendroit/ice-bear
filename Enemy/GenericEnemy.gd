extends KinematicBody2D

export (int) var speed = 200
export (float) var friction = 0.1
export (float) var acceleration = 0.25

const POSSIBLE_TIMER_DURATIONS = [0.5, 1, 1.5, 2]

onready var walking_timer = $WalkingTimer
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

var walking := true
var velocity := Vector2.ZERO
var direction := Vector2.LEFT

enum {
	IDLE,
	NEW_DIRECTION,
	WALK
}

var state = WALK

##########

func upd_walking_timer_duration():
	walking_timer.set_wait_time(choose(POSSIBLE_TIMER_DURATIONS))

func walk():
	velocity.x = lerp(velocity.x, speed * direction.x, acceleration)
	animation_player.play("Walking")

func idle():
	velocity.x = lerp(velocity.x, Vector2.ZERO.x, friction)
	animation_player.play("Idle")

func flip():
	direction = -direction
	sprite.flip_h = !sprite.flip_h

func choose(array):
	array.shuffle()
	return array.front()

func reset_timer():
	upd_walking_timer_duration()
	walking_timer.start()

##########

func _ready():
	reset_timer()

func _process(delta):
	match state:
		IDLE:
			idle()
		NEW_DIRECTION:
			flip()
			state = WALK
		WALK:
			walk()

func _physics_process(delta):
	velocity.y += EngineParameters.GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_WalkingTimer_timeout():
	reset_timer()
	match state:
		IDLE:
			state = choose([WALK, NEW_DIRECTION])
		WALK:
			state = IDLE

func _on_LeftCliffDetector_body_exited(body):
	state = NEW_DIRECTION

func _on_RightCliffDetector_body_exited(body):
	state = NEW_DIRECTION

func _on_LeftWallDetector_body_entered(body):
	state = NEW_DIRECTION

func _on_RightWallDetector_body_entered(body):
	state = NEW_DIRECTION
