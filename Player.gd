extends KinematicBody2D

onready var stand_hit_box = $StandHitBox
onready var crawl_hit_box = $CrawlHitBox

export (int) var walk_speed = 1200
export (float, 0, 1.0) var walk_acceleration = 0.25

export (int) var crawl_speed = 300
export (float, 0, 1.0) var crawl_acceleration = 0.75

export (int) var hover_speed = 400

export (int) var jump_speed = -1100

export (int) var gravity = 4000

var velocity = Vector2.ZERO
var has_double_jumped = false
var is_crawling = false

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var air_friction = 0.5


func get_input():
	var dir = 0
	var speed
	var acceleration
	
	if Input.is_action_pressed("walk_right"):
		dir += 1
	if Input.is_action_pressed("walk_left"):
		dir -= 1
	if Input.is_action_just_pressed("down"):
		is_crawling = true
		self.stand_hit_box.disabled = true
		self.crawl_hit_box.disabled = false
		velocity.x = 0
	elif Input.is_action_just_released("down"):
		self.stand_hit_box.disabled = false
		self.crawl_hit_box.disabled = true
		is_crawling = false
		
	if (is_crawling):
		speed = crawl_speed
		acceleration = crawl_acceleration
	else:
		speed = walk_speed
		acceleration = walk_acceleration

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			has_double_jumped = false
			velocity.y = jump_speed
		elif not has_double_jumped:
			has_double_jumped = true
			velocity.y = jump_speed
	#elif Input.is_action_pressed("jump"):
	#	velocity.y += gravity / 2 * delta
	
	#elif Input.is_action_just_released("jump") && velocity.y<0:
	elif Input.is_action_just_released("jump"):	
		velocity.y = lerp(velocity.y, hover_speed, air_friction)
	else:
		velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
