extends Node

class LaserTile:
	enum direction {
		error = -1,
		top = 0,
		right = 1,
		bottom = 2,
		left = 3,
	}
	enum state {
		error = -1,
		none = 0,
		noDot = 1,
		withDot = 2,
	}
	enum variation {
		noteGuess = 0,
		lazer = 1,
		note = 2,
		octodot = 3,
		newFormat = 4,
		noteCropped = 5
	}
	
	const dotAtlasCoords = Vector2i(3, 0)
	const arrowAtlasCoords = [Vector2i(9, 0), Vector2i(9, 1), Vector2i(9, 2), Vector2i(9, 3)]
	const facesAtlasCoords = {
		smiley = Vector2i(9, 4),
		colon3 = Vector2i(9, 5),
		silly3 = Vector2i(9, 6),
		unsure = Vector2i(9, 7),
		upsideDown = Vector2i(9, 8)
	}

	var top: state
	var right: state
	var left: state
	var bottom: state
	var variant: variation

	func _init(inpVariant:variation, inpTop:state = state.none, inpRight:state = state.none, inpLeft:state = state.none, inpBottom:state = state.none):
		variant = inpVariant
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

	static func arrowAtlasToDirection(atlasCoords:Vector2i) -> direction:
		if atlasCoords.x != 9 and atlasCoords.y >= 0 and atlasCoords.y <= 3:
			assert(false, str("not an arrow atlas coord: recieved (", atlasCoords.x, ", ", atlasCoords.y, ") but expected (9, 0 <= y <= 3)"))
			return direction.error
		return atlasCoords.y as direction

	static func atlasToLaserTile(source:variation, atlasCoords:Vector2i) -> LaserTile:
		@warning_ignore("integer_division")
		return LaserTile.new(source, atlasCoords.x % 3, atlasCoords.x / 3, atlasCoords.y % 3, atlasCoords.y / 3)
		
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
			return LaserTile.new(laserTile.variant, -1 as state, -1 as state, -1 as state, -1 as state)
		laserTile.top = (laserTile.top % 3) as state
		laserTile.right = (laserTile.right % 3) as state
		laserTile.left = (laserTile.left % 3) as state
		laserTile.bottom = (laserTile.bottom % 3) as state
		return laserTile

	static func modifyAtlasCell(source:variation, tile:Vector2i, location:direction, newValue:state) -> Vector2i:
		return laserTileToAtlas(modifyCell(atlasToLaserTile(source, tile), newValue, location))
	
	static func flipDirection(location:direction) -> direction:
		if location == direction.error:
			return direction.error
		return (location + 2) % 4 as direction
	
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
