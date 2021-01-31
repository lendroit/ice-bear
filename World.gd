extends Node2D

var enemy_death_particles = preload("res://Particles/EnemyDeathParticles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.connect("died", self, "add_explosion")

func add_explosion(position: Vector2):
	print("hey")
	var d = enemy_death_particles.instance()
	d.position = position
	self.add_child(d)
	d.emitting = true
	pass
