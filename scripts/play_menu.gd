extends Node2D

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_sandbox_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")

func _on_notation_sandbox_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/notationSandbox.tscn")

func _on_couch_device_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/deviceCouch.tscn")
