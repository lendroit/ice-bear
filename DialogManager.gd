extends Control

signal end

onready var lama = $Lama
onready var beaver = $Beaver

func _ready():
	for child in get_children():
		child.connect("end", self, "end_dialog")

func start(dialog_name: String):
	match dialog_name:
		"lama":
			lama.start()
		"beaver":
			beaver.start()
		_:
			emit_signal("end")

func end_dialog():
	emit_signal("end")
