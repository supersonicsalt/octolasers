extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_input_text_changed()

var currentArrow:Vector2i = Vector2i(0,0)
var lastArrow:Vector2i = Vector2i(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var mouseCoords = local_to_map(to_local(get_global_mouse_position()))
	setHoveringIndicator(mouseCoords)
	#setHoveringIndicatorOptimized(mouseCoords)

func setHoveringIndicatorOptimized(mouseCoords):
	if mouseCoords != currentArrow && get_cell_source_id(mouseCoords) == 0 && get_cell_atlas_coords(mouseCoords).x == 0:
		set_cell(mouseCoords, 0, Vector2i(1, get_cell_atlas_coords(mouseCoords).y))
		lastArrow = currentArrow
		currentArrow = mouseCoords
	elif mouseCoords != lastArrow && get_cell_source_id(lastArrow) == 0 && get_cell_atlas_coords(lastArrow).x == 1:
		set_cell(lastArrow, 0, Vector2i(0, get_cell_atlas_coords(lastArrow).y))
		lastArrow = currentArrow
		currentArrow = mouseCoords

func setHoveringIndicator(mouseCoords):
	var cellInfo
	for n in width:
		@warning_ignore("integer_division")
		cellInfo = $"../LaserTiles".get_cell_atlas_coords(Vector2i(n - width / 2, height / 2 + height % 2 - 1))
		@warning_ignore("integer_division")
		if Vector2i(n - width / 2, height / 2 + height % 2) == mouseCoords || cellInfo == Vector2i(0, 0) || cellInfo == Vector2i(1, 0) || cellInfo == Vector2i(0, 2) || cellInfo == Vector2i(2, 0) || cellInfo == Vector2i(4, 1) || cellInfo == Vector2i(4, 2) || $"../OctodotTiles".get_cell_source_id(Vector2i(n - width / 2, height / 2 + height % 2 - 2)) == 1:
			@warning_ignore("integer_division")
			set_cell(Vector2i(n - width / 2, height / 2 + height % 2), 0, Vector2i(1, 0))
		else:
			@warning_ignore("integer_division")
			set_cell(Vector2i(n - width / 2, height / 2 + height % 2), 0, Vector2i(0, 0))
		@warning_ignore("integer_division")
		cellInfo = $"../LaserTiles".get_cell_atlas_coords(Vector2i(n - width / 2, -height / 2))
		@warning_ignore("integer_division")
		if Vector2i(n - width / 2, -1 - height / 2) == mouseCoords || cellInfo == Vector2i(0, 0) || cellInfo == Vector2i(0, 2) || cellInfo == Vector2i(1, 2) || cellInfo == Vector2i(2, 2) || cellInfo == Vector2i(4, 0) || cellInfo == Vector2i(4, 3) || $"../OctodotTiles".get_cell_source_id(Vector2i(n - width / 2, -height / 2 + 1)) == 1:
			@warning_ignore("integer_division")
			set_cell(Vector2i(n - width / 2, -1 - height / 2), 0, Vector2i(1, 2))
		else:
			@warning_ignore("integer_division")
			set_cell(Vector2i(n - width / 2, -1 - height / 2), 0, Vector2i(0, 2))
	for n in height:
		@warning_ignore("integer_division")
		cellInfo = $"../LaserTiles".get_cell_atlas_coords(Vector2i(width / 2 + width % 2 - 1, n - height / 2))
		@warning_ignore("integer_division")
		if Vector2i(width / 2 + width % 2, n - height / 2) == mouseCoords || cellInfo == Vector2i(0, 1) || cellInfo == Vector2i(0, 2) || cellInfo == Vector2i(1, 3) || cellInfo == Vector2i(2, 3) || cellInfo == Vector2i(4, 2) || cellInfo == Vector2i(4, 3) || $"../OctodotTiles".get_cell_source_id(Vector2i(width / 2 + width % 2 - 2, n - height / 2)) == 1:
			@warning_ignore("integer_division")
			set_cell(Vector2i(width / 2 + width % 2, n - height / 2), 0, Vector2i(1, 3))
		else:
			@warning_ignore("integer_division")
			set_cell(Vector2i(width / 2 + width % 2, n - height / 2), 0, Vector2i(0, 3))
		@warning_ignore("integer_division")
		cellInfo = $"../LaserTiles".get_cell_atlas_coords(Vector2i(-width / 2, n - height / 2))
		@warning_ignore("integer_division")
		if Vector2i(-1 - width / 2, n - height / 2) == mouseCoords || cellInfo == Vector2i(0, 1) || cellInfo == Vector2i(0, 2) || cellInfo == Vector2i(1, 1) || cellInfo == Vector2i(2, 1) || cellInfo == Vector2i(4, 1) || cellInfo == Vector2i(4, 0) || $"../OctodotTiles".get_cell_source_id(Vector2i(-width / 2 + 1, n - height / 2)) == 1:
			@warning_ignore("integer_division")
			set_cell(Vector2i(-1 - width / 2, n - height / 2), 0, Vector2i(1, 1))
		else:
			@warning_ignore("integer_division")
			set_cell(Vector2i(-1 - width / 2, n - height / 2), 0, Vector2i(0, 1))

var height:int = 12
var width:int = 12

func _on_input_text_changed() -> void:
	height = $"../../heightInput".text.to_int()
	width = $"../../widthInput".text.to_int()
	if height == 0:
		height = 12
	if width == 0:
		width = 12
	if height % 2 == 1:
		transform.origin.x = 102 - (4 * scale.x)
		$"../OctodotTiles".transform.origin.x = 102 - (4 * scale.x)
		$"../LaserTiles".transform.origin.x = 102 - (4 * scale.x)
	else:
		transform.origin.x = 102
		$"../OctodotTiles".transform.origin.x = 102
		$"../LaserTiles".transform.origin.x = 102
	if width % 2 == 1:
		transform.origin.y = 60 - (4 * scale.y)
		$"../OctodotTiles".transform.origin.y = 60 - (4 * scale.y)
		$"../LaserTiles".transform.origin.y = 60 - (4 * scale.y)
	else:
		transform.origin.y = 60
		$"../OctodotTiles".transform.origin.y = 60
		$"../LaserTiles".transform.origin.y = 60
	clear()
	$"../OctodotTiles".clear()
	$"../LaserTiles".clear()
	$"../LaserTiles".lazerLetter = "a"
	$"../../logText".text = ""
	for n in range(0, height):
		@warning_ignore("integer_division")
		set_cell(Vector2i(-1 - width / 2, n - height / 2),0, Vector2i(0, 1))
	for n1 in range(0, width):
		@warning_ignore("integer_division")
		set_cell(Vector2i(n1 - width / 2, -1 - height / 2),0, Vector2i(0, 2))
		for n2 in range(0, height):
			@warning_ignore("integer_division")
			set_cell(Vector2i(n1 - width / 2, n2 - height / 2),1, Vector2i(((n1 + width / 2) + (n2 + height / 2)) % 2, 0))
		@warning_ignore("integer_division")
		set_cell(Vector2i(n1 - width / 2, height / 2 + height % 2),0, Vector2i(0, 0))
	for n in range(0, height):
		@warning_ignore("integer_division")
		set_cell(Vector2i(width / 2 + width % 2, n - height / 2),0, Vector2i(0, 3))
	
