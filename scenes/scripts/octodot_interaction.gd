extends TileMapLayer

# 0 = no dot
# 1 = half covered
# 2 = fully covered
var hasdot:int = 0
#preset tile locations
var dotTile:Vector2i = Vector2i(0, 0)

var leftClicking:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event.as_text().contains("Left Mouse Button"):
		if leftClicking:
			leftClicking = !leftClicking
			var canBePlaced = true
			var mapPos:Vector2i = local_to_map(to_local(get_global_mouse_position()))
			var checkPos:Vector2i
			if get_cell_source_id(mapPos) > -1:
				set_cell(mapPos,-1)
				$"../LaserTiles".clear()
				$"../LaserTiles".lazerLetter = "a"
				$"../../logText".text = ""
			elif $"../BoardTiles".get_cell_source_id(Vector2i(mapPos.x + 1, mapPos.y)) == 1 && $"../BoardTiles".get_cell_source_id(Vector2i(mapPos.x - 1, mapPos.y)) == 1 && $"../BoardTiles".get_cell_source_id(Vector2i(mapPos.x, mapPos.y + 1)) == 1 && $"../BoardTiles".get_cell_source_id( Vector2i(mapPos.x, mapPos.y - 1)) == 1:
				for n1 in range(-2, 3):
					for n2 in range(-2, 3):
						if abs(n1) == 2 && abs(n2) == 2:
							continue
						checkPos.x = mapPos.x + n1
						checkPos.y = mapPos.y + n2
						if get_cell_source_id(checkPos) > -1:
							canBePlaced = false
							break
					if !canBePlaced:
						break
				if canBePlaced:
					set_cell(local_to_map(to_local(get_global_mouse_position())),1, dotTile)
					$"../LaserTiles".clear()
					$"../LaserTiles".lazerLetter = "a"
					$"../../logText".text = ""
		else:
			leftClicking = !leftClicking
