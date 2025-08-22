extends AudioStreamPlayer

const PISTOL_COCK_6014 = preload("res://sfx/pistol-cock-6014.mp3")
 
func play_pistol_ready_sound() -> void:
	stream = PISTOL_COCK_6014
	volume_db = -7
	play()
