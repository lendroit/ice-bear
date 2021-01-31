extends Control

export (String) var text = ""
export (Texture) var portrait

onready var text_node = $DialogBorder/Text
onready var portrait_node = $Portrait

# Called when the node enters the scene tree for the first time.
func _ready():
	text_node.text = text
	portrait_node.texture = portrait


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
