@tool
extends Sprite2D

func _process(_delta):
	get_material().set_shader_parameter("zoom", get_viewport_transform().y.y)

func _on_Waterfall_item_rect_changed():
	get_material().set_shader_parameter("scale", scale)
