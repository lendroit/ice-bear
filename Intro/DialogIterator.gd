extends Control

signal end

var current_step = 0

func print_screen(step):
	var children = get_children()
	var number_of_steps = get_children().size()
	for index in range(number_of_steps):
		var child = children[index]
		if (index) == current_step:
			child.visible = true
		else:
			child.visible = false

func _ready():
	print_screen(0)

func _input(event):
	var number_of_steps = get_children().size()
	if event.is_action_pressed("ui_accept"):
		current_step += 1
		
		if (current_step >= number_of_steps):
			emit_signal("end")
		else:
			print_screen(current_step)
