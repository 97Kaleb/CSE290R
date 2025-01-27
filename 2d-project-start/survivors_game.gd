extends Node2D

signal kill(xpValue)

func spawn_enemy():
	var new_enemy = preload("res://enemy.tscn").instantiate()
	new_enemy.connect("defeated", _on_enemy_defeated)
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	add_child(new_enemy)

func _on_timer_timeout() -> void:
	spawn_enemy()

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true


func _on_enemy_defeated(xpValue: Variant) -> void:
	emit_signal("kill", xpValue)
