score = 0
money = 150
lives = 25

function updateScore(change)
	score = score+change
	scoreDisplay.text = score
end

function updateMoney(change)
	money = money+change
	moneyDisplay.text = "$" .. money
end

function loseLife()
	lives = lives-1
	livesDisplay.text = "Lives: " .. lives
end