extends KinematicBody2D

class_name Player

onready var spit = $AudioPlayer/Spit
onready var death = $AudioPlayer/Death
onready var beaver = $AudioPlayer/Beaver

signal player_died
signal player_win

onready var sprite = $SpriteContainer
onready var animation_player = $SpriteAnimationPlayer
onready var glaire_muzzle = $GlaireMuzzle
onready var beaver_muzzle = $BeaverMuzzle
onready var shoot_timer = $ShootTimer
onready var backpack = $SpriteContainer/Body/Backpack
onready var hook_muzzle = $Hook

var velocity = Vector2.ZERO
var jump_count = 0

var direction
var orientation = 1
var ready_to_shoot := true

var glaire_scene = preload("res://Player/Glaire.tscn")
var beaver_projectile = preload("res://Player/BeaverProjectile.tscn")

func _ready():
	hook_muzzle.custom_init(self)

func reset_shoot_timer():
	shoot_timer.set_wait_time(PlayerParameters.PLAYER_SHOOT_TIMER_TIME)
	shoot_timer.start()

func shoot():
	ready_to_shoot = false
	reset_shoot_timer()
	var new_glaire = glaire_scene.instance()
	owner.add_child(new_glaire)
	new_glaire.custom_init(self, glaire_muzzle, orientation)

func build():
	ready_to_shoot = false
	reset_shoot_timer()
	var new_beaver_projectile = beaver_projectile.instance()
	owner.add_child(new_beaver_projectile)
	new_beaver_projectile.custom_init(self, beaver_muzzle, orientation)

func hook():
	hook_muzzle.hook()
	if hook_muzzle.hook_direction.x != 0:
		orientation = sign(hook_muzzle.hook_direction.x)

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

	hook_muzzle.draw_hook()

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

func _on_HurtBox_body_entered(body):
	if(body is Shit):
		player_hurt()
	if(body is Water):
		player_death()
	if(body is VictoryZone):
		player_win()
