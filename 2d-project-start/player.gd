extends CharacterBody2D

signal speed_increase
signal health_depleted
var health = 100.0
var xp = 0
var regen = 0.0
var damage_rate = 5.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	if velocity.length() > 0.0:
		$HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()
	health += regen * delta
	if health > 100.0:
		health = 100.0
	%HealthBar.value = health
	var overlapping_enemies = %Hurtbox.get_overlapping_bodies()
	if overlapping_enemies.size() > 0:
		health -= damage_rate * overlapping_enemies.size() * delta
		%HealthBar.value = health
		if health <= 0.0:
			health_depleted.emit()

func _on_game_kill(xpValue: Variant) -> void:
	xp += xpValue
	%XPBar.value = xp
	if xp >= 100:
		xp = 0
		%XPBar.value = xp
		get_tree().paused = true
		levelUp()

func levelUp():
	%LevelMenu.visible = true
	while %LevelMenu.visible == true:
		if Input.is_key_pressed(KEY_1):
			damage_rate -= .5
			if damage_rate < 0:
				damage_rate = 0
			%LevelMenu.visible = false
			get_tree().paused = false
		if Input.is_key_pressed(KEY_2):
			regen += 1
			%LevelMenu.visible = false
			get_tree().paused = false
		if Input.is_key_pressed(KEY_3):
			speed_increase.emit()
			%LevelMenu.visible = false
			get_tree().paused = false
		await get_tree().create_timer(0.01).timeout
