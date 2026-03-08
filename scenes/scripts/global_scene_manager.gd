##manning the scene
class_name SceneMan
extends Node
static var sceneHistory:Array[NodePath]
static var currentTree:SceneTree
const NAME_TO_SCENE: Dictionary[String, String] = {
	"puzzleMenu" = "res://scenes/puzzleMenu.tscn"
}
func _ready() -> void:
	currentTree = get_tree() 

static func exit() -> void:
	if sceneHistory.back() == null: #if no previous scene&comma exit game
		currentTree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		currentTree.quit(0)
		return
	currentTree.change_scene_to_file(sceneHistory.pop_back())

static func changeScene(newSceneName:String) -> void:
	if newSceneName == "exit":
		exit()
		return
	var newScene:String = NAME_TO_SCENE[newSceneName]
	currentTree.change_scene_to_file(newScene)
	sceneHistory.append(newScene)
