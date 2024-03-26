@tool
extends Control

@export var text: String = "": set = set_text
@export var portrait: Texture2D : set = set_portrait

@onready var text_node = $DialogBorder/Text
@onready var portrait_node = $Portrait

# Called when the node enters the scene tree for the first time.
func _ready():
	text_node.text = text
	portrait_node.texture = portrait

func set_text(new_text: String):
	text = new_text
	if text_node:
		text_node.text = new_text

func set_portrait(new_portrait: Texture2D):
	portrait = new_portrait
	if portrait_node:
		portrait_node.texture = new_portrait
