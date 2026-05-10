local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Delay Hub",
    Icon = "rbxassetid://0",
    Author = "AUTO FARM",
    Folder = "DelayHub",
    Size = UDim2.fromOffset(520,350),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home"
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user"
})

_G.AutoKick = false
_G.TeleportAfterKick = false

local teleportPos = CFrame.new(0,50,0)

MainTab:Toggle({
    Title = "Auto Kick",
    Desc = "เตะ Lucky Block อัตโนมัติ",
    Value = false,
    Callback = function(state)
        _G.AutoKick = state

        task.spawn(function()
            while _G.AutoKick do
                pcall(function()

                    local player = game.Players.LocalPlayer
                    local char = player.Character or player.CharacterAdded:Wait()

                    for _,v in pairs(workspace:GetDescendants()) do
                        if v.Name:lower():find("lucky") or v.Name:lower():find("block") then

                            local hrp = char:FindFirstChild("HumanoidRootPart")

                            if hrp then
                                hrp.CFrame = v.CFrame + Vector3.new(0,3,0)

                                task.wait(0.2)

                                game:GetService("ReplicatedStorage")
                                    :WaitForChild("KickEvent")
                                    :FireServer()

                                if _G.TeleportAfterKick then

                                    local oldName = char.Name
                                    local transformed = false

                                    for i = 1,50 do
                                        task.wait(0.1)

                                        if char.Name ~= oldName then
                                            transformed = true
                                            break
                                        end

                                        if char:FindFirstChild("Form") or
                                        char:FindFirstChild("Mode") or
                                        char:FindFirstChild("Transformation") then
                                            transformed = true
                                            break
                                        end
                                    end

                                    if not transformed then
                                        task.wait(1)
                                    end

                                    local newHrp = char:FindFirstChild("HumanoidRootPart")

                                    if newHrp then
                                        newHrp.CFrame = teleportPos
                                    end
                                end

                                task.wait(0.5)
                            end
                        end
                    end
                end)

                task.wait(1)
            end
        end)
    end
})

MainTab:Toggle({
    Title = "Teleport After Kick",
    Desc = "วาปกลับหลังแปรงร่าง",
    Value = false,
    Callback = function(state)
        _G.TeleportAfterKick = state
    end
})

PlayerTab:Button({
    Title = "Set Current Position",
    Desc = "บันทึกตำแหน่งปัจจุบัน",
    Callback = function()

        local char = game.Players.LocalPlayer.Character

        if char and char:FindFirstChild("HumanoidRootPart") then
            teleportPos = char.HumanoidRootPart.CFrame

            WindUI:Notify({
                Title = "Saved",
                Content = "บันทึกตำแหน่งแล้ว",
                Duration = 3
            })
        end
    end
})

PlayerTab:Button({
    Title = "Rejoin",
    Desc = "เข้าเซิร์ฟใหม่",
    Callback = function()
        game:GetService("TeleportService")
            :Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

WindUI:Notify({
    Title = "Delay Hub",
    Content = "โหลดสำเร็จ",
    Duration = 3
})
