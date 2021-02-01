extends Control

signal end

onready var lama = $Lama
onready var beaver = $Beaver
onready var kangaroo = $Kangaroo
onready var snake = $Snake
onready var crow = $Crow

func _ready():
	for child in get_children():
		child.connect("end", self, "end_dialog")

func start(dialog_name: String):
	match dialog_name:
		"lama":
			lama.start()
		"beaver":
			beaver.start()
		"kangaroo":
			kangaroo.start()
		"snake":
			snake.start()
		"crow":
			crow.start()
		_:
			emit_signal("end")

func end_dialog():
	emit_signal("end")
