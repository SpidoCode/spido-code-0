extends VBoxContainer

const PrimaryButton = preload("res://scripts/primary_button.gd")

var selector: OptionButton
var _modo_activo: Label
var _ultimo_modo_mostrado := -1


func _ready() -> void:
	add_theme_constant_override("separation", 8)
	var titulo := Label.new()
	titulo.text = "PANTALLA"
	titulo.add_theme_font_size_override("font_size", 18)
	add_child(titulo)

	_modo_activo = Label.new()
	add_child(_modo_activo)

	var fila := HBoxContainer.new()
	fila.add_theme_constant_override("separation", 12)
	add_child(fila)

	selector = OptionButton.new()
	selector.accessibility_name = "Modo de visualización"
	selector.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	selector.add_item("Modo ventana", DisplayServer.WINDOW_MODE_WINDOWED)
	selector.add_item("Ventana maximizada", DisplayServer.WINDOW_MODE_MAXIMIZED)
	selector.add_item("Pantalla completa", DisplayServer.WINDOW_MODE_FULLSCREEN)
	fila.add_child(selector)

	var aplicar := PrimaryButton.new()
	aplicar.text = "APLICAR"
	aplicar.pressed.connect(_aplicar)
	fila.add_child(aplicar)
	_estilizar_selector.call_deferred(aplicar)

	var atajos := Label.new()
	atajos.text = "F11 o Alt+Enter · Alternar pantalla completa"
	atajos.add_theme_font_size_override("font_size", 13)
	add_child(atajos)
	_sincronizar()


func _estilizar_selector(aplicar: Button) -> void:
	var normal := aplicar.get_theme_stylebox("normal") as StyleBoxFlat
	for estado in ["normal", "hover", "disabled"]:
		selector.add_theme_stylebox_override(estado, aplicar.get_theme_stylebox(estado))
	selector.add_theme_font_override("font", aplicar.get_theme_font("font"))
	selector.add_theme_font_size_override("font_size", aplicar.get_theme_font_size("font_size"))
	selector.add_theme_color_override("font_shadow_color", aplicar.get_theme_color("font_shadow_color"))
	selector.add_theme_constant_override("shadow_offset_y", aplicar.get_theme_constant("shadow_offset_y"))
	selector.add_theme_constant_override("outline_size", 0)
	selector.add_theme_constant_override("arrow_margin", 14)
	selector.add_theme_constant_override("modulate_arrow", 0)

	var seleccionado := normal.duplicate() as StyleBoxFlat
	var estilo_pulsado := aplicar.get_theme_stylebox("pressed") as StyleBoxFlat
	seleccionado.bg_color = estilo_pulsado.bg_color
	seleccionado.border_color = estilo_pulsado.border_color
	var pulsado := estilo_pulsado.duplicate() as StyleBoxFlat
	pulsado.shadow_color = normal.shadow_color
	pulsado.shadow_size = normal.shadow_size
	pulsado.shadow_offset = normal.shadow_offset - Vector2(0, 3)
	_estilo_pulsado(seleccionado)
	selector.button_down.connect(_estilo_pulsado.bind(pulsado))
	selector.button_up.connect(_estilo_pulsado.bind(seleccionado))

	var foco := normal.duplicate() as StyleBoxFlat
	foco.draw_center = false
	foco.shadow_size = 0
	foco.set_border_width_all(2)
	foco.border_color = Color("#304E39")
	selector.add_theme_stylebox_override("focus", foco)

	var flecha := Image.create(16, 9, false, Image.FORMAT_RGBA8)
	for paso in range(7):
		for grosor in range(3):
			flecha.set_pixel(1 + paso, paso + grosor, Color("#304E39"))
			flecha.set_pixel(14 - paso, paso + grosor, Color("#304E39"))
	selector.add_theme_icon_override("arrow", ImageTexture.create_from_image(flecha))
	PrimaryButton.apply(selector)
	_estilizar_popup()


func _estilo_pulsado(estilo: StyleBoxFlat) -> void:
	selector.add_theme_stylebox_override("pressed", estilo)
	selector.add_theme_stylebox_override("hover_pressed", estilo)


func _estilizar_popup() -> void:
	var tema := Theme.new()
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color("#303640")
	panel.border_color = Color("#596372")
	panel.set_border_width_all(2)
	panel.set_corner_radius_all(12)
	for lado in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		panel.set_content_margin(lado, 10)
	tema.set_stylebox("panel", "PopupMenu", panel)

	var hover := panel.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#40594A")
	hover.border_color = Color("#80BC87")
	hover.set_corner_radius_all(8)
	tema.set_stylebox("hover", "PopupMenu", hover)
	tema.set_font("font", "PopupMenu", selector.get_theme_font("font"))
	tema.set_font_size("font_size", "PopupMenu", selector.get_theme_font_size("font_size"))
	tema.set_color("font_color", "PopupMenu", Color.WHITE)
	tema.set_color("font_hover_color", "PopupMenu", Color.WHITE)
	tema.set_constant("v_separation", "PopupMenu", 10)
	selector.get_popup().theme = tema


func _process(_delta: float) -> void:
	_sincronizar()


func _sincronizar() -> void:
	var modo := DisplaySettings.modo_activo()
	if modo == _ultimo_modo_mostrado:
		return
	var indice := selector.get_item_index(modo)
	if indice >= 0:
		selector.select(indice)
		_modo_activo.text = "Modo activo: " + selector.get_item_text(indice)
	_ultimo_modo_mostrado = modo


func _aplicar() -> void:
	if DisplaySettings.aplicar(selector.get_selected_id()) != OK:
		_modo_activo.text = "No se pudo guardar la preferencia de pantalla."
		_ultimo_modo_mostrado = DisplaySettings.modo_activo()
	else:
		_ultimo_modo_mostrado = -1
		_sincronizar()
