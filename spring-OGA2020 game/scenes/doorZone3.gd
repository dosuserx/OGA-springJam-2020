extends Area2D

onready var doorTimer = $doorTimer

func _ready():
	pass


func _on_doorZone1_body_entered(body):
	print(body)
	doorTimer.start()




func _on_doorTimer_timeout():
	get_tree().change_scene("res://scenes/world1.tscn")

