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
    Icon = "zap"
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user"
})

--------------------------------------------------
-- VARIABLES
--------------------------------------------------

_G.AutoKick = false

local kickPos = CFrame.new(0,5,0)
local returnPos = CFrame.new(0,5,0)

--------------------------------------------------
-- REMOTES
--------------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local KickRemote = ReplicatedStorage
    .Shared.Packages.Network.rev_KickEvent

local TransformRemote = ReplicatedStorage
    .Shared.Packages.Network.rev_Transformed

--------------------------------------------------
-- AUTO KICK
--------------------------------------------------

MainTab:Toggle({
    Title = "Auto Kick",
    Desc = "เตะ + วิ่งกลับอัตโนมัติ",
    Value = false,

    Callback = function(state)

        _G.AutoKick = state

        task.spawn(function()

            while _G.AutoKick do

                pcall(function()

                    local player = game.Players.LocalPlayer
                    local char = player.Character or player.CharacterAdded:Wait()

                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")

                    if hrp and hum then

                        --------------------------------------------------
                        -- วาปไปจุดเตะ
                        --------------------------------------------------

                        hrp.CFrame = kickPos

                        task.wait(0.2)

                        --------------------------------------------------
                        -- เตะ
                        --------------------------------------------------

                        KickRemote:FireServer(1,1)

                        --------------------------------------------------
                        -- รอแปรงร่าง
                        --------------------------------------------------

                        local transformed = false

                        local connection
                        connection = TransformRemote.OnClientEvent:Connect(function()
                            transformed = true
                        end)

                        for i = 1,50 do

                            task.wait(0.1)

                            if transformed then
                                break
                            end
                        end

                        if connection then
                            connection:Disconnect()
                        end

                        --------------------------------------------------
                        -- รอหลังแปรงร่าง
                        --------------------------------------------------

                        task.wait(3)

                        --------------------------------------------------
                        -- ปิดบิน
                        --------------------------------------------------

                        hum:ChangeState(Enum.HumanoidStateType.Running)

                        local bodyVelocity = hrp:FindFirstChildOfClass("BodyVelocity")
                        if bodyVelocity then
                            bodyVelocity:Destroy()
                        end

                        local bodyGyro = hrp:FindFirstChildOfClass("BodyGyro")
                        if bodyGyro then
                            bodyGyro:Destroy()
                        end

                        local vectorForce = hrp:FindFirstChildOfClass("VectorForce")
                        if vectorForce then
                            vectorForce:Destroy()
                        end

                        --------------------------------------------------
                        -- วิ่งกลับ
                        --------------------------------------------------

                        hum:MoveTo(returnPos.Position)
                        hum.MoveToFinished:Wait()

                        --------------------------------------------------
                        -- รอ 3 วิ แล้ววนใหม่
                        --------------------------------------------------

                        task.wait(3)

                    end
                end)
            end
        end)
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
    Desc = "บันทึกจุดวิ่งกลับ",

    Callback = function()

        local char = game.Players.LocalPlayer.Character

        if char and char:FindFirstChild("HumanoidRootPart") then

            returnPos = char.HumanoidRootPart.CFrame

            WindUI:Notify({
                Title = "Saved",
                Content = "บันทึกจุดวิ่งกลับแล้ว",
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
