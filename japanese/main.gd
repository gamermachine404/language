extends Control

const TwoWayDict = preload("res://twowaydict.gd")
const ESCENE = preload("res://enemy.tscn")

static var hiragana_dict:TwoWayDict
static var katakana_dict:TwoWayDict
static var hiragana_dg_dict:TwoWayDict
static var katakana_dg_dict:TwoWayDict

static var dictionary_dictionary = {}
var counters = {}
var lists = {}
var pick
var lifetime:float
var interval:float

var stage = 0 #0: hiatus, 1: answering question, 2:done answering question, 3: special case
var ellapsed:float

var mistakes = 0
var he
var ke
var hed
var ked

static func getMatchingDict(nani:String):
	return dictionary_dictionary.get(nani)

func _ready():
	$StartButton.pressed.connect(startButtonPress)
	$ConfirmButton.pressed.connect(confirmPress)
	
	var dict_dir = DirAccess.open("res://dictionaries")
	var dicts = dict_dir.get_files()
	
	for i in dicts:
		var new_dict = TwoWayDict.new()
		new_dict.appendFromFile("res://dictionaries/" + i)
		var new_button = CheckBox.new()
		new_button.text = i.split(".txt")[0]
		dictionary_dictionary.set(i.split(".txt")[0], new_dict)
		$StartOptions.add_child(new_button)

func _process(delta):
	if Input.is_action_just_pressed("Confirm"):
		confirmPress()
	if stage == 0: return
	ellapsed += delta
	if ellapsed >= interval:
		var newenemy = load("res://enemy.tscn").instantiate()
		pick = counters.keys().pick_random()
		newenemy.find_child("Label").text = lists.get(pick)[counters.get(pick)]
		var tempsettings = LabelSettings.new()
		tempsettings.font_size = 23
		newenemy.find_child("Label").label_settings = tempsettings
		newenemy.lifetime = lifetime
		print("New enemy label: " + lists.get(pick)[counters.get(pick)])
		print(pick)
		newenemy.targettext = getMatchingDict(pick).getTwoFromOne(lists.get(pick)[counters.get(pick)])
		print("new enemy target text: " + getMatchingDict(pick).getTwoFromOne(lists.get(pick)[counters.get(pick)]))
		newenemy.position.x = randf_range(20, float(get_window().size.x) - 50)
		newenemy.position.y = randf_range(20, float(get_window().size.y) - 50)
		$Playground.add_child(newenemy)
		if counters.get(pick) == lists.get(pick).size() - 1:
			counters.set(pick, 0)
			lists.get(pick).shuffle()
		else:
			counters.set(pick, counters.get(pick) + 1)
		ellapsed = 0
	

func startButtonPress():
	var goodtogo = false
	for i:CheckBox in $StartOptions.get_children():
			if i.button_pressed:
				goodtogo = true
	if goodtogo:
		start()
	else:
		$DumbassLabel.visible = true

func next():
	stage = 0
	if counters.keys().is_empty():
		$Label.text = "Done!"
		if mistakes == 0:
			$SmartassLabel.text = "You made no mistakes!!"
			$SmartassLabel.visible = true
		else:
			$DumbassLabel.text = "You made " + mistakes.to_string() + " mistakes"
			$DumbassLabel.visible = true
		return
	pick = counters.keys().pick_random()
	$SmartassLabel.visible = false
	$DumbassLabel.visible = false
	if pick == "he" or pick == "ke":
		$Label.text = "what does the kana " + lists.get(pick).get(counters.get(pick)) + " sound like?"
	elif pick == "eh" or pick == "ek":
		$Label.text = "which kana has the sound " + lists.get(pick)[counters.get(pick)] + " associated?"
	stage = 1

func confirmPress():
	if stage == 0:
		return
	if stage == 2:
		next()
		return
	if $TextEdit.text == "":
		$DumbassLabel.text = "How about you write something first?"
		$DumbassLabel.visible = true
		return
		
	stage = 0
	
	if getMatchingDict(pick).getEitherOr(lists.get(pick)[counters.get(pick)]) == $TextEdit.text:
		$SmartassLabel.visible = true
	else:
		$DumbassLabel.text = "WRONG! It's actually " + getMatchingDict(pick).getEitherOr(lists.get(pick)[counters.get(pick)])
		$DumbassLabel.visible = true
		mistakes +=1
	counters.set(pick, counters.get(pick)+1)
	if counters.get(pick) == lists.get(pick).size():
		counters.erase(pick)
	stage = 2
	
func start():
	$StartOptions.visible = false
	$StartButton.visible = false
	$DumbassLabel.visible = false
	$Label.visible = false
	$Playground.visible = true
	#$ConfirmButton.visible = true
	#$TextEdit.visible = true
	
	for i:CheckBox in $StartOptions.get_children():
		if i.button_pressed:
			var questions = dictionary_dictionary.get(i.text).one.duplicate()
			questions.shuffle()
			counters.set(i.text, 0)
			lists.set(i.text, questions)
		
	$Label2.visible = false
	$TextEdit2.visible = false
	$Label3.visible = false
	$TextEdit3.visible = false
	interval = float($TextEdit3.text)
	lifetime = float($TextEdit2.text)
	print(lifetime)
	
	#var enemyscene = load("res://enemy.tscn")
	#var enemy:Node2D = enemyscene.instantiate()
	#add_child(enemy)
	#enemy.position.x = 500
	#enemy.position.y = 500
	
	$Playground.visible=true
	stage = 1
	
func start2():
	$StartOptions.visible = false
	$StartButton.visible = false
	$DumbassLabel.visible = false
	$ConfirmButton.visible = true
	$TextEdit.visible = true
	
	if $StartOptions/HE.button_pressed:
		he = hiragana_dict.one.duplicate()
		he.shuffle()
		counters.set("he", 0)
		lists.set("he", he)
	if $StartOptions/KE.button_pressed:
		ke = katakana_dict.one.duplicate()
		ke.shuffle()
		counters.set("ke", 0)
		lists.set("ke", ke)
	startGame()

func startGame():
	$Playground.visible=true
	stage = 1
	
