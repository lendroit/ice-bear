extends KinematicBody2D

export (int) var speed = 50
export (float) var friction = 0.1
export (float) var acceleration = 0.25

var POSSIBLE_WALKING_TIMER_DURATIONS = [2, 3]

onready var walking_timer = $WalkingTimer
onready var animation_player = $AnimationPlayer
onready var cliff_detector = $CliffDetector
onready var wall_detector = $WallDetector

var velocity := Vector2.ZERO
var direction := Vector2.RIGHT

enum {
	IDLE,
	NEW_DIRECTION,
	WALK,
	WAVING
}

var state = WALK

func _ready():
	_reset_walking_timer()

func _process(_delta):
	_change_direction_if_needed()
		
	match state:
		IDLE:
			_idle()
		NEW_DIRECTION:
			_flip()
			state = WALK
		WALK:
			_walk()
		WAVING:
			_stop_walking()

func _physics_process(delta):
	velocity.y += EngineParameters.GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _upd_walking_timer_duration():
	walking_timer.set_wait_time(Utils.pick_random(POSSIBLE_WALKING_TIMER_DURATIONS))

func _walk():
	velocity.x = lerp(velocity.x, speed * direction.x, acceleration)
	animation_player.play("Walking")

func _stop_walking():
	velocity.x = lerp(velocity.x, Vector2.ZERO.x, friction)

func _idle():
	_stop_walking()
	animation_player.play("Idle")

func _flip():
	velocity.x = 0
	direction = -direction
	self.scale.x *= -1

func _change_direction_if_needed():
	if not is_on_floor():
		return
	
	if !cliff_detector.is_colliding():
		state = NEW_DIRECTION
		return

	if wall_detector.is_colliding():
		state = NEW_DIRECTION
		return

func _reset_walking_timer():
	_upd_walking_timer_duration()
	walking_timer.start()

func _on_WalkingTimer_timeout():
	match state:
		IDLE:
			state = WALK
		WALK:
			state = IDLE

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Waving":
		state = IDLE


func _on_Area2D_body_entered(body):
	if state != WAVING:
		animation_player.play("Waving")
		state = WAVING
