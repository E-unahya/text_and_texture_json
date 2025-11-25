@tool
extends Control

## ファイルダイアログくん
@onready var open_json_dialog = get_node("OpenJsonDialog")
@onready var select_texture_dialog = get_node("SelectTextureDialog")
@onready var save_json_dialog = get_node("SaveJsonDialog")

## コンテナー内部の各種UIくん
@onready var icon = get_node("VBoxContainer/IconTexture")
@onready var select_texture_button = get_node("VBoxContainer/SelectTextureButton")
@onready var text_edit = get_node("VBoxContainer/TextEdit")
@onready var open_json_button = get_node("VBoxContainer/OpenJsonButton")
@onready var save_button = get_node("VBoxContainer/SaveButton")

## プレビューのためのポップアップくん
@onready var preview_pop_up = get_node("PreviewPopUp")

## メッセージたちの格納庫
var messages : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon.texture = null

func _on_select_texture_button_pressed() -> void:
	select_texture_dialog.visible = true

func _on_select_json_button_pressed() -> void:
	open_json_dialog.visible = true

func _on_save_button_pressed() -> void:
	save_json_dialog.visible = true

func _on_select_texture_dialog_file_selected(path: String) -> void:
	# 大前提とし画像ファイルが読み込まれていること、
	icon.texture = load(path)

# TODO 読み込んだファイルの中身を何らかの方法で見せる。
func _on_open_json_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		printerr("Failed to load messages")
		return
	var json = JSON.parse_string(file.get_as_text())
	if type_string(( typeof(json) )) == "Array":
		messages = json 
	else:
		printerr("In Json file doees not 適切")
		return
	file.close()
	preview_update()

# TODO 追加したことを知らせる。
func _on_add_button_pressed() -> void:
	if icon.texture == null:
		printerr("アイコンねぇぞ")
		return
	messages.append({
		# "texture": ResourceLoader.get_resource_uid( icon.texture.resource_path ),
		# ほんとはUIDで保存したいけどなんかうまくいかんのでパスで
		"texture": icon.texture.resource_path ,
		"text": text_edit.text
	})
	icon.texture = null
	text_edit.text = ""
	preview_update()

func _on_preview_button_pressed() -> void:
	preview_update()
	preview_pop_up.visible = true

func _on_save_json_dialog_file_selected(path:String) -> void:
	# 上書きは許しまへんで
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json = JSON.stringify(messages, "\t")
	print(json)
	file.store_string(json)
	file.close()
	messages.clear()

func preview_update() -> void:
	var vbox : VBoxContainer = preview_pop_up.get_node("VBoxContainer")
	for p in vbox.get_children():
		p.queue_free()
	for m in messages:
		var tt_container = preload("res://addons/novellikesystem/tt_container.tscn").instantiate()
		tt_container.get_node("TextureRect").texture = load(m["texture"])
		tt_container.get_node("Label").text = m["text"]
		vbox.add_child(tt_container)

