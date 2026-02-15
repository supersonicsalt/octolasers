extends TileMapLayer
const LaserTile = preload("res://scripts/LazerTile.gd")

## all of the tileMapLayers under BoardTiles
@onready var tileMaps:Array[Node] = get_children()
var guessSet:LaserTile.LaserTile.variation = LaserTile.LaserTile.variation.noteGuess
var noteSet:LaserTile.LaserTile.variation = LaserTile.LaserTile.variation.noteCropped
var octodotSet:LaserTile.LaserTile.variation = LaserTile.LaserTile.variation.octodot
const boardTileSet:int = 1

func _ready() -> void:
	_on_input_text_changed()
	generateLaserTiles()

@onready var itemList:ItemList = $"../../itemList"

func generateLaserTiles() -> void:
	var colorSquares = itemList.get_children()
	for n in colorSquares.size():
		tileMaps[n].modulate = Color(colorSquares[n].color, 1)

var lastArrows:Array[Vector2i]

func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact"):
		if itemList.pencilSelection == 0:
			clearCell(local_to_map(to_local(get_global_mouse_position())))
		else:
			if itemList.dotSelection:
				dotCell(tileMaps[itemList.pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))
			else:
				setCell(tileMaps[itemList.pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))
	if Input.is_action_pressed("altInteract"):
		if itemList.pencilSelection == 0:
			clearCell(local_to_map(to_local(get_global_mouse_position())))
		else:
			if !itemList.dotSelection:
				dotCell(tileMaps[itemList.pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))
			else:
				setCell(tileMaps[itemList.pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))
	if Input.is_action_pressed("unInteract"):
		if itemList.pencilSelection == 0:
			clearCell(local_to_map(to_local(get_global_mouse_position())))
		else:
			eraseCell(tileMaps[itemList.pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))

func clearCell(coords: Vector2i) -> void:
	for tileMap in tileMaps:
		eraseCell(tileMap, coords)

func eraseCell(tileMap: TileMapLayer, coords: Vector2i) -> void:
	if tileMap.get_cell_source_id(coords) == octodotSet:
		modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y - 2), LaserTile.LaserTile.state.none, LaserTile.LaserTile.direction.bottom)
		modifyTileMapCell(tileMap, Vector2i(coords.x + 2, coords.y), LaserTile.LaserTile.state.none, LaserTile.LaserTile.direction.left)
		modifyTileMapCell(tileMap, Vector2i(coords.x - 2, coords.y), LaserTile.LaserTile.state.none, LaserTile.LaserTile.direction.right)
		modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y + 2), LaserTile.LaserTile.state.none, LaserTile.LaserTile.direction.top)
	else:
		if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == guessSet:
			modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y - 1), LaserTile.LaserTile.state.none, LaserTile.LaserTile.direction.bottom)
		if tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == guessSet:
			modifyTileMapCell(tileMap, Vector2i(coords.x + 1, coords.y), LaserTile.LaserTile.state.none, LaserTile.LaserTile.direction.left)
		if tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == guessSet:
			modifyTileMapCell(tileMap, Vector2i(coords.x - 1, coords.y), LaserTile.LaserTile.state.none, LaserTile.LaserTile.direction.right)
		if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == guessSet:
			modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y + 1), LaserTile.LaserTile.state.none, LaserTile.LaserTile.direction.top)
		if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == octodotSet:
			eraseCell(tileMap, Vector2i(coords.x, coords.y - 1))
		if tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == octodotSet:
			eraseCell(tileMap, Vector2i(coords.x + 1, coords.y))
		if tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == octodotSet:
			eraseCell(tileMap, Vector2i(coords.x - 1, coords.y))
		if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == octodotSet:
			eraseCell(tileMap, Vector2i(coords.x, coords.y + 1))
	tileMap.erase_cell(coords)

func setArrow(tileMap: TileMapLayer, coords: Vector2i, direction:LaserTile.LaserTile.direction) -> void:
	tileMap.set_cell(coords, guessSet, LaserTile.LaserTile.arrowAtlasCoords[direction])
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == guessSet and get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == boardTileSet:
		modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y - 1), LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.bottom)
	if tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == guessSet and get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == boardTileSet:
		modifyTileMapCell(tileMap, Vector2i(coords.x + 1, coords.y), LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.left)
	if tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == guessSet and get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == boardTileSet:
		modifyTileMapCell(tileMap, Vector2i(coords.x - 1, coords.y), LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.right)
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == guessSet and get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == boardTileSet:
		modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y + 1), LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.top)
	#updateArrow(tileMap, coords)

