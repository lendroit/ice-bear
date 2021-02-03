tool
extends Control

export(String, "lama", "beaver", "kangaroo", "snake", "crow") var current_dialog_name setget set_current_dialog

signal end

onready var lama = $Lama
onready var beaver = $Beaver
onready var kangaroo = $Kangaroo
onready var snake = $Snake
onready var crow = $Crow
onready var all_friends = [lama, beaver, kangaroo, snake, crow]

func _ready():
	for child in get_children():
		child.connect("end", self, "end_dialog")

func _hide_all_friends():
	for friend in all_friends:
		friend.visible = false

func start(dialog_name: String):
	_hide_all_friends()
	match dialog_name:
		"lama":
			lama.visible = true
			lama.start()
		"beaver":
			beaver.visible = true
			beaver.start()
		"kangaroo":
			kangaroo.visible = true
			kangaroo.start()
		"snake":
			snake.visible = true
			snake.start()
		"crow":
			crow.visible = true
			crow.start()
		_:
			emit_signal("end")

func end_dialog():
	emit_signal("end")

func set_current_dialog(new_dialog: String):
	start(new_dialog)
