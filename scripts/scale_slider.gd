extends HSlider

func _value_changed(new_value):
	$"../BoardTiles".scale = Vector2.ONE * new_value
	$"../OctodotTiles".scale = Vector2.ONE * new_value
	$"../LaserTiles".scale = Vector2.ONE * new_value
