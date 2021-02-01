extends Node2D

func unbuilded():
		$SpriteContainer/Unbuilded.visible = true
		$SpriteContainer/Building.visible = false
		$SpriteContainer/Builded.visible = false

func building():
		$SpriteContainer/Unbuilded.visible = false
		$SpriteContainer/Building.visible = true
		$SpriteContainer/Builded.visible = false
		animation_player.play("Building")

func builded():
		$SpriteContainer/Unbuilded.visible = false
		$SpriteContainer/Building.visible = false
		$SpriteContainer/Builded.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
