extends Node
#this script is in charge of variables that carryover from day to night
#stuff like money, upgrades, bounty hunters etc
#also controls loading and unloading day and night scenes


var money := 0

var dayScene
var nightScene = preload("res://OURSTUFF/Night/in_game_night_main.tscn")


var hunterInventory = {
	"exampleHunter": ["hunterStatsArray", "hunterUpgradesArray"]
} #inventory of all unlocked hunters

var stageCoaches = {
	"exampleCoach": ["coachStatsArray", "coachUpgradesArray"]
} #inventory of stage coaches

func _ready() -> void:
	loadNight()

func addMoney(value: int): # use negative int for subtractinon
	money += value
	print(money)

func getMoney():
	return money

func loadDay():
	pass

func loadNight():
	pass
	var temp = nightScene.instantiate()
	#send data/ call instatiation function
	add_child(temp)
