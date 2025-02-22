-- 로컬 스크립트 (StarterPlayerScripts 내)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DamageEvent = ReplicatedStorage:WaitForChild("DamageEvent")
local LocalPlayer = game.Players.LocalPlayer

-- 발사 후 주변 플레이어에게 데미지를 입히는 예시
local function triggerDamage(target, damageAmount)
    -- 서버로 DamageEvent 호출, 타겟과 데미지 값 전달
    DamageEvent:FireServer(target, damageAmount)
end

-- 예시로 플레이어 주변에 있는 적을 찾아서 데미지 입히기
local function checkForEnemies()
    local range = 50  -- 범위 설정 (50 studs 내)
    local character = LocalPlayer.Character
    local position = character and character:WaitForChild("HumanoidRootPart").Position

    if not position then return end
    
    -- 주변에 있는 모든 플레이어 확인
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character then
            local otherCharacter = otherPlayer.Character
            local otherHumanoidRootPart = otherCharacter:FindFirstChild("HumanoidRootPart")
            if otherHumanoidRootPart then
                local distance = (position - otherHumanoidRootPart.Position).Magnitude
                if distance <= range then
                    -- 범위 내에 있으면 데미지 입히기
                    triggerDamage(otherHumanoidRootPart, 10)  -- 10의 데미지
                end
            end
        end
    end
end

-- 예시로 1초마다 주변 적을 체크
while true do
    wait(1)
    checkForEnemies()
end
