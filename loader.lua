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
local kickPos = CFrame.new(0,5,0)

--------------------------------------------------
-- AUTO KICK
--------------------------------------------------

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
                    local hrp = char:FindFirstChild("HumanoidRootPart")

                    if hrp then

                        --------------------------------------------------
                        -- วาปไปจุดเตะ
                        --------------------------------------------------

                        hrp.CFrame = kickPos

                        task.wait(0.2)

                        --------------------------------------------------
                        -- เตะ
                        --------------------------------------------------

                        game:GetService("ReplicatedStorage")
                            :WaitForChild("KickEvent")
                            :FireServer()

                        --------------------------------------------------
                        -- วาปกลับหลังแปรงร่าง
                        --------------------------------------------------

                        if _G.TeleportAfterKick then

                            task.wait(2)

                            local newHrp = char:FindFirstChild("HumanoidRootPart")

                            if newHrp then
                                newHrp.CFrame = teleportPos
                            end
                        end
                    end
                end)

                task.wait(1)

            end
        end)
    end
})

--------------------------------------------------
-- TOGGLE วาปกลับ
--------------------------------------------------

MainTab:Toggle({
    Title = "Teleport After Kick",
    Desc = "วาปกลับหลังเตะ",
    Value = false,

    Callback = function(state)
        _G.TeleportAfterKick = state
    end
})

--------------------------------------------------
-- SET KICK POSITION
--------------------------------------------------

PlayerTab:Button({
    Title = "Set Kick Position",
    Desc = "บันทึกจุดเตะ",

    Callback = function()

        local char = game.Players.LocalPlayer.Character

        if char and char:FindFirstChild("HumanoidRootPart") then

            kickPos = char.HumanoidRootPart.CFrame

            WindUI:Notify({
                Title = "Saved",
                Content = "บันทึกจุดเตะแล้ว",
                Duration = 3
            })
        end
    end
})

--------------------------------------------------
-- SET RETURN POSITION
--------------------------------------------------

PlayerTab:Button({
    Title = "Set Return Position",
    Desc = "บันทึกจุดวาปกลับ",

    Callback = function()

        local char = game.Players.LocalPlayer.Character

        if char and char:FindFirstChild("HumanoidRootPart") then

            teleportPos = char.HumanoidRootPart.CFrame

            WindUI:Notify({
                Title = "Saved",
                Content = "บันทึกจุดวาปกลับแล้ว",
                Duration = 3
            })
        end
    end
})

--------------------------------------------------
-- REJOIN
--------------------------------------------------

PlayerTab:Button({
    Title = "Rejoin",
    Desc = "เข้าเซิร์ฟใหม่",

    Callback = function()

        game:GetService("TeleportService")
            :Teleport(game.PlaceId, game.Players.LocalPlayer)

    end
})

--------------------------------------------------
-- NOTIFY
--------------------------------------------------

WindUI:Notify({
    Title = "Delay Hub",
    Content = "โหลดสำเร็จ",
    Duration = 3
})
