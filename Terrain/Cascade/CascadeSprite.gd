tool
extends Sprite

func _process(_delta):
	get_material().set_shader_param("zoom", get_viewport_transform().y.y)

func _on_Waterfall_item_rect_changed():
	get_material().set_shader_param("scale", scale)
