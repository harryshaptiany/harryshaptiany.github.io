-- Music Player GUI untuk Roblox (V4 - Dengan Fitur Minimize)
-- Letakkan script ini di StarterGui sebagai LocalScript

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local SoundService = game:GetService("SoundService")

-- CRITICAL: Hapus SEMUA sound lama dari SoundService
for _, obj in pairs(SoundService:GetChildren()) do
	if obj:IsA("Sound") and obj.Name == "MusicSound" then
		obj:Stop()
		obj:Destroy()
		wait(0.1)
	end
end

-- Hapus sound lama di workspace juga
for _, obj in pairs(game.Workspace:GetChildren()) do
	if obj:IsA("Sound") and obj.Name == "MusicSound" then
		obj:Stop()
		obj:Destroy()
		wait(0.1)
	end
end

-- Hapus GUI lama jika ada
if playerGui:FindFirstChild("MusicPlayerGUI") then
	playerGui.MusicPlayerGUI:Destroy()
	wait(0.1)
end

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MusicPlayerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 100)
mainFrame.Position = UDim2.new(0.5, -175, 0.9, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- ========== TOMBOL MINIMIZE (POJOK KANAN ATAS) ==========
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = mainFrame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

-- Hover effect untuk minimize button
minimizeButton.MouseEnter:Connect(function()
	minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
end)

minimizeButton.MouseLeave:Connect(function()
	minimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
end)

-- ========== ICON MINIMIZED (ICON KECIL) ==========
local minimizedIcon = Instance.new("Frame")
minimizedIcon.Name = "MinimizedIcon"
minimizedIcon.Size = UDim2.new(0, 60, 0, 60)
minimizedIcon.Position = UDim2.new(1, -70, 1, -70) -- Pojok kanan bawah
minimizedIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
minimizedIcon.BorderSizePixel = 0
minimizedIcon.Visible = false -- Hidden by default
minimizedIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 30) -- Membuat bulat
iconCorner.Parent = minimizedIcon

-- Shadow untuk icon
local iconShadow = Instance.new("ImageLabel")
iconShadow.Name = "Shadow"
iconShadow.Size = UDim2.new(1, 10, 1, 10)
iconShadow.Position = UDim2.new(0, -5, 0, -5)
iconShadow.BackgroundTransparency = 1
iconShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
iconShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
iconShadow.ImageTransparency = 0.7
iconShadow.ScaleType = Enum.ScaleType.Slice
iconShadow.SliceCenter = Rect.new(10, 10, 10, 10)
iconShadow.ZIndex = 0
iconShadow.Parent = minimizedIcon

-- Button untuk click pada icon
local iconButton = Instance.new("TextButton")
iconButton.Name = "IconButton"
iconButton.Size = UDim2.new(1, 0, 1, 0)
iconButton.Position = UDim2.new(0, 0, 0, 0)
iconButton.BackgroundTransparency = 1
iconButton.Text = "♪"
iconButton.TextColor3 = Color3.fromRGB(255, 255, 255)
iconButton.TextSize = 28
iconButton.Font = Enum.Font.GothamBold
iconButton.Parent = minimizedIcon

-- Hover effect untuk icon
iconButton.MouseEnter:Connect(function()
	minimizedIcon.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
end)

iconButton.MouseLeave:Connect(function()
	minimizedIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
end)

-- Status indicator (lingkaran kecil untuk menunjukkan sedang playing)
local statusIndicator = Instance.new("Frame")
statusIndicator.Name = "StatusIndicator"
statusIndicator.Size = UDim2.new(0, 12, 0, 12)
statusIndicator.Position = UDim2.new(1, -14, 0, 2)
statusIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
statusIndicator.BorderSizePixel = 0
statusIndicator.Parent = minimizedIcon

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusIndicator

-- ========== FUNGSI TOGGLE MINIMIZE ==========
local isMinimized = false

local function toggleMinimize()
	isMinimized = not isMinimized
	
	if isMinimized then
		-- Minimize: Sembunyikan frame utama, tampilkan icon
		mainFrame.Visible = false
		minimizedIcon.Visible = true
		print("Music Player diminimize")
	else
		-- Maximize: Tampilkan frame utama, sembunyikan icon
		mainFrame.Visible = true
		minimizedIcon.Visible = false
		print("Music Player dimaksimalkan")
	end
end

-- Event listener untuk minimize button
minimizeButton.MouseButton1Click:Connect(function()
	toggleMinimize()
end)

-- Event listener untuk icon (buka kembali)
iconButton.MouseButton1Click:Connect(function()
	toggleMinimize()
end)

-- ==========================================================

-- Label judul lagu
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -50, 0, 30) -- Dikurangi untuk space tombol minimize
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "♪ Nama Lagu - Artis"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
titleLabel.Parent = mainFrame

-- Container untuk tombol kontrol
local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "ControlsFrame"
controlsFrame.Size = UDim2.new(0, 180, 0, 40)
controlsFrame.Position = UDim2.new(0.5, -90, 1, -50)
controlsFrame.BackgroundTransparency = 1
controlsFrame.Parent = mainFrame

-- Fungsi untuk membuat tombol
local function createButton(name, text, position, parent)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0, 50, 0, 40)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 18
	button.Font = Enum.Font.GothamBold
	button.Parent = parent

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = button

	-- Hover effect
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	end)

	return button