func updateArrow(tileMap: TileMapLayer, coords: Vector2i):
	var direction:LaserTile.LaserTile.direction = LaserTile.LaserTile.arrowAtlasToDirection(tileMap.get_cell_atlas_coords(coords))
	var start:Vector2i = coords
	if direction == LaserTile.LaserTile.direction.right:
		start.x += 1
	elif direction == LaserTile.LaserTile.direction.left:
		start.x -= 1
	elif direction == LaserTile.LaserTile.direction.bottom:
		start.y += 1
	elif direction == LaserTile.LaserTile.direction.top:
		start.y -= 1
	var inProgress:bool = direction != LaserTile.LaserTile.direction.error
	if whereOctoDot(tileMap, start, direction) == lookahead.center:
		inProgress = false
	while  inProgress:
		if get_cell_source_id(start) != boardTileSet:
			inProgress = false
	return	Vector2i(start.x, start.y)

enum lookahead {
	none = -2,
	left = -1,
	center = 0,
	right = 1
}

func whereOctoDot(tileMap:TileMapLayer, start:Vector2i, direction:LaserTile.LaserTile.direction) -> lookahead:
	if direction % 3 == 0:
		for looking:lookahead in lookahead:
			if tileMap.get_cell_source_id(Vector2i(start.x + looking, start.y - (direction / 3 * 2 - 1))):
				return (looking * (direction / 3 * 2 - 1)) as lookahead
	else:
		for looking in lookahead:
			if tileMap.get_cell_source_id(Vector2i(start.x - (direction * 2 - 3), start.y + looking)):
				return (looking * (direction * 2 - 3)) as lookahead
	return lookahead.none

func updateArrows(tileMap: TileMapLayer):
	for i in range(-5, 7):
		if tileMap.get_cell_source_id(Vector2i(-6, i)):
			updateArrow(tileMap, Vector2i(-6, i))
	for i in range(-5, 7):
		if tileMap.get_cell_source_id(Vector2i(7, i)):
			updateArrow(tileMap, Vector2i(7, i))
	for i in range(-5, 7):
		if tileMap.get_cell_source_id(Vector2i(i, -6)):
			updateArrow(tileMap, Vector2i(i, -6))
	for i in range(-5, 7):
		if tileMap.get_cell_source_id(Vector2i(i, 7)):
			updateArrow(tileMap, Vector2i(i, 7))

func setCell(tileMap: TileMapLayer, coords: Vector2i) -> void:
	if get_cell_source_id(coords) < 0:
		if get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == 1:
			setArrow(tileMap, coords, LaserTile.LaserTile.direction.top)
		if get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == 1:
			setArrow(tileMap, coords, LaserTile.LaserTile.direction.right)
		if get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == 1:
			setArrow(tileMap, coords, LaserTile.LaserTile.direction.left)
		if get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == 1:
			setArrow(tileMap, coords, LaserTile.LaserTile.direction.bottom)
		return
	if tileMap.get_cell_source_id(coords) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == octodotSet:
		return
	var laserTile:LaserTile.LaserTile = LaserTile.LaserTile.new(guessSet)
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == guessSet:
		laserTile.modifySelfCell(LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.top)
		if get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == boardTileSet:
			modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y - 1), LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.bottom)
	if tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == guessSet:
		laserTile.modifySelfCell(LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.right)
		if get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == boardTileSet:
			modifyTileMapCell(tileMap, Vector2i(coords.x + 1, coords.y), LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.left)
	if tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == guessSet:
		laserTile.modifySelfCell(LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.left)
		if get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == boardTileSet:
			modifyTileMapCell(tileMap, Vector2i(coords.x - 1, coords.y), LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.right)
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == guessSet:
		laserTile.modifySelfCell(LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.bottom)
		if get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == boardTileSet:
			modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y + 1), LaserTile.LaserTile.state.noDot, LaserTile.LaserTile.direction.top)
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 2)) == octodotSet:
		laserTile.modifySelfCell(LaserTile.LaserTile.state.withDot, LaserTile.LaserTile.direction.top)
	if tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y)) == octodotSet:
		laserTile.modifySelfCell(LaserTile.LaserTile.state.withDot, LaserTile.LaserTile.direction.right)
	if tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y)) == octodotSet:
		laserTile.modifySelfCell(LaserTile.LaserTile.state.withDot, LaserTile.LaserTile.direction.left)
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 2)) == octodotSet:
		laserTile.modifySelfCell(LaserTile.LaserTile.state.withDot, LaserTile.LaserTile.direction.bottom)
	tileMap.set_cell(coords, guessSet, laserTile.getVector2i())

