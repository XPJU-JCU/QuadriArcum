extends Control

func papope():
	$Timer.start()
	await $Timer.timeout
	self.hide()
