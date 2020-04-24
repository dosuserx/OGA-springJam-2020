extends Area2D

onready var killTimer = $killTimer

func _ready():
	pass


func _on_kill_zone_body_entered(body):
	print ("killed") # Replace with function body.
	killTimer.start()



func _on_killTimer_timeout():
	get_tree().change_scene("res://scenes/menu.tscn") # Replace with function body.
