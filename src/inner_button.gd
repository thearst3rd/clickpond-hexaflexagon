@tool
extends Node2D


signal inner_pressed


@export var inner_index: int = 0


@onready var sticker: Polygon2D = $Sticker
@onready var highlight: Polygon2D = $Highlight
@onready var colors: Node = $Colors


func _ready() -> void:
	color_sticker()


func _process(_delta: float) -> void:
	highlight.visible = mouse_inside()


func flip_internal() -> void:
	inner_index = 0 if inner_index == 1 else 1


func color_sticker() -> void:
	sticker.color = colors.get_inner_color(inner_index)


# Can I do something fancy with the area2d and not have to do this manually?
func mouse_inside() -> bool:
	var pos := get_local_mouse_position()
	if pos.x < 0:
		return false
	if pos.x > 45.0333:
		return false
	var sloped_x := 26 * pos.x / 45.0333
	if pos.y + sloped_x > 52:
		return false
	if pos.y - sloped_x < -52:
		return false
	return true


func _input(event: InputEvent) -> void:
	if not mouse_inside():
		return

	if event is InputEventMouseButton:
		var me: InputEventMouseButton = event
		if me.is_pressed() and me.button_index == MOUSE_BUTTON_LEFT:
			_on_pressed()
			get_viewport().set_input_as_handled()


func _on_pressed() -> void:
	inner_pressed.emit()
