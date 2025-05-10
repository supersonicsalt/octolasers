extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"heightText".text = tr("HEIGHT")
	$"widthText".text = tr("WIDTH")
	$"heightInput".tooltip_text = tr("HEIGHT")
	$"widthInput".tooltip_text = tr("WIDTH")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sandboxMenu.tscn")
