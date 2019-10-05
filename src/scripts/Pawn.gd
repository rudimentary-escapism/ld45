extends Node2D

onready var tween: Tween = $Tween


func move(path: Array) -> void:
    for point in path:
#        if steps == 0:
#            break
        step(point)
        yield(tween, "tween_all_completed")
#        set_steps(steps - 1)
#    is_action = false


func step(point: Vector2) -> void:
    if tween.interpolate_property(self, "position", position,
        point, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT) and tween.start():
        return
    position = point