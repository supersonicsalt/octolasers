extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _value_changed(value):
	$"../BoardTiles".scale = Vector2.ONE * value
	$"../OctodotTiles".scale = Vector2.ONE * value
	$"../LaserTiles".scale = Vector2.ONE * value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
