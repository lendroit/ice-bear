extends KinematicBody2D

export (int) var speed = 200
export (int) var gravity = 4000
export (int) var direction = -1
export (float) var friction = 0.1
export (float) var acceleration = 0.25

const MIN_DURATION_WALK_TIMER = 1
const MAX_DURATION_WALK_TIMER = 2

onready var walking_timer = $WalkingTimer
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

var walking := true
var velocity := Vector2.ZERO

##########

func upd_walking_timer_duration():
	walking_timer.set_wait_time(randf() * (MAX_DURATION_WALK_TIMER - MIN_DURATION_WALK_TIMER) + MIN_DURATION_WALK_TIMER)

func walk():
	if(walking):
		velocity.x = lerp(velocity.x, speed * direction, acceleration)
		animation_player.play("Walking")
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		animation_player.play("Idle")

func flip():
	direction = -direction
	sprite.flip_h = !sprite.flip_h

##########

func _ready():
	upd_walking_timer_duration()
	walking_timer.start()

func _physics_process(delta):
	walk()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_RightDetector_body_exited(body):
	flip()

func _on_LeftDetector_body_exited(body):
	flip()

func _on_WalkingTimer_timeout():
	walking = !walking
	upd_walking_timer_duration()
	walking_timer.start()
	if(walking && randf() > 0.5):
		flip()
