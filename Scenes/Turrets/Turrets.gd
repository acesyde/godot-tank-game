class_name Turrets
extends Node2D

onready var turret: Sprite = $Turret
onready var range_collisionshape2d: CollisionShape2D = $Range/CollisionShape2D

var enemy_array: Array = []
var built: bool = false
var enemy: Node2D

func _ready() -> void:
	if built:
		range_collisionshape2d.get_shape().radius = 0.5 * GameData.tower_data[self.get_name()]["range"]

func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
	else:
		enemy = null
	
func turn() -> void:
	turret.look_at(enemy.position)
	
func select_enemy() -> void:
	var enemy_progress_array: Array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func _on_Range_body_entered(body: Node) -> void:
	enemy_array.append(body.get_parent())

func _on_Range_body_exited(body: Node) -> void:
	enemy_array.erase(body.get_parent())
