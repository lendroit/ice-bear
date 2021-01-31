extends KinematicBody2D

class_name Player

var spit_sounds = [
	preload("res://assets/sound/spit/spit1.wav"),
	preload("res://assets/sound/spit/spit2.wav"),
	preload("res://assets/sound/spit/spit3.wav"),
	preload("res://assets/sound/spit/spit4.wav"),
	preload("res://assets/sound/spit/spit5.wav"),
	preload("res://assets/sound/spit/spit6.wav"),
	preload("res://assets/sound/spit/spit7.wav"),
	preload("res://assets/sound/spit/spit8.wav"),
	preload("res://assets/sound/spit/spit9.wav"),
	preload("res://assets/sound/spit/spit10.wav"),
	preload("res://assets/sound/spit/spit11.wav"),
	preload("res://assets/sound/spit/spit12.wav"),
	preload("res://assets/sound/spit/spit13.wav"),
	preload("res://assets/sound/spit/spit14.wav")
 ]

var death_sounds = [
	preload("res://assets/sound/player_death/death_01_session.wav"),
	preload("res://assets/sound/player_death/death_02_session.wav"),
	preload("res://assets/sound/player_death/death_03_session.wav"),
	preload("res://assets/sound/player_death/death_04_session.wav"),
	preload("res://assets/sound/player_death/death_05_session.wav"),
	preload("res://assets/sound/player_death/death_06_session.wav"),
	preload("res://assets/sound/player_death/death_07_session.wav"),
	preload("res://assets/sound/player_death/death_08_session.wav"),
	preload("res://assets/sound/player_death/death_09_session.wav")
]

onready var spit = $AudioPlayer/Spit
onready var death = $AudioPlayer/Death

signal player_died

onready var stand_hit_box = $StandHitBox
onready var sprite = $SpriteContainer
onready var animation_player = $SpriteAnimationPlayer
onready var reachable_hooks_area = $ReachableHooksArea
onready var hook_position_tween = $HookPositionTween
onready var grappling_hook_rope = $GrapplingHookRope
onready var glaire_muzzle = $GlaireMuzzle
onready var beaver_muzzle = $BeaverMuzzle
onready var shoot_timer = $ShootTimer

export (int) var MAX_JUMPS = 1
export (int) var HEALTH_POINTS = 2

#		POWER (DE)ACTIVATION
export var HAS_GLAIRE_POWER = false
export var HAS_HOVER_POWER = false
export var HAS_HOOK_POWER = false
export var HAS_BUILD_POWER = false

#		WALK VARIALES
export (int) var WALK_SPEED = 400
export (float, 0, 1.0) var WALK_ACCELERATION = 0.25
export (float, 0, 1.0) var WALK_FRICTION = .55
export (int) var GRAPPLING_HOOK_SPEED = 2000

#		HOVER VARIALES
export (int) var HOVER_SPEED = 300
export (float, 0, 1.0) var AIR_FRICTION = .1

#		JUMP VARIALES
export (int) var JUMP_SPEED = -1100

#		SHOOT VARIALES
export (float) var SHOOT_TIMER_TIME = 0.5

var velocity = Vector2.ZERO
var jump_count = 0

var direction
var orientation
var ready_to_shoot := true
var hooked_node

enum leftright {left, right}

export var spit_velocity = 650

var Glaire = preload("res://Glaire.tscn")
var beaver_projectile = preload("res://BeaverProjectile.tscn")

func reset_shoot_timer():
	shoot_timer.set_wait_time(SHOOT_TIMER_TIME)
	shoot_timer.start()

func shoot():
	ready_to_shoot = false
	reset_shoot_timer()
	var b = Glaire.instance()
	owner.add_child(b)
	b.position = self.position + glaire_muzzle.position
	b.velocity = self.velocity
	if orientation == leftright.left:
		b.velocity.x -= spit_velocity
	elif orientation == leftright.right:
		b.velocity.x += spit_velocity
	b.gravity = EngineParameters.GRAVITY

func build():
	ready_to_shoot = false
	reset_shoot_timer()
	var b = beaver_projectile.instance()
	owner.add_child(b)
	b.position = self.position + beaver_muzzle.position
	b.velocity = self.velocity
	if orientation == leftright.left:
		b.velocity.x -= spit_velocity
	elif orientation == leftright.right:
		b.velocity.x += spit_velocity
	b.gravity = EngineParameters.GRAVITY

func hook():
	if (!HAS_HOOK_POWER):
		return

	var hooks_in_area = reachable_hooks_area.get_overlapping_areas()
	var upper_hooks = Utils.filter(funcref(self, "keep_upper_hooks"), hooks_in_area)
	if(upper_hooks.size() == 0):
		return
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

	if Input.is_action_just_pressed("Glaire") && HAS_GLAIRE_POWER && ready_to_shoot:
		_play_spit_sound()
		shoot()

	if Input.is_action_just_pressed("build") && HAS_BUILD_POWER && ready_to_shoot:
		build()

	if Input.is_action_just_pressed("hook"):
		hook()

func handle_jump(delta):
	if is_on_floor():
		jump_count = 0
	elif jump_count == 0:
		jump_count = 1

	if Input.is_action_just_pressed("jump") && jump_count < MAX_JUMPS:
		jump_count += 1
		velocity.y = JUMP_SPEED

	elif Input.is_action_pressed("jump") && velocity.y > 0 && HAS_HOVER_POWER:
		velocity.y = lerp(velocity.y, HOVER_SPEED, AIR_FRICTION)
	else:
		velocity.y += EngineParameters.GRAVITY * delta

func set_direction(horizontal_speed):
	sprite.scale.x = sign(horizontal_speed) * abs(sprite.scale.x)

func player_death():
	print("Tu es mort !")
	_play_death_sound()
	emit_signal("player_died")

func draw_hook():
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

func _physics_process(delta):
	get_input()
	handle_jump(delta)

	var friction = WALK_FRICTION if is_on_floor() else AIR_FRICTION

	if direction != 0:
		velocity.x = lerp(velocity.x, direction * WALK_SPEED, WALK_ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

	velocity = move_and_slide(velocity, Vector2.UP)

	if abs(velocity.x) > 5:
		set_direction(velocity.x)

	draw_hook()

func player_hurt():
	HEALTH_POINTS -= 1
	if HEALTH_POINTS < 1:
		player_death()

func _on_HurtBox_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	player_hurt()

func _on_PickupBox_area_entered(area):
	if area.has_method("on_pickup"):
		area.on_pickup()
		if(area is Lama):
			HAS_GLAIRE_POWER = true
		if(area is Snake):
			HAS_HOOK_POWER = true
		if(area is Crow):
			HAS_HOVER_POWER = true
		if(area is Beaver):
			HAS_BUILD_POWER = true
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
	ready_to_shoot = true

static func reduce(function: FuncRef, i_array: Array, first = null):
	var acc = first
	var start := 0
	if acc == null:
		acc = i_array[0]
		start = 1
	for index in range(start,i_array.size()):
		acc = function.call_func(acc,i_array[index])
	return acc

func _play_spit_sound():
	var random_index = randi()%spit_sounds.size()
	spit.stream = spit_sounds[random_index]
	spit.play()

func _play_death_sound():
	# var random_index = randi()%death_sounds.size()
	death.stream = death_sounds[1]#[random_index]
	death.play()

func _on_HookPositionTween_tween_all_completed():
	hooked_node = null
	pass # Replace with function body.


func _on_HurtBox_body_entered(body):
	if !(body is Water):
		return
	player_death()
