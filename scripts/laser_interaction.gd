extends TileMapLayer

var lmbPressed = false

func entranceToText(laserEntrance):
	if $"../BoardTiles".get_cell_atlas_coords(laserEntrance).y == 1:
		return(str(laserEntrance.y) + tr("LEFT"))
	if $"../BoardTiles".get_cell_atlas_coords(laserEntrance).y == 3:
		return(str(laserEntrance.y) + tr("RIGHT"))
	if $"../BoardTiles".get_cell_atlas_coords(laserEntrance).y == 2:
		return(str(laserEntrance.x ) + tr("UP"))
	if $"../BoardTiles".get_cell_atlas_coords(laserEntrance).y == 0:
		return(str(laserEntrance.x) + tr("DOWN"))
	return "-1"

func _input(event):
	if event.as_text().contains("Left Mouse Button") && $"../BoardTiles".get_cell_source_id(local_to_map(to_local(get_global_mouse_position()))) == 0:
		if !lmbPressed:
			var laserStart = local_to_map(to_local(get_global_mouse_position()))
			var direction:int = -1
			if $"../BoardTiles".get_cell_atlas_coords(laserStart).y == 1:
				direction = 0
			elif $"../BoardTiles".get_cell_atlas_coords(laserStart).y == 3:
				direction = 1
			elif $"../BoardTiles".get_cell_atlas_coords(laserStart).y == 2:
				direction = 2
			elif $"../BoardTiles".get_cell_atlas_coords(laserStart).y == 0:
				direction = 3
			var laserExit = drawLaser(laserStart, direction)
			var startText = entranceToText(laserStart)
			var exitText = entranceToText(laserExit)
			if exitText == "-1":
				exitText = startText
			if !$"../../logText".text.contains(startText + "-" + exitText) && !$"../../logText".text.contains(exitText + "-" + startText):
				$"../../logText".text = $"../../logText".text + lazerLetter + startText + "-" + exitText + "\n"
				$"../../logText".set_v_scroll($"../../logText".get_scroll_pos_for_line($"../../logText".get_line_count() - 1))
				lazerLetter = advanceLetter(lazerLetter)
		lmbPressed = !lmbPressed

var lazerLetter:String = "a"

func advanceLetter(letter:String):
	if letter.ends_with("Z"):
		if letter.erase(letter.length() - 1, 1) == "":
			letter = "AA"
		else:
			letter = advanceLetter(letter.erase(letter.length() - 1, 1)) + "A"
	elif letter.ends_with("z"):
		if letter.erase(letter.length() - 1, 1) == "":
			letter = "aa"
		else:
			letter = advanceLetter(letter.erase(letter.length() - 1, 1)) + "a"
	else:
		letter = letter.erase(letter.length() - 1, 1) + String.chr(letter.unicode_at(letter.length() - 1) + 1)
	return letter

