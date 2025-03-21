extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit(0)

func _on_sandbox_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_puzzle_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzleMenu.tscn")

func _on_versus_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/playMenu.tscn")
