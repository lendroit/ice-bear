extends KinematicBody2D

signal died

export (int) var speed = 200
export (float) var friction = 0.1
export (float) var acceleration = 0.25
export (bool) var gravity_sensible = false
export (int) var HEALTH_POINTS = 1

var possible_walking_timer_durations = [1.5]
var possible_states_after_idle = [WALK]
var possible_states_after_walk = [NEW_DIRECTION]
var possible_states_after_new_direction = [WALK]

onready var walking_timer = $WalkingTimer
onready var sprite = $SpriteContainer/Sprite
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
	walking_timer.set_wait_time(choose(possible_walking_timer_durations))

func walk():
	velocity.x = lerp(velocity.x, speed * direction.x, acceleration)
	animation_player.play("Walking")

func idle():
	velocity.x = lerp(velocity.x, Vector2.ZERO.x, friction)
	animation_player.play("Idle")

func flip():
	velocity.x = 0
	direction = -direction
	sprite.flip_h = !sprite.flip_h

func choose(array):
	array.shuffle()
	return array.front()

func reset_walking_timer():
	upd_walking_timer_duration()
	walking_timer.start()

func generic_enemy_death():
	print("enemy dead")
	emit_signal("died", self.position)
	queue_free()

##########

func _ready():
	reset_walking_timer()

func _process(_delta):
	if(HEALTH_POINTS < 1):
		generic_enemy_death()
	
	match state:
		IDLE:
			idle()
		NEW_DIRECTION:
			flip()
			state = choose(possible_states_after_new_direction)
		WALK:
			walk()

func _physics_process(delta):
	if(gravity_sensible):
		velocity.y += EngineParameters.GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_WalkingTimer_timeout():
	match state:
		IDLE:
			state = choose(possible_states_after_idle)
		WALK:
			state = choose(possible_states_after_walk)

func _on_LeftWallDetector_body_entered(_body):
	state = NEW_DIRECTION

func _on_RightWallDetector_body_entered(_body):
	state = NEW_DIRECTION

func _on_HitBox_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	HEALTH_POINTS -= 1
	print("enemy aie")
	if HEALTH_POINTS == 0:
		generic_enemy_death()
