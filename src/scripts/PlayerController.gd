extends Node2D

func _input(event: InputEvent) -> void:
   if event is InputEventMouseButton:
       Events.emit_signal("move", get_parent(), event.position)
