extends KinematicBody2D

onready var stand_hit_box = $StandHitBox
onready var crawl_hit_box = $CrawlHitBox

export (int) var MAX_JUMPS = 2

export (int) var walk_speed = 400
export (float, 0, 1.0) var walk_acceleration = 0.25

export (int) var crawl_speed = 300
export (float, 0, 1.0) var crawl_acceleration = 0.75

export (int) var hover_speed = 400

export (int) var jump_speed = -1100

export (int) var gravity = 4000

var velocity = Vector2.ZERO
var jump_count = 0
var is_crawling = false

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var air_friction = 0.5

var direction

func crouch():
	is_crawling = true
	self.stand_hit_box.disabled = true
	self.crawl_hit_box.disabled = false
	
func stand():
	self.stand_hit_box.disabled = false
	self.crawl_hit_box.disabled = true
	is_crawling = false

func get_input():
	direction = 0
	if Input.is_action_pressed("walk_right"):
		direction = 1
	if Input.is_action_pressed("walk_left"):
		direction = -1
	if Input.is_action_just_pressed("down"):
		crouch()
	elif Input.is_action_just_released("down"):
		stand()

func _physics_process(delta):
	get_input()
	var speed
	var acceleration

	if is_on_floor():
		jump_count = 0
	elif jump_count == 0:
		jump_count = 1

	if Input.is_action_just_pressed("jump") && jump_count < MAX_JUMPS:
		jump_count += 1
		velocity.y = jump_speed
		is_crawling = false

	elif Input.is_action_just_released("jump"):	
		velocity.y = lerp(velocity.y, hover_speed, air_friction)
	else:
		velocity.y += gravity * delta
		
	
	if (is_crawling):
		speed = crawl_speed
		acceleration = crawl_acceleration
	else:
		speed = walk_speed
		acceleration = walk_acceleration

	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		
	velocity = move_and_slide(velocity, Vector2.UP)
