local Settings = {
	["mode"] = "fov",
	-- part should be an R15 part or an R6 part inside a character
	["part"] = "Head",
	["character"] = "R6",
	-- smoothness can be nil
	["smoothness"] = 0.2,
}
local Players = game:GetService("Players")
local target
function toVector2(v3: Vector3)
	return Vector2.new(v3.X,v3.Z)
end
function filter()
	local LocalPlayer = Players.LocalPlayer
	local Character = LocalPlayer.Character
	local closest
	for _, player in pairs(Players:GetPlayer()) do
		if player.Name == LocalPlayer.Name then continue end
		local char = player.Character	
		if not char then continue end
		local Head = char.Head
		local Torso = char.Torso or char.UpperTorso
		local pos1 = toVector2(Torso.Position)
		local pos2 = toVector2(Character.Head.Position or return)
		local dotProd = pos1:Dot(pos2)
		-- dot product is the angle between 2 vectors
		if not closest or closest[1] > dotProd then
			closest = {dotProd,char}
		end
	end
	return closest
end
function filterDistance()
	local LocalPlayer = Players.LocalPlayer
	local Character = LocalPlayer.Character or return
	local closest
	for _, player in pairs(Players:GetPlayer()) do
		if player.Name == LocalPlayer.Name then continue end
		local char = player.Character	
		if not char then continue end
		local Head = char.Head
		local Torso = char.Torso or char.UpperTorso
		local pos1 = toVector2(Torso.Position)
		local pos2 = toVector2(Character.Head.Position)
		if not closest or closest[1] > (pos1-pos2).Magnitude then
			closest = {(pos1-pos2).Magnitude,char}
		end
	end
end

function aim(target: BasePart, smoothness?: Number)
	-- lower smoothness makes it smoother and therefore slower (but technically more accurate)
	local camera = workspace.CurrentCamera
	local targetx, targety = camera:WorldToViewportPoint(target.Position)
	local targetPos = Vector2.new(targetx,targety)
	local mouseX, mouseY = game:GetService("UserInputService"):GetMousePosition()
	local mousePos = Vector2.new(mouseX,m
	local input = game:GetService("VirtualInputManager")
	-- virtualinputmanager can send virtual inputs in roblox (meaning that it can move your mouse, but only inside roblox)
	local destination = mousePos:Lerp(targetPos,smoothness or 0.1)
	input:SendMouseMoveEvent(destination.X,destination.Y)
end
game:GetService("ContextActionService"):BindAction(tostring(syn.crypt.random(0,200)*math.pi),function(input,state)
	-- the cryptography thing is just to generate a random string and also to deter non synapse x users lol
	-- the random string is sort of an anti-anticheat
	if Settings.mode == "fov" then
		target = filter()[2]
		aim(target:FindFirstChild(Settings.part),Settings.smoothness)
	end
end,false,Enum.UserInputType.MouseButton2)