func modifyTileMapCell(tileMap:TileMapLayer, coords:Vector2i, newState:LaserTile.LaserTile.state, location:LaserTile.LaserTile.direction):
	tileMap.set_cell(coords,guessSet,\
	 LaserTile.LaserTile.laserTileToAtlas(LaserTile.LaserTile.modifyCell(\
	  LaserTile.LaserTile.atlasToLaserTile(guessSet, tileMap.get_cell_atlas_coords(coords)),\
	  newState,\
	  location)))

func dotCell(tileMap: TileMapLayer, coords: Vector2i) -> void:
	if get_cell_source_id(coords) == -1 ||\
	 get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == -1 ||\
	 get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == -1 ||\
	 get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == -1 ||\
	 get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == -1 ||\
	 (tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y - 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y + 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y - 2)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y - 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y + 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y + 2)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 2)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(coords) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 2)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y - 2)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y - 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y + 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y + 2)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y - 1)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y)) == octodotSet ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y + 1)) == octodotSet):
		return
	eraseCell(tileMap, Vector2i(coords.x, coords.y - 1))
	eraseCell(tileMap, Vector2i(coords.x + 1, coords.y))
	eraseCell(tileMap, Vector2i(coords.x - 1, coords.y))
	eraseCell(tileMap, Vector2i(coords.x, coords.y + 1))
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 2)) == guessSet:
		modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y - 2), LaserTile.LaserTile.state.withDot, LaserTile.LaserTile.direction.bottom)
	if tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y)) == guessSet:
		modifyTileMapCell(tileMap, Vector2i(coords.x + 2, coords.y), LaserTile.LaserTile.state.withDot, LaserTile.LaserTile.direction.left)
	if tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y)) == guessSet:
		modifyTileMapCell(tileMap, Vector2i(coords.x - 2, coords.y), LaserTile.LaserTile.state.withDot, LaserTile.LaserTile.direction.right)
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 2)) == guessSet: 
		modifyTileMapCell(tileMap, Vector2i(coords.x, coords.y + 2), LaserTile.LaserTile.state.withDot, LaserTile.LaserTile.direction.top)
	tileMap.set_cell(coords, 3, LaserTile.LaserTile.dotAtlasCoords)

var height:int = 12
var width:int = 12

func _on_input_text_changed() -> void:
	clear()
	height = $"../../heightInput".text.to_int()
	width = $"../../widthInput".text.to_int()
	if height == 0:
		height = 12
	if width == 0:
		width = 12
	if height % 2 == 1:
		transform.origin.x = 102 - (4 * scale.x)
	else:
		transform.origin.x = 102
	if width % 2 == 1:
		transform.origin.y = 60 - (4 * scale.y)
	else:
		transform.origin.y = 60
	generateBoard(0, 0)
	var scalarX =  $"..".size.x / (float(width + 2) * 8)
	var scalarY =  $"..".size.y / (float(height + 2) * 8)
	scale.x = min(scalarX, scalarY)
	scale.y = min(scalarX, scalarY)

func clearAll():
	for tileMap in tileMaps:
		tileMap.clear()
	$"../../logText".text = ""

func generateBoard(xOffset:int, yOffset:int):
	for n1 in range(0, width):
		for n2 in range(0, height):
			@warning_ignore("integer_division")
			set_cell(Vector2i(n1 - width / 2 + xOffset, n2 - height / 2 + yOffset),1, Vector2i((n1 + n2) % 2 + 2, 0))

var confirmClear:bool = false

func _on_clear_all_pressed() -> void:
	if confirmClear:
		clearAll()
		$"../../clearAll".texture_normal = load('res://textures/menu/clearAll.png')
		confirmClear = false
	else:
		$"../../clearAll".texture_normal = load('res://textures/menu/confirmClearAll.png')
		confirmClear = true
