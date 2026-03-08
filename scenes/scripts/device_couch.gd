extends Node2D

func _on_exit_pressed() -> void:
	SceneMan.exit()

@export var button_to_scene: Dictionary[TextureButton, String]
func _ready() -> void:
	for button in button_to_scene.keys():
		button.pressed.connect(func(): SceneMan.changeScene(button_to_scene[button]))
