extends Node2D

var enemy_death_particles = preload("res://Particles/EnemyDeathParticles.tscn")

onready var dialog_handler = $CanvasLayer/DialogManager

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("player_died", self, "_player_died")
	dialog_handler.connect("end", self, "end_dialog")
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.connect("died", self, "add_explosion")
	
	var friends = get_tree().get_nodes_in_group("friend")
	for friend in friends:
		friend.connect("trigger_dialog", self, "open_dialog")

func _player_died():
	get_tree().change_scene("res://World.tscn")

func add_explosion(position: Vector2):
	var d = enemy_death_particles.instance()
	d.position = position
	self.add_child(d)
	d.emitting = true
	pass

func open_dialog(friend_name: String):
	get_tree().paused = true
	dialog_handler.start(friend_name)
	
func end_dialog():
	get_tree().paused = false
