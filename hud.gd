extends CanvasLayer
signal start_game


func update_score(value) -> void:
	$MarginContainer/Score.text = str(value)


func update_timer(value) -> void:
	$MarginContainer/Time.text = str(value)


func show_message(text) -> void:
	$Message.text = text
	$Message.show()
	$Timer.start()


func _on_timer_timeout() -> void:
	$Message.hide()


func _on_start_button_pressed() -> void:
	$Message.text = "Loading..."
	start_game.emit()


func show_game_over() -> void:
	show_message("Game Over")
	await $Timer.timeout
	begin_screen()


func begin_screen() -> void:
	$StartButton.show()
	$Message.text = "Coin Dash!"
	$Message.show()
