local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local damageEvent = ReplicatedStorage:WaitForChild("DamageEvent")  -- 이미 존재하는 DamageEvent 리모트 이벤트 참조

local radius = 20  -- 데미지를 입히는 범위 (20 studs)
local damageCooldown = false  -- 쿨타임 변수
local damageInterval = 0.5  -- 쿨타임 간격 (초 단위)

-- 데미지 이벤트를 서버로 전송
local function sendDamageEvent(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        damageEvent:FireServer(targetPlayer)  -- 서버로 데미지 이벤트 전송
    end
end

-- 플레이어 근처에 있는 다른 플레이어 탐지
local function detectNearbyPlayers()
    while true do
        local position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
        if position then
            for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                    local distance = (position - targetPos).Magnitude
                    if distance <= radius and not damageCooldown then
                        -- 데미지 전송
                        sendDamageEvent(targetPlayer)
                        damageCooldown = true
                        wait(damageInterval)  -- 쿨타임 대기
                        damageCooldown = false
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- 근처 플레이어 탐지 시작
detectNearbyPlayers()
