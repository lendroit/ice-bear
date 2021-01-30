extends KinematicBody2D

onready var stand_hit_box = $StandHitBox
onready var crawl_hit_box = $CrawlHitBox
onready var sprite = $OursGoingLeft

export (int) var MAX_JUMPS = 2
export (int) var HEALTH_POINTS = 2

#		POWER (DE)ACTIVATION
export var CAN_JUMP = true
export var CAN_GLAIRE = false
export var CAN_HOVER = true
export var CAN_CRAWL = true
export var CAN_SPIT = true

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
var orientation
var ready_to_spit := true

enum leftright {left, right}

#		Handle Crachat :
export var spit_velocity = 350

var Glaire = preload("res://Glaire.tscn")

func shoot(deplacement_speed, orientation):
	var b = Glaire.instance()
	owner.add_child(b)
	b.position = self.position
	#b.velocity = b.transform.x * (spit_velocity + deplacement_speed)
	b.velocity = self.velocity
	if orientation == leftright.left:
		b.velocity.x -= spit_velocity
	elif orientation == leftright.right:
		b.velocity.x += spit_velocity
	b.gravity = EngineParameters.GRAVITY
#	#	#	#	#	#	#

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
	elif Input.is_action_pressed("walk_left"):
		direction = -1
		
	if Input.is_action_just_pressed("walk_left"):
		orientation = leftright.left
	if Input.is_action_just_pressed("walk_right"):
		orientation = leftright.right
	if Input.is_action_just_released("walk_left") && Input.is_action_pressed("walk_right"):
		orientation = leftright.right
	elif Input.is_action_just_released("walk_right") && Input.is_action_pressed("walk_left"):
		orientation = leftright.left
		
	if Input.is_action_just_pressed("Glaire") && CAN_GLAIRE && ready_to_spit && CAN_SPIT:
		shoot(velocity.x, orientation)
		ready_to_spit = false
		
	if Input.is_action_just_pressed("down") && is_on_floor() && CAN_CRAWL:
		crouch()
	elif Input.is_action_just_released("down"):
		stand()

func handle_jump(delta):
	if is_on_floor():
		jump_count = 0
	elif jump_count == 0:
		jump_count = 1

	if Input.is_action_just_pressed("jump") && jump_count < MAX_JUMPS && CAN_JUMP:
		jump_count += 1
		velocity.y = JUMP_SPEED
		is_crawling = false

	elif Input.is_action_pressed("jump") && velocity.y > 0 && CAN_HOVER:
		velocity.y = lerp(velocity.y, HOVER_SPEED, AIR_FRICTION)
	else:
		velocity.y += EngineParameters.GRAVITY * delta
		
func set_direction(horizontal_speed):
	if horizontal_speed < 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func player_death():
	print("Tu es mort !")
	get_tree().change_scene("res://World.tscn")

func _physics_process(delta):
	if(HEALTH_POINTS < 1):
		player_death()
	
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
	
	if abs(velocity.x) > 5:
		set_direction(velocity.x)

func _on_HurtBox_area_shape_entered(area_id, area, area_shape, self_shape):
	HEALTH_POINTS -= 1
	print(HEALTH_POINTS)


func _on_PickupBox_area_entered(area):
	if area.has_method("on_pickup"):
		area.on_pickup()
		if(area is Lama):
			CAN_GLAIRE = true


func _on_Timer_timeout():
	ready_to_spit = true
