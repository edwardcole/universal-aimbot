return function()
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
	function toVector2(v3)
		return Vector2.new(v3.X,v3.Z)
	end
	function filter()
		local LocalPlayer = Players.LocalPlayer
		local Character = LocalPlayer.Character
		if not Character then return end
		local closest
		for _, player in pairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end
			local char = player.Character	
			if not char then continue end
			local Head = char.Head
			local Torso = char.Torso or char.UpperTorso
			local dotProd = pos1:Dot(pos2)
			local eye = camera.CFrame.Position
		local fwd = camera.CFrame.LookVector
		local p = Head
		local prod = (p-(p-eye):Dot(fwd)*fwd).Magnitude
			-- dot product is the angle between 2 vectors
			if not closest or closest[1] > prod then
				closest = {prod,char}
				print(prod)
			end
		end
		return closest
	end
	function filterDistance()
		local LocalPlayer = Players.LocalPlayer
		local Character = LocalPlayer.Character
		if not Character then return end
		local closest
		for _, player in pairs(Players:GetPlayers()) do
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

	function aim(target, smoothness)
		-- lower smoothness makes it smoother and therefore slower (but technically more accurate)
		local camera = workspace.CurrentCamera
		local targetx, targety = camera:WorldToViewportPoint(target.Position)
		local targetPos = Vector2.new(targetx,targety)
		local mousePos = game:GetService("UserInputService"):GetMouseLocation()
			local input = game:GetService("VirtualInputManager")
			-- virtualinputmanager can send virtual inputs in roblox (meaning that it can move your mouse, but only inside roblox)
			local destination = mousePos:Lerp(targetPos,smoothness)
			input:SendMouseMoveEvent(destination.X,destination.Y,workspace)
	end
	game:GetService("ContextActionService"):BindAction("jgejge4u89g893e4gu834gu89",function(input,state)
		-- the cryptography thing is just to generate a random string and also to deter non synapse x users lol
		-- the random string is sort of an anti-anticheat
		if state == Enum.UserInputState.Begin then
		if Settings.mode == "fov" then
			target = filter()[2]
			aim(target:FindFirstChild(Settings.part),Settings.smoothness)
		    end
		end
	end,false,Enum.UserInputType.MouseButton2)
end
