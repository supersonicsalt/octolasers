extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"heightText".text = tr("HEIGHT")
	$"widthText".text = tr("WIDTH")
	$"heightInput".tooltip_text = tr("HEIGHT")
	$"widthInput".tooltip_text = tr("WIDTH")

var showPing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_toggled(toggled_on: bool) -> void:
	showPing = toggled_on


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
