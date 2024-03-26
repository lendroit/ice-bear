extends CharacterBody2D

signal died

@export var speed: int = 200
@export var friction: float = 0.1
@export var acceleration: float = 0.25
@export var HEALTH_POINTS: int = 1

var gravity_sensible = false
var possible_walking_timer_durations = [1.5]
var possible_states_after_idle = [WALK]
var possible_states_after_walk = [NEW_DIRECTION]
var possible_states_after_new_direction = [WALK]

@onready var walking_timer = $WalkingTimer
@onready var sprite = $SpriteContainer/Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var hitbox_collider = $HitBox/HitBoxCollider

var walking := true
var custom_velocity := Vector2.ZERO
var direction := Vector2.LEFT
var is_visible_by_player := false

enum {
	IDLE,
	NEW_DIRECTION,
	WALK
}

var state = WALK

##########

func upd_walking_timer_duration():
	walking_timer.set_wait_time(Utils.pick_random(possible_walking_timer_durations))

func walk():
	custom_velocity.x = lerp(custom_velocity.x, speed * direction.x, acceleration)
	animation_player.play("Walking")

func idle():
	custom_velocity.x = lerp(custom_velocity.x, Vector2.ZERO.x, friction)
	animation_player.play("Idle")

func flip():
	custom_velocity.x = 0
	direction = -direction
	sprite.flip_h = !sprite.flip_h

func reset_walking_timer():
	upd_walking_timer_duration()
	walking_timer.start()

func generic_enemy_hurt():
	HEALTH_POINTS -= 1
	if(HEALTH_POINTS < 1):
		generic_enemy_death()
	
func generic_enemy_death():
	# We use the hitbox collider's position because we're
	# sure it's going to be centered
	emit_signal("died", hitbox_collider.global_position)
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
			state = Utils.pick_random(possible_states_after_new_direction)
		WALK:
			walk()

func _physics_process(delta):
	if(gravity_sensible):
		custom_velocity.y += EngineParameters.GRAVITY * delta
	set_velocity(custom_velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	custom_velocity = custom_velocity

func _on_WalkingTimer_timeout():
	match state:
		IDLE:
			state = Utils.pick_random(possible_states_after_idle)
		WALK:
			state = Utils.pick_random(possible_states_after_walk)

func _on_LeftWallDetector_body_entered(_body):
	state = NEW_DIRECTION

func _on_RightWallDetector_body_entered(_body):
	state = NEW_DIRECTION
	
func _on_HitBox_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	if not (_area is Glaire):
		return
	generic_enemy_hurt()

func _on_VisibilityNotifier2D_screen_entered():
	is_visible_by_player = true

func _on_VisibilityNotifier2D_screen_exited():
	is_visible_by_player = false
