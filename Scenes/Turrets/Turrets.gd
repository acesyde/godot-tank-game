extends Node2D

onready var turret: Sprite = $Turret

func _physics_process(delta: float) -> void:
	turn()
	pass
	
func turn() -> void:
	var enemy_position: Vector2 = get_global_mouse_position()
	turret.look_at(enemy_position)
