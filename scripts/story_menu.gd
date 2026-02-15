extends Node2D

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_text_edit_text_changed() -> void:
	if ($TextEdit.text == "octolock"):
		get_tree().change_scene_to_file("res://scenes/debug.tscn")
