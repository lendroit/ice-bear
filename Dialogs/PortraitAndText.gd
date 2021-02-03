tool
extends Control

export (String) var text = "" setget set_text
export (Texture) var portrait setget set_portrait

onready var text_node = $DialogBorder/Text
onready var portrait_node = $Portrait

# Called when the node enters the scene tree for the first time.
func _ready():
	text_node.text = text
	portrait_node.texture = portrait

func set_text(new_text: String):
	text = new_text
	if text_node:
		text_node.text = new_text

func set_portrait(new_portrait: Texture):
	portrait = new_portrait
	if portrait_node:
		portrait_node.texture = new_portrait
