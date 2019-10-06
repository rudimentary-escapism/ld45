extends CanvasLayer

func _ready():
    if Events.connect("unit_activated", self, "_on_unit_activated"):
        print("Cannot see active unit")
    

func _on_unit_activated(pawn: Pawn):
    $ActivUnit.text = pawn.name


func _on_EndTurnButton_pressed():
    Events.emit_signal("end_button_pressed")

