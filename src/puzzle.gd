extends Node2D


var dragging := false
var dragging_ang := 0.0


@onready var outside: Node2D = $Outside
@onready var outer_pieces: Array[Node2D] = [$Outside/Piece1, $Outside/Piece2, $Outside/Piece3, $Outside/Piece4, $Outside/Piece5, $Outside/Piece6]
@onready var inner_pieces: Array[Node2D] = [$Inside/InnerButton1, $Inside/InnerButton2]


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var me: InputEventMouseButton = event
		if me.button_index != MOUSE_BUTTON_LEFT:
			return
		if me.is_pressed():
			dragging = true
			dragging_ang = calc_mouse_angle()
			get_viewport().set_input_as_handled()
		elif dragging:
			dragging = false
			outside.rotation = 0
			get_viewport().set_input_as_handled()

			# Rotate pieces by the closest amount
			var ang := calc_mouse_angle()
			var offset := floori(wrapf(ang - dragging_ang + (TAU / 12.0), 0.0, TAU) * 6.0 / TAU)
			for _i in range(offset):
				outer_pieces.push_front(outer_pieces.pop_back())
			rotate_pieces()


func calc_mouse_angle() -> float:
	var mouse_pos := get_local_mouse_position()
	return atan2(mouse_pos.y, mouse_pos.x)


func rotate_pieces() -> void:
	for i in range(6):
		outer_pieces[i].rotation_degrees = -150 + 60 * i


func color_stickers() -> void:
	for piece in outer_pieces:
		piece.color_stickers()
	for piece in inner_pieces:
		piece.color_sticker()


func _process(_delta: float) -> void:
	if dragging:
		var ang := calc_mouse_angle()
		var offset := ang - dragging_ang
		outside.rotation = offset


func flip_right() -> void:
	inner_pieces[0].flip_internal()
	outer_pieces[0].flip_internal()
	outer_pieces[1].flip_internal()
	outer_pieces[2].flip_internal()
	var temp = outer_pieces[0]
	outer_pieces[0] = outer_pieces[2]
	outer_pieces[2] = temp


func flip_left() -> void:
	inner_pieces[1].flip_internal()
	outer_pieces[3].flip_internal()
	outer_pieces[4].flip_internal()
	outer_pieces[5].flip_internal()
	var temp = outer_pieces[3]
	outer_pieces[3] = outer_pieces[5]
	outer_pieces[5] = temp


func _on_inner_1_pressed() -> void:
	flip_right()
	rotate_pieces()
	color_stickers()


func _on_inner_2_pressed() -> void:
	flip_left()
	rotate_pieces()
	color_stickers()


func _on_shuffle_button_pressed() -> void:
	# lmao
	var shuffle_count := randi_range(80, 120)
	for _i in range(shuffle_count):
		var turn := randi_range(1, 2)
		for _j in range(turn):
			outer_pieces.push_front(outer_pieces.pop_back())
		flip_right()
	if randi_range(0, 1) == 1:
		flip_left()
		flip_right()
	color_stickers()
	rotate_pieces()