end

-- Buat tombol kontrol
local prevButton = createButton("PrevButton", "⏮", UDim2.new(0, 0, 0, 0), controlsFrame)
local playPauseButton = createButton("PlayPauseButton", "▶", UDim2.new(0, 65, 0, 0), controlsFrame)
local nextButton = createButton("NextButton", "⏭", UDim2.new(0, 130, 0, 0), controlsFrame)

-- Variabel status
local isPlaying = false
local currentSongIndex = 1

-- Daftar lagu (ganti dengan Sound ID Roblox Anda)
-- Cara mendapat Sound ID:
-- 1. Pergi ke www.roblox.com/library
-- 2. Cari audio/musik yang Anda inginkan
-- 3. Buka halaman audio tersebut
-- 4. Copy angka dari URL (contoh: roblox.com/library/1234567/Song-Name)
-- 5. Paste angka tersebut sebagai soundId di bawah

local playlist = {
	{title = "Hindia - everything u are", soundId = 71904797967321},
	{title = "Hindia - Berdansalah, Karir Ini Tak Ada Artinya", soundId = 93639117829581},
	{title = "Nadin Amizah - Bertaut", soundId = 137283631596356},
	{title = "The Spectre - Alan Walker", soundId = 1588508943},
	{title = "Legends Never Die - Against The Current", soundId = 1054968747}
	-- Tambahkan lagu lainnya di sini dengan format yang sama
}

-- Buat Sound object UNIK - Parent ke SoundService agar tidak terpengaruh respawn
local sound = Instance.new("Sound")
sound.Name = "MusicSound_" .. player.UserId -- Nama unik per player
sound.Parent = SoundService
sound.Volume = 0.5
sound.Looped = false
sound.PlayOnRemove = false -- Pastikan tidak auto-play saat dihapus

-- Fungsi untuk update status indicator
local function updateStatusIndicator()
	if isPlaying then
		statusIndicator.BackgroundColor3 = Color3.fromRGB(80, 200, 120) -- Hijau = playing
	else
		statusIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Abu = paused
	end
end

-- Fungsi untuk memuat lagu
local function loadSong(index)
	if index < 1 then index = #playlist end
	if index > #playlist then index = 1 end

	currentSongIndex = index
	local song = playlist[currentSongIndex]

	-- Simpan posisi waktu dan status playing
	local wasPlaying = sound.Playing
	local timePos = sound.TimePosition

	sound:Stop()
	sound.SoundId = "rbxassetid://" .. song.soundId
	titleLabel.Text = "♪ " .. song.title

	-- Lanjutkan playing jika sebelumnya playing
	if wasPlaying or isPlaying then
		sound:Play()
		isPlaying = true
		playPauseButton.Text = "⏸"
		updateStatusIndicator()
	end
end

-- Fungsi play/pause
local function togglePlayPause()
	-- Cek apakah ada Sound lain yang playing
	for _, obj in pairs(SoundService:GetChildren()) do
		if obj:IsA("Sound") and obj.Name:match("MusicSound") and obj ~= sound and obj.Playing then
			obj:Stop()
			print("Menghentikan sound duplikat")
		end
	end

	if isPlaying then
		sound:Pause()
		playPauseButton.Text = "▶"
		isPlaying = false
		updateStatusIndicator()
		print("Musik di-pause")
	else
		sound:Play()
		playPauseButton.Text = "⏸"
		isPlaying = true
		updateStatusIndicator()
		print("Musik di-play")
	end
end

-- Event listeners untuk tombol
playPauseButton.MouseButton1Click:Connect(function()
	togglePlayPause()
end)

prevButton.MouseButton1Click:Connect(function()
	-- Simpan status sebelum ganti lagu
	local shouldPlay = isPlaying
	loadSong(currentSongIndex - 1)
	if shouldPlay then
		isPlaying = true
		playPauseButton.Text = "⏸"
		updateStatusIndicator()
	end
end)

nextButton.MouseButton1Click:Connect(function()
	-- Simpan status sebelum ganti lagu
	local shouldPlay = isPlaying
	loadSong(currentSongIndex + 1)
	if shouldPlay then
		isPlaying = true
		playPauseButton.Text = "⏸"
		updateStatusIndicator()
	end
end)

-- Auto play lagu berikutnya ketika selesai
sound.Ended:Connect(function()
	loadSong(currentSongIndex + 1)
	if isPlaying then
		sound:Play()
		updateStatusIndicator()
	end
end)

-- PENTING: Saat respawn, JANGAN ubah apapun, biarkan state tetap
player.CharacterAdded:Connect(function(newChar)
	print("Player respawned - Mempertahankan state musik")
	-- TIDAK ada perubahan state di sini sama sekali
end)

-- Cleanup saat GUI dihapus
screenGui.Destroying:Connect(function()
	if sound and sound.Parent then
		sound:Stop()
		sound:Destroy()
	end
end)

-- Cleanup saat player leave
game.Players.PlayerRemoving:Connect(function(plr)
	if plr == player then
		if sound and sound.Parent then
			sound:Stop()
			sound:Destroy()
		end
	end
end)

-- Muat lagu pertama
loadSong(1)
updateStatusIndicator()

print("Music Player GUI V4 berhasil dimuat! Musik tetap putar saat respawn + Fitur Minimize!")
