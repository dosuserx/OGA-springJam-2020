extends CanvasLayer

func _ready():
	pass


func _on_startBtn_pressed():
	get_tree().change_scene("res://scenes/worldstart.tscn")


func _on_quitBtn_pressed():
	get_tree().quit()
