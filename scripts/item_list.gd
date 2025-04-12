extends ItemList

var selection

func _ready() -> void:
	selection = 0
	for child in get_children():
		child.get_child(0).visible = false

func _on_color_square_mouse_entered(childNumber: int) -> void:
	var selectRect = get_child(childNumber - 1).get_child(0)
	selectRect.visible = true

func _on_color_square_mouse_exited(childNumber: int) -> void:
	if childNumber != selection:
		get_child(childNumber - 1).get_child(0).visible = false

func _on_color_square_gui_input(event: InputEvent, childNumber) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		var selectRect = get_child(selection - 1).get_child(0)
		selectRect.set_self_modulate(Color(1, 1, 1, .5))
		selectRect.visible = false
		if selection == childNumber:
			selection = 0
		else:
			selection = childNumber
			$"../colorPicker".color = get_child(selection - 1).color
			selectRect = get_child(selection - 1).get_child(0)
			selectRect.set_self_modulate(Color(1, 1, 1, 1))
			selectRect.visible = true


func _on_color_picker_color_changed(color: Color) -> void:
	var colorSquare = get_child(selection - 1)
	if  colorSquare.get_child_count() > 1:
		colorSquare.color = color
		$"../tileMaps/BoardTiles".get_child(selection - 1).modulate = Color(color, 1)
		print($"../tileMaps/BoardTiles".get_child(selection - 1).modulate)
