extends Button

const TEXT_COLORS := [&"font_color", &"font_hover_color", &"font_pressed_color",
	&"font_hover_pressed_color", &"font_focus_color", &"font_disabled_color"]


func _ready() -> void:
	apply(self)


static func apply(button: Button) -> void:
	_update_cursor(button)
	button.draw.connect(_update_cursor.bind(button))
	# Icon buttons retain the native text layout around their icon.
	if button.icon != null or (not button is OptionButton and button.get_theme_icon(&"icon") != null):
		return
	# Keep the native text for sizing and accessibility, but draw its visible
	# glyphs with a shadow. Button's native theme only supports text outlines.
	var disabled_color := button.get_theme_color(&"font_disabled_color")
	for item in TEXT_COLORS:
		button.add_theme_color_override(item, Color.TRANSPARENT)
	button.draw.connect(_draw_text.bind(button, disabled_color))


static func _update_cursor(button: Button) -> void:
	var cursor := Control.CURSOR_ARROW if button.disabled else Control.CURSOR_POINTING_HAND
	if button.mouse_default_cursor_shape != cursor:
		button.mouse_default_cursor_shape = cursor


static func _draw_text(button: Button, disabled_color: Color) -> void:
	var state: StringName = &"normal"
	match button.get_draw_mode():
		BaseButton.DRAW_PRESSED, BaseButton.DRAW_HOVER_PRESSED:
			state = &"pressed"
		BaseButton.DRAW_HOVER:
			state = &"hover"
		BaseButton.DRAW_DISABLED:
			state = &"disabled"

	var box := button.get_theme_stylebox(state)
	var font := button.get_theme_font(&"font")
	var font_size := button.get_theme_font_size(&"font_size")
	var line := TextLine.new()
	line.add_string(button.tr(button.text), font, font_size)
	var content_size := button.size - box.get_minimum_size()
	var origin := box.get_offset() + (content_size - line.get_size()) * 0.5
	if button is OptionButton:
		origin.x = box.get_margin(SIDE_LEFT)
	if not button.disabled:
		var offset := button.get_theme_constant(&"shadow_offset_y")
		line.draw(button.get_canvas_item(), origin + Vector2(0, offset),
			button.get_theme_color(&"font_shadow_color"))
	line.draw(button.get_canvas_item(), origin, disabled_color if button.disabled else Color.WHITE)
