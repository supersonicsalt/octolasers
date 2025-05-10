extends TileMapLayer

class LaserTile:
	enum direction {
		top = 0,
		right = 1,
		left = 2,
		bottom = 3,
	}
	enum state {
		error = -1,
		none = 0,
		noDot = 1,
		withDot = 2,
	}
	const dotAtlasCoords = Vector2i(3, 0)
	
	static func getArrowAtlas(direct:direction) -> Vector2i:
		return Vector2i(9, direct)
	
	var top: state
	var right: state
	var left: state
	var bottom: state
	
	func _init(inpTop:state = state.none, inpRight:state = state.none, inpLeft:state = state.none, inpBottom:state = state.none):
		top = inpTop
		right = inpRight
		left = inpLeft
		bottom = inpBottom
		Normalize()
	
	func getVector2i() -> Vector2i:
		return Vector2i(top + right * 3, left + bottom * 3)
	
	static func laserTileToAtlas(laserTile:LaserTile) -> Vector2i:
		laserTile.Normalize()
		if laserTile.top < 0 || laserTile.right < 0 || laserTile.left < 0 || laserTile.bottom < 0:
			return Vector2i(-1, -1)
		return Vector2i(laserTile.top + laserTile.right * 3, laserTile.left + laserTile.bottom * 3)
	
	static func atlasToLaserTile(atlasCoords:Vector2i) -> LaserTile:
		@warning_ignore("integer_division")
		return LaserTile.new(atlasCoords.x % 3, atlasCoords.x / 3, atlasCoords.y % 3, atlasCoords.y / 3)
		
	func setFromAtlas(atlasCoords:Vector2i):
		top = (atlasCoords.x % 3) as state
		@warning_ignore("integer_division")
		right = (atlasCoords.x / 3) as state
		left = (atlasCoords.y % 3) as state
		@warning_ignore("integer_division")
		bottom = (atlasCoords.y / 3) as state
	
	func Normalize():
		if top < 0 || right < 0 || left < 0 || bottom < 0:
			top = -1 as state
			right = -1 as state
			left = -1 as state
			bottom = -1 as state
			return
		top = (top % 3) as state
		right = (right % 3) as state
		left = (left % 3) as state
		bottom = (bottom % 3) as state
	
	static func laserTileNormalize(laserTile:LaserTile) -> LaserTile:
		if laserTile.top < 0 || laserTile.right < 0 || laserTile.left < 0 || laserTile.bottom < 0:
			return LaserTile.new(-1 as state, -1 as state, -1 as state, -1 as state)
		laserTile.top = (laserTile.top % 3) as state
		laserTile.right = (laserTile.right % 3) as state
		laserTile.left = (laserTile.left % 3) as state
		laserTile.bottom = (laserTile.bottom % 3) as state
		return laserTile
	
	static func modifyAtlasCell(tile:Vector2i, location:direction, newValue:state) -> Vector2i:
		return laserTileToAtlas(modifyCell(atlasToLaserTile(tile), newValue, location))
	
	func modifySelfCell(newValue:state, location:direction = direction.top) -> void:
		if location == direction.top:
			top = newValue
		if location == direction.right:
			right = newValue
		if location == direction.left:
			left = newValue
		if location == direction.bottom:
			bottom = newValue
	
	static func modifyCell(tile:LaserTile, newValue:state, location:direction = direction.top) -> LaserTile:
		if location == direction.top:
			tile.top = newValue
		if location == direction.right:
			tile.right = newValue
		if location == direction.left:
			tile.left = newValue
		if location == direction.bottom:
			tile.bottom = newValue
		return tile

## all of the tileMapLayers under BoardTiles
var tileMaps:Array[Node]

func _ready() -> void:
	tileMaps = get_children()
	_on_input_text_changed()
	generateLaserTiles()

func generateLaserTiles() -> void:
	var colorSquares = $"../../itemList".get_children()
	for n in colorSquares.size():
		tileMaps[n].modulate = Color(colorSquares[n].color, 1)

var lastArrows:Array[Vector2i]

func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact"):
		if $"../../itemList".pencilSelection == 0:
			clearCell(local_to_map(to_local(get_global_mouse_position())))
		else:
			if $"../../itemList".dotSelection:
				dotCell(tileMaps[$"../../itemList".pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))
			else:
				setCell(tileMaps[$"../../itemList".pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))
	if Input.is_action_pressed("altInteract"):
		if $"../../itemList".pencilSelection == 0:
			clearCell(local_to_map(to_local(get_global_mouse_position())))
		else:
			if !$"../../itemList".dotSelection:
				dotCell(tileMaps[$"../../itemList".pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))
			else:
				setCell(tileMaps[$"../../itemList".pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))
	if Input.is_action_pressed("unInteract"):
		if $"../../itemList".pencilSelection == 0:
			clearCell(local_to_map(to_local(get_global_mouse_position())))
		else:
			eraseCell(tileMaps[$"../../itemList".pencilSelection - 1], local_to_map(to_local(get_global_mouse_position())))

func clearCell(coords: Vector2i) -> void:
	for tileMap in tileMaps:
		eraseCell(tileMap, coords)

