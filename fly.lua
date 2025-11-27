-- Fly GUI + Fly Script Loader
-- Works when loadstring is enabled in ServerScriptService

local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Create Fly Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.5, -75, 0.6, 0)
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Fly"
button.Parent = gui

local flying = false
local speed = 50
local bodyGyro
local bodyVel

local function startFly(char)
    local root = char:WaitForChild("HumanoidRootPart")

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Parent = root

    flying = true

    task.spawn(function()
        while flying do
            local hrp = root
            local move = Vector3.new()

            local keys = game:GetService("UserInputService")

            if keys:IsKeyDown(Enum.KeyCode.W) then
                move = move + hrp.CFrame.LookVector
            end
            if keys:IsKeyDown(Enum.KeyCode.S) then
                move = move - hrp.CFrame.LookVector
            end
            if keys:IsKeyDown(Enum.KeyCode.A) then
                move = move - hrp.CFrame.RightVector
            end
            if keys:IsKeyDown(Enum.KeyCode.D) then
                move = move + hrp.CFrame.RightVector
            end

            bodyVel.Velocity = move * speed
            bodyGyro.CFrame = hrp.CFrame

            task.wait()
        end
    end)
end

local function stopFly()
    flying = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVel then bodyVel:Destroy() end
end

button.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        button.Text = "Fly"
    else
        local char = player.Character or player.CharacterAdded:Wait()
        startFly(char)
        button.Text = "Stop Flying"
    end
end)
