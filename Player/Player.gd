extends KinematicBody2D

onready var stand_hit_box = $StandHitBox
onready var crawl_hit_box = $CrawlHitBox
onready var sprite = $SpriteContainer/Sprite
onready var animation_player = $SpriteAnimationPlayer
onready var reachable_hooks_area = $ReachableHooksArea
onready var hook_position_tween = $HookPositionTween
onready var grappling_hook_rope = $GrapplingHookRope
onready var glaire_muzzle = $GlaireMuzzle

export (int) var MAX_JUMPS = 1
export (int) var HEALTH_POINTS = 2

#		POWER (DE)ACTIVATION
export var CAN_GLAIRE = false
export var CAN_HOVER = false
export var CAN_CRAWL = true
export var CAN_SPIT = true
export var CAN_HOOK = false
export var CAN_BUILD = false

#		WALK VARIALES
export (int) var WALK_SPEED = 400
export (float, 0, 1.0) var WALK_ACCELERATION = 0.25
export (float, 0, 1.0) var WALK_FRICTION = .55
export (int) var GRAPPLING_HOOK_SPEED = 2000

#		CRAWL VARIALES
export (int) var CRAWL_SPEED = 200
export (float, 0, 1.0) var CRAWL_ACCELERATION = 0.75
export (float, 0, 1.0) var CRAWL_FRICTION = .9

#		HOVER VARIALES
export (int) var HOVER_SPEED = 300
export (float, 0, 1.0) var AIR_FRICTION = .1

#		JUMP VARIALES
export (int) var JUMP_SPEED = -1100

var velocity = Vector2.ZERO
var jump_count = 0
var is_crawling = false

var direction
var orientation
var ready_to_spit := true
var hooked_node

enum leftright {left, right}

export var spit_velocity = 650

var Glaire = preload("res://Glaire.tscn")

func shoot():
	var b = Glaire.instance()
	owner.add_child(b)
	b.position = self.position + glaire_muzzle.position
	print(b.position)
	b.velocity = self.velocity
	if orientation == leftright.left:
		b.velocity.x -= spit_velocity
	elif orientation == leftright.right:
		b.velocity.x += spit_velocity
	b.gravity = EngineParameters.GRAVITY

func crouch():
	is_crawling = true
	self.stand_hit_box.disabled = true
	self.crawl_hit_box.disabled = false

func stand():
	self.stand_hit_box.disabled = false
	self.crawl_hit_box.disabled = true
	is_crawling = false

func hook():
	if (!CAN_HOOK):
		return

	var hooks_in_area = reachable_hooks_area.get_overlapping_areas()
	var upper_hooks = filter(funcref(self, "keep_upper_hooks"), hooks_in_area)
	if(upper_hooks.size() == 0):
		return
	print(upper_hooks)
	var uppest_hook = reduce(funcref(self, "get_higher_hook"), upper_hooks, upper_hooks[0])
	hooked_node = uppest_hook
	grappling_hook_rope.visible = true

	var hook_direction = (uppest_hook.position - self.position).normalized()*GRAPPLING_HOOK_SPEED
	hook_position_tween.interpolate_property(self, "velocity", self.velocity, hook_direction, 0.1, Tween.TRANS_LINEAR)
	hook_position_tween.start()

func get_input():
	direction = 0
		
	if Input.is_action_pressed("walk_right"):
		direction = 1
	elif Input.is_action_pressed("walk_left"):
		direction = -1
	else:
		animation_player.play("Idle")
		
	if Input.is_action_just_pressed("walk_left"):
		animation_player.play("Walking")
		orientation = leftright.left
	if Input.is_action_just_pressed("walk_right"):
		animation_player.play("Walking")
		orientation = leftright.right
	if Input.is_action_just_released("walk_left") && Input.is_action_pressed("walk_right"):
		orientation = leftright.right
	elif Input.is_action_just_released("walk_right") && Input.is_action_pressed("walk_left"):
		orientation = leftright.left
		
	if Input.is_action_just_pressed("Glaire") && CAN_GLAIRE && ready_to_spit && CAN_SPIT:
		shoot()
		ready_to_spit = false

	if Input.is_action_just_pressed("hook"):
		hook()
		
	if Input.is_action_just_pressed("down") && is_on_floor() && CAN_CRAWL:
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

	elif Input.is_action_pressed("jump") && velocity.y > 0 && CAN_HOVER:
		velocity.y = lerp(velocity.y, HOVER_SPEED, AIR_FRICTION)
	else:
		velocity.y += EngineParameters.GRAVITY * delta
		
func set_direction(horizontal_speed):
	if horizontal_speed < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func player_death():
	print("Tu es mort !")
	var _useless  = get_tree().change_scene("res://World.tscn")

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
		if is_on_floor():
			speed = WALK_SPEED
			acceleration = WALK_ACCELERATION
			friction = WALK_FRICTION
		else:
			speed = WALK_SPEED
			acceleration = WALK_ACCELERATION
			friction = AIR_FRICTION

	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if abs(velocity.x) > 5:
		set_direction(velocity.x)
	if(hooked_node):
		grappling_hook_rope.visible = true
		var rope_direction =  (hooked_node.position - self.position)
		var rope_position = rope_direction/2
		var rope_angle = rope_direction.angle()
		var rope_length = rope_direction.length()
		grappling_hook_rope.position = rope_position
		grappling_hook_rope.rotation = rope_angle
		grappling_hook_rope.scale.x = rope_length/1000
	else:
		grappling_hook_rope.visible = false

func _on_HurtBox_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	HEALTH_POINTS -= 1
	print(HEALTH_POINTS)


func _on_PickupBox_area_entered(area):
	if area.has_method("on_pickup"):
		area.on_pickup()
		if(area is Lama):
			CAN_GLAIRE = true
		if(area is Snake):
			CAN_HOOK = true
		if(area is Crow):
			CAN_HOVER = true
		if(area is Beaver):
			CAN_BUILD = true
		if(area is Kangaroo):
			MAX_JUMPS += 1

func get_direction(other_area: Area2D)->Vector2:
	return other_area.position - self.position

func keep_upper_hooks(hook_area: Area2D)->bool:
	return hook_area.position.y < self.position.y

func get_higher_hook(uppest_hook: Area2D, hook: Area2D)->Area2D:
	if(uppest_hook.position.y > hook.position.y):
		return hook
	return uppest_hook

func _on_Timer_timeout():
	ready_to_spit = true

static func map(function: FuncRef, i_array: Array)->Array:
	var o_array := []
	for value in i_array:
		o_array.append(function.call_func(value))
	return o_array

static func filter(filter_function: FuncRef, candidate_array: Array)->Array:
	var filtered_array := []

	for candidate_value in candidate_array:
		if filter_function.call_func(candidate_value):
			filtered_array.append(candidate_value)

	return filtered_array

static func reduce(function: FuncRef, i_array: Array, first = null):
	var acc = first
	var start := 0
	if acc == null:
		acc = i_array[0]
		start = 1
	for index in range(start,i_array.size()):
		acc = function.call_func(acc,i_array[index])
	return acc


func _on_HookPositionTween_tween_all_completed():
	hooked_node = null
	pass # Replace with function body.