func eraseCell(tileMap: TileMapLayer, coords: Vector2i) -> void:
	if tileMap.get_cell_source_id(coords) == 3:
		tileMap.set_cell(Vector2i(coords.x, coords.y - 2), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x, coords.y - 2))), LaserTile.state.none, LaserTile.direction.bottom)))
		tileMap.set_cell(Vector2i(coords.x + 2, coords.y), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x + 2, coords.y))), LaserTile.state.none, LaserTile.direction.left)))
		tileMap.set_cell(Vector2i(coords.x - 2, coords.y), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x - 2, coords.y))), LaserTile.state.none, LaserTile.direction.right)))
		tileMap.set_cell(Vector2i(coords.x, coords.y + 2), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x, coords.y + 2))), LaserTile.state.none, LaserTile.direction.top)))
	else:
		if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == 2:
			tileMap.set_cell(Vector2i(coords.x, coords.y - 1), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x, coords.y - 1))), LaserTile.state.none, LaserTile.direction.bottom)))
		if tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == 2:
			tileMap.set_cell(Vector2i(coords.x + 1, coords.y), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x + 1, coords.y))), LaserTile.state.none, LaserTile.direction.left)))
		if tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == 2:
			tileMap.set_cell(Vector2i(coords.x - 1, coords.y), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x - 1, coords.y))), LaserTile.state.none, LaserTile.direction.right)))
		if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == 2:
			tileMap.set_cell(Vector2i(coords.x, coords.y + 1), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x, coords.y + 1))), LaserTile.state.none, LaserTile.direction.top)))
		if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == 3:
			eraseCell(tileMap, Vector2i(coords.x, coords.y - 1))
		if tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == 3:
			eraseCell(tileMap, Vector2i(coords.x + 1, coords.y))
		if tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == 3:
			eraseCell(tileMap, Vector2i(coords.x - 1, coords.y))
		if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == 3:
			eraseCell(tileMap, Vector2i(coords.x, coords.y + 1))
	tileMap.erase_cell(coords)

func setCell(tileMap: TileMapLayer, coords: Vector2i) -> void:
	var laserTile:LaserTile = LaserTile.new()
	if get_cell_source_id(coords) == -1 || tileMap.get_cell_source_id(coords) == 3 || tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == 3 || tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == 3 || tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == 3 || tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == 3:
		return
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == 2:
		laserTile.modifySelfCell(LaserTile.state.noDot, LaserTile.direction.top)
		tileMap.set_cell(Vector2i(coords.x, coords.y - 1), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x, coords.y - 1))), LaserTile.state.noDot, LaserTile.direction.bottom)))
	if tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == 2:
		laserTile.modifySelfCell(LaserTile.state.noDot, LaserTile.direction.right)
		tileMap.set_cell(Vector2i(coords.x + 1, coords.y), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x + 1, coords.y))), LaserTile.state.noDot, LaserTile.direction.left)))
	if tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == 2:
		laserTile.modifySelfCell(LaserTile.state.noDot, LaserTile.direction.left)
		tileMap.set_cell(Vector2i(coords.x - 1, coords.y), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x - 1, coords.y))), LaserTile.state.noDot, LaserTile.direction.right)))
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == 2:
		laserTile.modifySelfCell(LaserTile.state.noDot, LaserTile.direction.bottom)
		tileMap.set_cell(Vector2i(coords.x, coords.y + 1), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x, coords.y + 1))), LaserTile.state.noDot, LaserTile.direction.top)))
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 2)) == 3:
		laserTile.modifySelfCell(LaserTile.state.withDot, LaserTile.direction.top)
	if tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y)) == 3:
		laserTile.modifySelfCell(LaserTile.state.withDot, LaserTile.direction.right)
	if tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y)) == 3:
		laserTile.modifySelfCell(LaserTile.state.withDot, LaserTile.direction.left)
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 2)) == 3:
		laserTile.modifySelfCell(LaserTile.state.withDot, LaserTile.direction.bottom)
	tileMap.set_cell(coords, 2, laserTile.getVector2i())

func dotCell(tileMap: TileMapLayer, coords: Vector2i) -> void:
	if get_cell_source_id(coords) == -1 ||\
	 get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == -1 ||\
	 get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == -1 ||\
	 get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == -1 ||\
	 get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == -1 ||\
	 (tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y - 1)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y + 1)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y - 2)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y - 1)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y + 1)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x - 1, coords.y + 2)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 2)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == 3 ||\
	 tileMap.get_cell_source_id(coords) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 2)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y - 2)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y - 1)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y + 1)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 1, coords.y + 2)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y - 1)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y)) == 3 ||\
	 tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y + 1)) == 3):
		return
	eraseCell(tileMap, Vector2i(coords.x, coords.y - 1))
	eraseCell(tileMap, Vector2i(coords.x + 1, coords.y))
	eraseCell(tileMap, Vector2i(coords.x - 1, coords.y))
	eraseCell(tileMap, Vector2i(coords.x, coords.y + 1))
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y - 2)) == 2:
		tileMap.set_cell(Vector2i(coords.x, coords.y - 2), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x, coords.y - 2))), LaserTile.state.withDot, LaserTile.direction.bottom)))
	if tileMap.get_cell_source_id(Vector2i(coords.x + 2, coords.y)) == 2:
		tileMap.set_cell(Vector2i(coords.x + 2, coords.y), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x + 2, coords.y))), LaserTile.state.withDot, LaserTile.direction.left)))
	if tileMap.get_cell_source_id(Vector2i(coords.x - 2, coords.y)) == 2:
		tileMap.set_cell(Vector2i(coords.x - 2, coords.y), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x - 2, coords.y))), LaserTile.state.withDot, LaserTile.direction.right)))
	if tileMap.get_cell_source_id(Vector2i(coords.x, coords.y + 2)) == 2: 
		tileMap.set_cell(Vector2i(coords.x, coords.y + 2), 2, LaserTile.laserTileToAtlas(LaserTile.modifyCell(LaserTile.atlasToLaserTile(tileMap.get_cell_atlas_coords(Vector2i(coords.x, coords.y + 2))), LaserTile.state.withDot, LaserTile.direction.top)))
	tileMap.set_cell(coords, 3, LaserTile.dotAtlasCoords)

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
