extends Area2D

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var targeted_enemy = enemies_in_range[0]
		look_at(targeted_enemy.global_position)

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %Barrel.global_position
	new_bullet.global_rotation = %Barrel.global_rotation
	%Barrel.add_child(new_bullet)

func _on_timer_timeout() -> void:
	shoot()

func _on_player_speed_increase() -> void:
	%Timer.wait_time -= .05
	if %Timer.wait_time <= 0.0:
		%Timer.wait_time = .1
