extends Area2D
var screensize = Vector2.ZERO
var can_hurt = false


func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player") and (not can_hurt)) or area.is_in_group("obstacles"):
		position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
