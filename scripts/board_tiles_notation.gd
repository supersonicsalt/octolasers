extends TileMapLayer

func laser4dToAtlas(laser4d:Vector4i) -> Vector2i:
	laser4d = laser4dNormalize(laser4d)
	return Vector2i(laser4d.x + laser4d.y * 3, laser4d.z + laser4d.w * 3)

func AtlasTolaser4d(atlasCoords:Vector2i) -> Vector4i:
	@warning_ignore("integer_division")
	return Vector4i(atlasCoords.x % 3, atlasCoords.x / 3, atlasCoords.y % 3, atlasCoords.y / 3)

func laser4dNormalize(laser4d:Vector4i) -> Vector4i:
	if laser4d.x > 2 || laser4d.x < 0:
		laser4d.x = abs(laser4d.x % 3)
	if laser4d.y > 2 || laser4d.y < 0:
		laser4d.y = abs(laser4d.y % 3)
	if laser4d.z > 2 || laser4d.z < 0:
		laser4d.z = abs(laser4d.z % 3)
	if laser4d.w > 2 || laser4d.w < 0:
		laser4d.x = abs(laser4d.w % 3)
	return laser4d

enum direction {
	top = 0,
	right = 1,
	left = 2,
	bottom = 3,
}

enum state {
	none = 0,
	noDot = 1,
	withDot = 2,
}

func modifyCell(tile:Vector2i, location:direction, newValue:state) -> Vector2i:
	return laser4dToAtlas(modifyCell4d(AtlasTolaser4d(tile), location, newValue))

func modifyCell4d(tile:Vector4i, location:direction, newValue:state) -> Vector4i:
	if location == direction.top:
		tile.x = newValue
	if location == direction.right:
		tile.y = newValue
	if location == direction.left:
		tile.z = newValue
	if location == direction.bottom:
		tile.w = newValue
	return tile

var tileMaps

func _ready() -> void:
	tileMaps = get_children()
	_on_input_text_changed()
	generateLaserTiles()

func generateLaserTiles():
	var colorSquares = $"../../itemList".get_children()
	for n in colorSquares.size():
		tileMaps[n].modulate = Color(colorSquares[n].color, 1)

var lastArrows:Array[Vector2i]

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed() && $"../../itemList".selected > 0:
		setCell(tileMaps[$"../../ItemList".selected - 1], get_cell_atlas_coords(to_local(get_local_mouse_position())))

func setCell(tileMap: TileMapLayer, coords: Vector2i):
	var atlasCoords = Vector2i(-1, -1)
	if tileMap.get_cell_atlas_coords(coords) == Vector2i(-1, -1):
		tileMap.set_cell(coords, 0, atlasCoords)
	#else:
		#if tileMap.get_cell_atlas_coords(Vector2i(coords.x - 1, coords.y)) == laserTileSetDictionary.straight.horizontal:
			#tileMap.set_cell(Vector2i(coords.x - 1, coords.y), 0, laserTileSetDictionary.deadEnd.left.noDot)

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
		#$"../OctodotTiles".transform.origin.x = 102 - (4 * scale.x)
		#$"../LaserTiles".transform.origin.x = 102 - (4 * scale.x)
	else:
		transform.origin.x = 102
		#$"../OctodotTiles".transform.origin.x = 102
		#$"../LaserTiles".transform.origin.x = 102
	if width % 2 == 1:
		transform.origin.y = 60 - (4 * scale.y)
		#$"../OctodotTiles".transform.origin.y = 60 - (4 * scale.y)
		#$"../LaserTiles".transform.origin.y = 60 - (4 * scale.y)
	else:
		transform.origin.y = 60
		#$"../OctodotTiles".transform.origin.y = 60
		#$"../LaserTiles".transform.origin.y = 60
	generateBoard(0, 0)
	var scalarX =  $"..".size.x / (float(width + 2) * 8)
	var scalarY =  $"..".size.y / (float(height + 2) * 8)
	scale.x = min(scalarX, scalarY)
	scale.y = min(scalarX, scalarY)
	#$"../OctodotTiles".scale.x = min(scalarX, scalarY)
	#$"../OctodotTiles".scale.y = min(scalarX, scalarY)
	#$"../LaserTiles".scale.x = min(scalarX, scalarY)
	#$"../LaserTiles".scale.y = min(scalarX, scalarY)
	
func clearAll():
	clear()
	#$"../OctodotTiles".clear()
	#$"../LaserTiles".clear()
	#$"../LaserTiles".lazerLetter = "a"
	$"../../logText".text = ""

func generateBoard(xOffset:int, yOffset:int):
	for y in range(0, height):
		@warning_ignore("integer_division")
		set_cell(Vector2i(-1 - width / 2 + xOffset, y - height / 2 + yOffset),0, Vector2i(0, 1))
	for n1 in range(0, width):
		@warning_ignore("integer_division")
		set_cell(Vector2i(n1 - width / 2 + xOffset, -1 - height / 2 + yOffset),0, Vector2i(0, 2))
		for n2 in range(0, height):
			@warning_ignore("integer_division")
			set_cell(Vector2i(n1 - width / 2 + xOffset, n2 - height / 2 + yOffset),1, Vector2i((n1 + n2) % 2, 0))
		@warning_ignore("integer_division")
		set_cell(Vector2i(n1 - width / 2 + xOffset, height / 2 + height % 2 + yOffset),0, Vector2i(0, 0))
	for n in range(0, height):
		@warning_ignore("integer_division")
		set_cell(Vector2i(width / 2 + width % 2 + xOffset, n - height / 2 + yOffset),0, Vector2i(0, 3))
