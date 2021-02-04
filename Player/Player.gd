extends KinematicBody2D

class_name Player

onready var spit = $AudioPlayer/Spit
onready var death = $AudioPlayer/Death
onready var beaver = $AudioPlayer/Beaver

signal player_died
signal player_win

onready var sprite = $SpriteContainer
onready var animation_player = $SpriteAnimationPlayer
onready var reachable_hooks_area = $ReachableHooksArea
onready var hook_position_tween = $HookPositionTween
onready var grappling_hook_rope = $GrapplingHookRope
onready var glaire_muzzle = $GlaireMuzzle
onready var beaver_muzzle = $BeaverMuzzle
onready var shoot_timer = $ShootTimer
onready var backpack = $SpriteContainer/Backpack

var velocity = Vector2.ZERO
var jump_count = 0

var direction
var orientation = 1
var ready_to_shoot := true
var hooked_node

var Glaire = preload("res://Player/Glaire.tscn")
var beaver_projectile = preload("res://Player/BeaverProjectile.tscn")

func reset_shoot_timer():
	shoot_timer.set_wait_time(PlayerParameters.PLAYER_SHOOT_TIMER_TIME)
	shoot_timer.start()

func shoot():
	ready_to_shoot = false
	reset_shoot_timer()
	var b = Glaire.instance()
	owner.add_child(b)
	b.position = self.position + glaire_muzzle.position
	b.velocity = self.velocity
	b.velocity.x += orientation * PlayerParameters.PLAYER_SPIT_VELOCITY
	b.gravity = EngineParameters.GRAVITY

func build():
	ready_to_shoot = false
	reset_shoot_timer()
	var b = beaver_projectile.instance()
	owner.add_child(b)
	b.position = self.position + beaver_muzzle.position
	b.velocity = self.velocity
	b.velocity.x += orientation * PlayerParameters.PLAYER_SPIT_VELOCITY
	b.gravity = EngineParameters.GRAVITY

func hook():
	if (!PlayerParameters.PLAYER_CAN_HOOK):
		return

	var hooks_in_area = reachable_hooks_area.get_overlapping_areas()
	var upper_hooks = Utils.filter(funcref(self, "keep_upper_hooks"), hooks_in_area)
	if(upper_hooks.size() == 0):
		return
	var uppest_hook = Utils.reduce(funcref(self, "get_higher_hook"), upper_hooks, upper_hooks[0])
	hooked_node = uppest_hook
	grappling_hook_rope.visible = true

	var hook_direction = (uppest_hook.position - self.position).normalized()*PlayerParameters.PLAYER_GRAPPLING_HOOK_SPEED
	hook_position_tween.interpolate_property(self, "velocity", self.velocity, hook_direction, 0.1, Tween.TRANS_LINEAR)
	hook_position_tween.start()
	orientation = sign(hook_direction.x)

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
		orientation = -1
	if Input.is_action_just_pressed("walk_right"):
		animation_player.play("Walking")
		orientation = 1
	if Input.is_action_just_released("walk_left") && Input.is_action_pressed("walk_right"):
		orientation = 1
	elif Input.is_action_just_released("walk_right") && Input.is_action_pressed("walk_left"):
		orientation = -1

	if Input.is_action_just_pressed("Glaire") && PlayerParameters.PLAYER_CAN_GLAIRE && ready_to_shoot:
		_play_spit_sound()
		shoot()

	if Input.is_action_just_pressed("build") && PlayerParameters.PLAYER_CAN_BUILD && ready_to_shoot:
		_play_beaver_sound()
		build()

	if Input.is_action_just_pressed("hook"):
		hook()

func handle_jump(delta):
	if is_on_floor():
		jump_count = 0
	elif jump_count == 0:
		jump_count = 1

	if Input.is_action_just_pressed("jump") && jump_count < PlayerParameters.PLAYER_MAX_JUMPS:
		jump_count += 1
		velocity.y = PlayerParameters.PLAYER_JUMP_SPEED
	elif Input.is_action_pressed("jump") && velocity.y > 0 && PlayerParameters.PLAYER_CAN_HOVER:
		velocity.y = lerp(velocity.y, PlayerParameters.PLAYER_HOVER_SPEED, PlayerParameters.PLAYER_AIR_FRICTION)
	else:
		velocity.y += EngineParameters.GRAVITY * delta

func set_direction(horizontal_speed):
	sprite.scale.x = sign(horizontal_speed) * abs(sprite.scale.x)

func player_death():
	print("Tu es mort !")
	_play_death_sound()
	emit_signal("player_died")
	
func player_win():
	print("Tu as gagné !")
	emit_signal("player_win")

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

	var friction = PlayerParameters.PLAYER_WALK_FRICTION if is_on_floor() else PlayerParameters.PLAYER_AIR_FRICTION

	if direction != 0:
		velocity.x = lerp(velocity.x, direction * PlayerParameters.PLAYER_WALK_SPEED, PlayerParameters.PLAYER_WALK_ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

	velocity = move_and_slide(velocity, Vector2.UP)

	if abs(velocity.x) > 5:
		set_direction(velocity.x)

	draw_hook()

func player_hurt():
	PlayerParameters.PLAYER_HEALTH_POINTS -= 1
	if PlayerParameters.PLAYER_HEALTH_POINTS < 1:
		player_death()

func _on_HurtBox_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	player_hurt()

func _on_PickupBox_area_entered(area):
	if area.has_method("on_pickup"):
		area.on_pickup()
		backpack.add_friend(area)
		if(area is Lama):
			PlayerParameters.PLAYER_CAN_GLAIRE = true
		if(area is Snake):
			PlayerParameters.PLAYER_CAN_HOOK = true
		if(area is Crow):
			PlayerParameters.PLAYER_CAN_HOVER = true
		if(area is Beaver):
			PlayerParameters.PLAYER_CAN_BUILD = true
		if(area is Kangaroo):
			PlayerParameters.PLAYER_MAX_JUMPS += 1

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

func _play_spit_sound():
	var random_index = randi()%PlayerParameters.PLAYER_SPIT_SOUNDS.size()
	spit.stream = PlayerParameters.PLAYER_SPIT_SOUNDS[random_index]
	spit.play()

func _play_death_sound():
	# var random_index = randi()%death_sounds.size()
	death.stream = PlayerParameters.PLAYER_DEATH_SOUNDS[1]#[random_index]
	death.play()
	
func _play_beaver_sound():
	var random_index = randi()%PlayerParameters.PLAYER_BEAVER_TOSS_SOUNDS.size()
	beaver.stream = PlayerParameters.PLAYER_BEAVER_TOSS_SOUNDS[random_index]
	beaver.play()

func _on_HookPositionTween_tween_all_completed():
	hooked_node = null
	pass # Replace with function body.


func _on_HurtBox_body_entered(body):
	if(body is Water):
		player_death()
	if(body is VictoryZone):
		player_win()
