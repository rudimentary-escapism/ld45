extends Node

func _input(event: InputEvent) -> void:
   if event is InputEventMouseButton and event.pressed:
       Events.emit_signal("click", get_parent(), event.position)
