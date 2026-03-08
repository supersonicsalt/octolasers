extends ColorRect

var lines = []
var newLines = []

func _draw():
	lines.append(Vector2(320, $"../".delay * $"../HSlider2".value / $"../HSlider".value))
	var lastLine = Vector2(-1, 0)
	for line in lines:
		if line.x >= 0:
			draw_line(lastLine, line, Color("00ff00"), 1, false)
			newLines.append(Vector2(line.x - $"../".delay, line.y))
			lastLine = line
	lines = newLines
	newLines = []
