extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tileMapsSize = $"..".size
	_on_input_text_changed()

var lastArrows:Array[Vector2i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouseCoords:Vector2 = local_to_map(to_local(get_global_mouse_position()))
	setHoveringIndicator(mouseCoords)

func setHoveringIndicator(mouseCoords) -> void:
	for lastArrow in lastArrows:
		set_cell(lastArrow, 0, Vector2i(0, get_cell_atlas_coords(lastArrow).y))
		lastArrows.erase(lastArrow)
	if get_cell_source_id(mouseCoords) == 0 && get_cell_atlas_coords(mouseCoords).x == 0:
		set_cell(mouseCoords, 0, Vector2i(1, get_cell_atlas_coords(mouseCoords).y))
		if !mouseCoords in lastArrows:
			lastArrows.append(mouseCoords)

var height:int = 12
var width:int = 12

var tileMapsSize:Vector2

func _on_input_text_changed() -> void:
	
	height = $"../../heightInput".text.to_int()
	width = $"../../widthInput".text.to_int()
	if height == 0:
		height = 12
	if width == 0:
		width = 12
	if height % 2 == 1:
		position.y = tileMapsSize.y / 2 - (4 * scale.y)
		$"../OctodotTiles".position.y = tileMapsSize.y / 2 - (4 * scale.y)
		$"../LaserTiles".position.y = tileMapsSize.y / 2 - (4 * scale.y)
	else:
		position.y = tileMapsSize.y / 2
		$"../OctodotTiles".position.y = tileMapsSize.y / 2
		$"../LaserTiles".position.y = tileMapsSize.y / 2
	if width % 2 == 1:
		position.x = tileMapsSize.x / 2 - (4 * scale.x)
		$"../OctodotTiles".position.x = tileMapsSize.x / 2 - (4 * scale.x)
		$"../LaserTiles".position.x = tileMapsSize.x / 2 - (4 * scale.x)
	else:
		position.x = tileMapsSize.x / 2
		$"../OctodotTiles".position.x = tileMapsSize.x / 2
		$"../LaserTiles".position.x = tileMapsSize.x / 2
	var scalar:float = min(tileMapsSize.x / (float(width + 2) * 8), tileMapsSize.y / (float(height + 2) * 8))
	var scalar2:Vector2 = Vector2(scalar, scalar)
	$"../OctodotTiles".scale = scalar2
	$"../LaserTiles".scale = scalar2
	clear()
	$"../OctodotTiles".clear()
	$"../LaserTiles".clear()
	$"../LaserTiles".lazerLetter = "a"
	$"../../logText".text = ""
	for n in range(0, height):
		set_cell(Vector2i(-1 - width / 2, n - height / 2),0, Vector2i(0, 1))
	for n1 in range(0, width):
		set_cell(Vector2i(n1 - width / 2, -1 - height / 2),0, Vector2i(0, 2))
		for n2 in range(0, height):
			set_cell(Vector2i(n1 - width / 2, n2 - height / 2),1, Vector2i(((n1 + width / 2) + (n2 + height / 2)) % 2, 0))
		set_cell(Vector2i(n1 - width / 2, height / 2 + height % 2),0, Vector2i(0, 0))
	for n in range(0, height):
		set_cell(Vector2i(width / 2 + width % 2, n - height / 2),0, Vector2i(0, 3))
	
