extends KinematicBody2D

onready var stand_hit_box = $StandHitBox
onready var crawl_hit_box = $CrawlHitBox

export (int) var MAX_JUMPS = 2

#		WALK VARIALES
export (int) var WALK_SPEED = 400
export (float, 0, 1.0) var WALK_ACCELERATION = 0.25
export (float, 0, 1.0) var WALK_FRICTION = .55

#		CRAWL VARIALES
export (int) var CRAWL_SPEED = 200
export (float, 0, 1.0) var CRAWL_ACCELERATION = 0.75
export (float, 0, 1.0) var CRAWL_FRICTION = .9

#		HOVER VARIALES
export (int) var HOVER_SPEED = 300
export (float, 0, 1.0) var AIR_FRICTION = .4

#		JUMP VARIALES
export (int) var JUMP_SPEED = -1100

var velocity = Vector2.ZERO
var jump_count = 0
var is_crawling = false

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
	if Input.is_action_just_pressed("down") && is_on_floor():
		crouch()
	elif Input.is_action_just_released("down"):
		stand()

func handle_jump(delta):
	if is_on_floor():
		jump_count = 0
	elif jump_count == 0:
		jump_count = 1

	if Input.is_action_just_pressed("jump") && jump_count < MAX_JUMPS:
		jump_count += 1
		velocity.y = JUMP_SPEED
		is_crawling = false

	elif Input.is_action_pressed("jump") && velocity.y > 0:
		velocity.y = lerp(velocity.y, HOVER_SPEED, AIR_FRICTION)
	else:
		velocity.y += EngineParameters.GRAVITY * delta

func _physics_process(delta):
	get_input()
	var speed
	var acceleration
	var friction

	handle_jump(delta)

	if (is_crawling):
		speed = CRAWL_SPEED
		acceleration = CRAWL_ACCELERATION
		friction = CRAWL_FRICTION
	else:
		speed = WALK_SPEED
		acceleration = WALK_ACCELERATION
		friction = WALK_FRICTION

	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

	velocity = move_and_slide(velocity, Vector2.UP)

func _on_HurtBox_area_shape_entered(area_id, area, area_shape, self_shape):
	print("Aie !")
