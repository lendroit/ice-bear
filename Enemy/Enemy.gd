extends KinematicBody2D

export (int) var speed = 200
export (int) var gravity = 4000
export (int) var direction = -1
export (float) var friction = 0.1
export (float) var acceleration = 0.25

onready var walking_timer = $WalkingTimer

var walking := true
var velocity := Vector2.ZERO

func _ready():
	walking_timer.set_wait_time(randf()+1)
	walking_timer.start()

func walk():
	if(walking):
		velocity.x = lerp(velocity.x, speed * direction, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	walk()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_RightDetector_body_exited(body):
	direction = -1


func _on_LeftDetector_body_exited(body):
	direction = 1


func _on_WalkingTimer_timeout():
	walking = !walking
	walking_timer.set_wait_time(randf()+1)
	walking_timer.start()
