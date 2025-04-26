extends ItemList

var pencilSelection: int

var dotSelection: bool

func _ready() -> void:
	pencilSelection = 0
	dotSelection = false
	for child in get_children():
		child.get_child(0).visible = false

func _on_color_square_mouse_entered(childNumber: int) -> void:
	var selectRect: TextureRect = get_child(childNumber - 1).get_child(0)
	selectRect.visible = true

func _on_color_square_mouse_exited(childNumber: int) -> void:
	if childNumber != pencilSelection:
		get_child(childNumber - 1).get_child(0).visible = false

func _on_color_square_gui_input(event: InputEvent, childNumber: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		var selectRect: TextureRect = get_child(pencilSelection - 1).get_child(0)
		selectRect.set_self_modulate(Color(1, 1, 1, .5))
		selectRect.visible = false
		if pencilSelection == childNumber && dotSelection:
			selectRect.texture = load('res://textures/menu/selectPencil.png')
			dotSelection = false
			pencilSelection = 0
		else:
			selectRect.texture = load('res://textures/menu/selectPencil.png')
			dotSelection = false
			if pencilSelection == childNumber:
				dotSelection = true
			pencilSelection = childNumber
			$"../colorPicker".color = get_child(pencilSelection - 1).color
			selectRect = get_child(pencilSelection - 1).get_child(0)
			if dotSelection:
				selectRect.texture = load('res://textures/menu/selectDot.png')
			selectRect.set_self_modulate(Color(1, 1, 1, 1))
			selectRect.visible = true


func _on_color_picker_color_changed(color: Color) -> void:
	var colorSquare = get_child(pencilSelection - 1)
	if  colorSquare.get_child_count() > 1:
		colorSquare.color = color
		$"../tileMaps/BoardTiles".get_child(pencilSelection - 1).modulate = Color(color, 1)
		print($"../tileMaps/BoardTiles".get_child(pencilSelection - 1).modulate)