func drawLaser(start:Vector2i, direction):
	if direction == 0:
		start.x += 1
	elif direction == 1:
		start.x -= 1
	elif direction == 2:
		start.y += 1
	elif direction == 3:
		start.y -= 1
	var inProgress = direction != -1
	if direction == 0:
		if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x + 1, start.y)) == 1:
			inProgress = false
	elif direction == 1:
		if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x - 1, start.y)) == 1:
			inProgress = false
	elif direction == 2:
		if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x, start.y + 1)) == 1:
			inProgress = false
	elif direction == 3:
		if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x, start.y - 1)) == 1:
			inProgress = false
	while  inProgress:
		if direction == 0:
			if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x + 1, start.y + 1)) == 1:
				direction = 3
				if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x, start.y - 2)) == 1:
					if get_cell_atlas_coords(start) != Vector2i(5, 0):
						set_cell(start, 1, Vector2i(5, 0))
					else:
						set_cell(start)
					inProgress = false
				else:
					if get_cell_atlas_coords(start) != Vector2i(4, 0):
						set_cell(start, 1, Vector2i(4, 0))
					else:
						set_cell(start)
				start.y -= 1
			elif $"../OctodotTiles".get_cell_source_id(Vector2i(start.x + 2, start.y)) == 1:
				if get_cell_atlas_coords(start) == Vector2i(0, 0) || get_cell_atlas_coords(start) == Vector2i(2, 1):
					if get_cell_atlas_coords(start) != Vector2i(2, 1):
						set_cell(start, 1, Vector2i(2, 1))
					else:
						set_cell(start, 1, Vector2i(0, 0))
				elif get_cell_atlas_coords(start) == Vector2i(1, 0) || get_cell_atlas_coords(start) == Vector2i(3, 1):
					if get_cell_atlas_coords(start) != Vector2i(3, 1):
						set_cell(start, 1, Vector2i(3, 1))
					else:
						set_cell(start, 1, Vector2i(1, 0))
				elif get_cell_atlas_coords(start) == Vector2i(1, 2) || get_cell_atlas_coords(start) == Vector2i(3, 2):
					if get_cell_atlas_coords(start) != Vector2i(3, 2):
						set_cell(start, 1, Vector2i(3, 2))
					else:
						set_cell(start, 1, Vector2i(1, 2))
				else:
					if get_cell_atlas_coords(start) != Vector2i(1, 1):
						set_cell(start, 1, Vector2i(1, 1))
					else:
						set_cell(start)
				inProgress = false
			elif $"../OctodotTiles".get_cell_source_id(Vector2i(start.x + 1, start.y - 1)) == 1:
				direction = 2
				if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x, start.y + 2)) == 1:
					if get_cell_atlas_coords(start) != Vector2i(6, 1):
						set_cell(start, 1, Vector2i(6, 1))
					else:
						set_cell(start)
					inProgress = false
				else:
					if get_cell_atlas_coords(start) != Vector2i(4, 1):
						set_cell(start, 1, Vector2i(4, 1))
					else:
						set_cell(start)
				start.y += 1
			else:
				if get_cell_atlas_coords(start) == Vector2i(0, 0) || get_cell_atlas_coords(start) == Vector2i(0, 2):
					if get_cell_atlas_coords(start) != Vector2i(0, 2):
						set_cell(start, 1, Vector2i(0, 2))
					else:
						set_cell(start, 1, Vector2i(0, 0))
				elif get_cell_atlas_coords(start) == Vector2i(1, 0) || get_cell_atlas_coords(start) == Vector2i(2, 0):
					if get_cell_atlas_coords(start) != Vector2i(2, 0):
						set_cell(start, 1, Vector2i(2, 0))
					else:
						set_cell(start, 1, Vector2i(1, 0))
				elif get_cell_atlas_coords(start) == Vector2i(1, 2) || get_cell_atlas_coords(start) == Vector2i(2, 2):
					if get_cell_atlas_coords(start) != Vector2i(2, 2):
						set_cell(start, 1, Vector2i(2, 2))
					else:
						set_cell(start, 1, Vector2i(1, 2))
				else:
					if get_cell_atlas_coords(start) != Vector2i(0, 1):
						set_cell(start, 1, Vector2i(0, 1))
					else:
						set_cell(start)
				start.x += 1
		elif direction == 1:
			if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x - 1, start.y + 1)) == 1:
				direction = 3
				if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x, start.y - 2)) == 1:
					if get_cell_atlas_coords(start) != Vector2i(6, 3):
						set_cell(start, 1, Vector2i(6, 3))
					else:
						set_cell(start)
					inProgress = false
				else:
					if get_cell_atlas_coords(start) != Vector2i(4, 3):
						set_cell(start, 1, Vector2i(4, 3))
					else:
						set_cell(start)
				start.y -= 1
			elif $"../OctodotTiles".get_cell_source_id(Vector2i(start.x - 2, start.y)) == 1:
				if get_cell_atlas_coords(start) == Vector2i(0, 0) || get_cell_atlas_coords(start) == Vector2i(2, 3):
					if get_cell_atlas_coords(start) != Vector2i(2, 3):
						set_cell(start, 1, Vector2i(2, 3))
					else:
						set_cell(start, 1, Vector2i(0, 0))
				elif get_cell_atlas_coords(start) == Vector2i(1, 0) || get_cell_atlas_coords(start) == Vector2i(3, 0):
					if get_cell_atlas_coords(start) != Vector2i(3, 0):
						set_cell(start, 1, Vector2i(3, 0))
					else:
						set_cell(start, 1, Vector2i(1, 0))
				elif get_cell_atlas_coords(start) == Vector2i(1, 2) || get_cell_atlas_coords(start) == Vector2i(3, 3):
					if get_cell_atlas_coords(start) != Vector2i(3, 3):
						set_cell(start, 1, Vector2i(3, 3))
					else:
						set_cell(start, 1, Vector2i(1, 2))
				else:
					if get_cell_atlas_coords(start) != Vector2i(1, 3):
						set_cell(start, 1, Vector2i(1, 3))
					else:
						set_cell(start)
				inProgress = false
			elif $"../OctodotTiles".get_cell_source_id(Vector2i(start.x - 1, start.y - 1)) == 1:
				direction = 2
				if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x, start.y + 2)) == 1:
					if get_cell_atlas_coords(start) != Vector2i(5, 2):
						set_cell(start, 1, Vector2i(5, 2))
					else:
						set_cell(start)
					inProgress = false
				else:
					if get_cell_atlas_coords(start) != Vector2i(4, 2):
						set_cell(start, 1, Vector2i(4, 2))
					else:
						set_cell(start)
				start.y += 1
			else:
				if get_cell_atlas_coords(start) == Vector2i(0, 0) || get_cell_atlas_coords(start) == Vector2i(0, 2):
					if get_cell_atlas_coords(start) != Vector2i(0, 2):
						set_cell(start, 1, Vector2i(0, 2))
					else:
						set_cell(start, 1, Vector2i(0, 0))
				elif get_cell_atlas_coords(start) == Vector2i(1, 0) || get_cell_atlas_coords(start) == Vector2i(2, 0):
					if get_cell_atlas_coords(start) != Vector2i(2, 0):
						set_cell(start, 1, Vector2i(2, 0))
					else:
						set_cell(start, 1, Vector2i(1, 0))
				elif get_cell_atlas_coords(start) == Vector2i(1, 2) || get_cell_atlas_coords(start) == Vector2i(2, 2):
					if get_cell_atlas_coords(start) != Vector2i(2, 2):
						set_cell(start, 1, Vector2i(2, 2))
					else:
						set_cell(start, 1, Vector2i(1, 2))
				else:
					if get_cell_atlas_coords(start) != Vector2i(0, 1):
						set_cell(start, 1, Vector2i(0, 1))
					else:
						set_cell(start)
				start.x -= 1
		elif direction == 2:
			if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x + 1, start.y + 1)) == 1:
				direction = 1
				if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x - 2, start.y)) == 1:
					if get_cell_atlas_coords(start) != Vector2i(6, 0):
						set_cell(start, 1, Vector2i(6, 0))
					else:
						set_cell(start)
					inProgress = false
				else:
					if get_cell_atlas_coords(start) != Vector2i(4, 0):
						set_cell(start, 1, Vector2i(4, 0))
					else:
						set_cell(start)
				start.x -= 1
			elif $"../OctodotTiles".get_cell_source_id(Vector2i(start.x, start.y + 2)) == 1:
				if get_cell_atlas_coords(start) == Vector2i(0, 1) || get_cell_atlas_coords(start) == Vector2i(2, 2):
					if get_cell_atlas_coords(start) != Vector2i(2, 2):
						set_cell(start, 1, Vector2i(2, 2))
					else:
						set_cell(start, 1, Vector2i(0, 1))
				elif get_cell_atlas_coords(start) == Vector2i(1, 1) || get_cell_atlas_coords(start) == Vector2i(3, 2):
					if get_cell_atlas_coords(start) != Vector2i(3, 2):
						set_cell(start, 1, Vector2i(3, 2))
					else:
						set_cell(start, 1, Vector2i(1, 1))
				elif get_cell_atlas_coords(start) == Vector2i(1, 3) || get_cell_atlas_coords(start) == Vector2i(3, 3):
					if get_cell_atlas_coords(start) != Vector2i(3, 3):
						set_cell(start, 1, Vector2i(3, 3))
					else:
						set_cell(start, 1, Vector2i(1, 3))
				else:
					if get_cell_atlas_coords(start) != Vector2i(1, 2):
						set_cell(start, 1, Vector2i(1, 2))
					else:
						set_cell(start)
				inProgress = false
			elif $"../OctodotTiles".get_cell_source_id(Vector2i(start.x - 1, start.y + 1)) == 1:
				direction = 0
				if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x + 2, start.y)) == 1:
					if get_cell_atlas_coords(start) != Vector2i(5, 3):
						set_cell(start, 1, Vector2i(5, 3))
					else:
						set_cell(start)
					inProgress = false
				else:
					if get_cell_atlas_coords(start) != Vector2i(4, 3):
						set_cell(start, 1, Vector2i(4, 3))
					else:
						set_cell(start)
				start.x += 1
			else:
				if get_cell_atlas_coords(start) == Vector2i(0, 1) || get_cell_atlas_coords(start) == Vector2i(0, 2):
					if get_cell_atlas_coords(start) != Vector2i(0, 2):
						set_cell(start, 1, Vector2i(0, 2))
					else:
						set_cell(start, 1, Vector2i(0, 1))
				elif get_cell_atlas_coords(start) == Vector2i(1, 1) || get_cell_atlas_coords(start) == Vector2i(2, 1):
					if get_cell_atlas_coords(start) != Vector2i(2, 1):
						set_cell(start, 1, Vector2i(2, 1))
					else:
						set_cell(start, 1, Vector2i(1, 1))
				elif get_cell_atlas_coords(start) == Vector2i(1, 3) || get_cell_atlas_coords(start) == Vector2i(2, 3):
					if get_cell_atlas_coords(start) != Vector2i(2, 3):
						set_cell(start, 1, Vector2i(2, 3))
					else:
						set_cell(start, 1, Vector2i(1, 3))
				else:
					if get_cell_atlas_coords(start) != Vector2i(0, 0):
						set_cell(start, 1, Vector2i(0, 0))
					else:
						set_cell(start)
				start.y += 1
		elif direction == 3:
			if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x + 1, start.y - 1)) == 1:
				direction = 1
				if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x - 2, start.y)) == 1:
					if get_cell_atlas_coords(start) != Vector2i(5, 1):
						set_cell(start, 1, Vector2i(5, 1))
					else:
						set_cell(start)
					inProgress = false
				else:
					if get_cell_atlas_coords(start) != Vector2i(4, 1):
						set_cell(start, 1, Vector2i(4, 1))
					else:
						set_cell(start)
				start.x -= 1
			elif $"../OctodotTiles".get_cell_source_id(Vector2i(start.x, start.y - 2)) == 1:
				if get_cell_atlas_coords(start) == Vector2i(0, 1) || get_cell_atlas_coords(start) == Vector2i(2, 0):
					if get_cell_atlas_coords(start) != Vector2i(2, 0):
						set_cell(start, 1, Vector2i(2, 0))
					else:
						set_cell(start, 1, Vector2i(0, 1))
				elif get_cell_atlas_coords(start) == Vector2i(1, 1) || get_cell_atlas_coords(start) == Vector2i(3, 1):
					if get_cell_atlas_coords(start) != Vector2i(3, 1):
						set_cell(start, 1, Vector2i(3, 1))
					else:
						set_cell(start, 1, Vector2i(1, 1))
				elif get_cell_atlas_coords(start) == Vector2i(1, 3) || get_cell_atlas_coords(start) == Vector2i(3, 0):
					if get_cell_atlas_coords(start) != Vector2i(3, 0):
						set_cell(start, 1, Vector2i(3, 0))
					else:
						set_cell(start, 1, Vector2i(1, 3))
				else:
					if get_cell_atlas_coords(start) != Vector2i(1, 0):
						set_cell(start, 1, Vector2i(1, 0))
					else:
						set_cell(start)
				inProgress = false
			elif $"../OctodotTiles".get_cell_source_id(Vector2i(start.x - 1, start.y - 1)) == 1:
				direction = 0
				if $"../OctodotTiles".get_cell_source_id(Vector2i(start.x + 2, start.y)) == 1:
					if get_cell_atlas_coords(start) != Vector2i(6, 2):
						set_cell(start, 1, Vector2i(6, 2))
					else:
						set_cell(start)
					inProgress = false
				else:
					if get_cell_atlas_coords(start) != Vector2i(4, 2):
						set_cell(start, 1, Vector2i(4, 2))
					else:
						set_cell(start)
				start.x += 1
			else:
				if get_cell_atlas_coords(start) == Vector2i(0, 1) || get_cell_atlas_coords(start) == Vector2i(0, 2):
					if get_cell_atlas_coords(start) != Vector2i(0, 2):
						set_cell(start, 1, Vector2i(0, 2))
					else:
						set_cell(start, 1, Vector2i(0, 1))
				elif get_cell_atlas_coords(start) == Vector2i(1, 1) || get_cell_atlas_coords(start) == Vector2i(2, 1):
					if get_cell_atlas_coords(start) != Vector2i(2, 1):
						set_cell(start, 1, Vector2i(2, 1))
					else:
						set_cell(start, 1, Vector2i(1, 1))
				elif get_cell_atlas_coords(start) == Vector2i(1, 3) || get_cell_atlas_coords(start) == Vector2i(2, 3):
					if get_cell_atlas_coords(start) != Vector2i(2, 3):
						set_cell(start, 1, Vector2i(2, 3))
					else:
						set_cell(start, 1, Vector2i(1, 3))
				else:
					if get_cell_atlas_coords(start) != Vector2i(0, 0):
						set_cell(start, 1, Vector2i(0, 0))
					else:
						set_cell(start)
				start.y -= 1
		if $"../BoardTiles".get_cell_source_id(start) == 0:
			inProgress = false
	return	Vector2i(start.x, start.y)
