return function()
	local s, e = pcall(function()
	    local sg = Instance.new("ScreenGui",game:GetService('CoreGui'))
	    local f = Instance.new("Frame",sg)
	    f.Size = UDim2.new(0,5,0,5)
	    local Settings = {
		["mode"] = "fov",
		-- part should be an R15 part or an R6 part inside a character
		["part"] = "Head",
		["character"] = "R6",
		-- smoothness can be nil
		["smoothness"] = 5,
	    }
	    local Players = game:GetService("Players")
	    local target
	    function toVector2(v3)
		return Vector2.new(v3.X,v3.Z)
	    end
	    function filter()
		--local s, e = pcall(function()
			local LocalPlayer = Players.LocalPlayer
			local Character = LocalPlayer.Character
			if not Character then return end
			local closest
			local camera = workspace.CurrentCamera
			for _, player in pairs(Players:GetPlayers()) do
				if player == LocalPlayer then continue end
				local char = player.Character	
				if not char then continue end
				local Head = char.Head
				local eye = camera.CFrame.Position
			local fwd = camera.CFrame.LookVector.Unit
			local p = Head.Position

			local prod = math.floor(math.acos((p-eye).Unit:Dot(fwd))*1000)/1000
				-- dot product is the angle between 2 vectors
				if not closest or closest[1] > prod then
					closest = {prod,char}
				end
			end
			return closest
	       -- end)
		--print(s,e)
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
		local s, e = pcall(function()
		-- lower smoothness makes it smoother and therefore slower (but technically more accurate)
		local camera = workspace.CurrentCamera
		local targetPosV3 = camera:WorldToViewportPoint(target.Position)

		local targetPos = Vector2.new(targetPosV3.X,targetPosV3.Y)
		f.Position = UDim2.new(0,targetPos.X,0,targetPos.Y)
			local mousePos = game:GetService("UserInputService"):GetMouseLocation()

		    local destination = (targetPos-mousePos)/smoothness
		    print(mousePos.X,mousePos.Y)
			mousemoverel(destination.X,destination.Y)
		end)
		print(s,e)
	    end
	    while wait() do
		local function isMouseButtonDown()
			for _,button in pairs(game:GetService("UserInputService"):GetMouseButtonsPressed()) do
				if button.UserInputType == Enum.UserInputType.MouseButton2 then
					return true
				end
			end
			return false
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.T) then
		    local result = filter()
		    if result then
			aim(result[2]:FindFirstChild(Settings.part),Settings.smoothness or 5)
		    end
		end
	    end
	end)
	print(s,e)
end
