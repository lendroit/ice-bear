extends KinematicBody2D

export (int) var speed = 600
export (int) var gravity = 4000
export (int) var direction = -1
var walking := true
onready var walking_timer = $WalkingTimer

var velocity := Vector2.ZERO

func _ready():
	walking_timer.set_wait_time(randf()+1)
	walking_timer.start()

func walk():
	if(walking):
		velocity.x = speed * direction
	else:
		velocity.x = 0

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
