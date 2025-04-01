extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_input_text_changed()

var lastArrows:Array[Vector2i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var mouseCoords = local_to_map(to_local(get_global_mouse_position()))

func vector2IArrayContains(vector2IArray:Array[Vector2i], vector2I:Vector2i):
	for checkVector2I in vector2IArray:
		if checkVector2I.x == vector2I.x && checkVector2I.y == vector2I.y:
			return true
	return false

var height:int = 12
var width:int = 12

var tileBoards = []

func _on_input_text_changed() -> void:
	clearAll()
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
		#$"../OctodotTiles".transform.origin.x = 102
		#$"../LaserTiles".transform.origin.x = 102
	if width % 2 == 1:
		transform.origin.y = 60 - (4 * scale.y)
		$"../OctodotTiles".transform.origin.y = 60 - (4 * scale.y)
		$"../LaserTiles".transform.origin.y = 60 - (4 * scale.y)
	else:
		transform.origin.y = 60
		$"../OctodotTiles".transform.origin.y = 60
		$"../LaserTiles".transform.origin.y = 60
	generateBoard(0, 0)
	var scalarX =  204 / (float(width + 2) * 8)
	var scalarY =  120 / (float(height + 2) * 8)
	scale.x = min(scalarX, scalarY)
	scale.y = min(scalarX, scalarY)
	$"../OctodotTiles".scale.x = min(scalarX, scalarY)
	$"../OctodotTiles".scale.y = min(scalarX, scalarY)
	$"../LaserTiles".scale.x = min(scalarX, scalarY)
	$"../LaserTiles".scale.y = min(scalarX, scalarY)
	
func clearAll():
	clear()
	#$"../OctodotTiles".clear()
	#$"../LaserTiles".clear()
	#$"../LaserTiles".lazerLetter = "a"
	$"../../logText".text = ""

func generateBoard(xOffset:int, yOffset:int):
	#left column
	for y in range(0, height):
		@warning_ignore("integer_division")
		set_cell(Vector2i(-1 - width / 2 + xOffset, y - height / 2 + yOffset),0, Vector2i(0, 1))
	#middle (top to bottom)
	for n1 in range(0, width):
		@warning_ignore("integer_division")
		set_cell(Vector2i(n1 - width / 2 + xOffset, -1 - height / 2 + yOffset),0, Vector2i(0, 2))
		#checker board
		for n2 in range(0, height):
			@warning_ignore("integer_division")
			set_cell(Vector2i(n1 - width / 2 + xOffset, n2 - height / 2 + yOffset),1, Vector2i((n1 + n2) % 2, 0))
		@warning_ignore("integer_division")
		set_cell(Vector2i(n1 - width / 2 + xOffset, height / 2 + height % 2 + yOffset),0, Vector2i(0, 0))
	#right collumn
	for n in range(0, height):
		@warning_ignore("integer_division")
		set_cell(Vector2i(width / 2 + width % 2 + xOffset, n - height / 2 + yOffset),0, Vector2i(0, 3))
