--[[
    LIQUID SHADER STUDIO
    Toggle shaders: F4
    Toggle hub: RightShift
]]

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local SHADER_KEY = Enum.KeyCode.F4
local HUB_KEY = Enum.KeyCode.RightShift
local GUI_NAME = "__NVIDIA_RTX_HUB_V4"
local CINEMA_OVERLAY_NAME = "__RTX_CINEMA_OVERLAY_V4"

local MANAGED_NAMES = {
    ColorCorrection = "__RTX_CC_V4",
    ColorGrading = "__RTX_GRADING_V4",
    Bloom = "__RTX_BLOOM_V4",
    SunRays = "__RTX_SUNRAYS_V4",
    Atmosphere = "__RTX_ATMOS_V4",
    DepthOfField = "__RTX_DOF_V4",
    Clouds = "__RTX_CLOUDS_V4",
    Sky = "__RTX_SKY_V4",
}

local SKYBOX_KEYS = {
    "SkyboxBk",
    "SkyboxDn",
    "SkyboxFt",
    "SkyboxLf",
    "SkyboxRt",
    "SkyboxUp",
}

local REALISM_SKYBOX_DIR = "C:\\Users\\Not4E\\Downloads\\shaders roblox lua\\assets\\skyboxes\\kloofendal_overcast_puresky"
local REALISM_SKYBOX_PATHS = {
    SkyboxBk = REALISM_SKYBOX_DIR .. "\\bk.jpg",
    SkyboxDn = REALISM_SKYBOX_DIR .. "\\dn.jpg",
    SkyboxFt = REALISM_SKYBOX_DIR .. "\\ft.jpg",
    SkyboxLf = REALISM_SKYBOX_DIR .. "\\lf.jpg",
    SkyboxRt = REALISM_SKYBOX_DIR .. "\\rt.jpg",
    SkyboxUp = REALISM_SKYBOX_DIR .. "\\up.jpg",
}

local THEME = {
    Background = Color3.fromRGB(248, 249, 252),
    Surface = Color3.fromRGB(255, 255, 255),
    SurfaceAlt = Color3.fromRGB(245, 247, 250),
    SurfaceSoft = Color3.fromRGB(236, 239, 244),
    Stroke = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(163, 169, 178),
    AccentSoft = Color3.fromRGB(191, 196, 205),
    AccentGlow = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(26, 28, 33),
    Muted = Color3.fromRGB(98, 104, 114),
    Danger = Color3.fromRGB(186, 77, 77),
    Positive = Color3.fromRGB(54, 120, 82),
    Backdrop = Color3.fromRGB(8, 8, 10),
}

local LIGHTING_KEYS = {
    "Technology",
    "LightingStyle",
    "PrioritizeLightingQuality",
    "GlobalShadows",
    "Brightness",
    "ExposureCompensation",
    "EnvironmentDiffuseScale",
    "EnvironmentSpecularScale",
    "Ambient",
    "OutdoorAmbient",
    "ColorShift_Top",
    "ColorShift_Bottom",
    "ShadowSoftness",
}

local TERRAIN_KEYS = {
    "WaterWaveSize",
    "WaterWaveSpeed",
    "WaterReflectance",
    "WaterColor",
}

local DEFAULT_CONFIG = {
    Lighting = {
        LightingStyle = Enum.LightingStyle.Realistic,
        PrioritizeLightingQuality = true,
        GlobalShadows = true,
        Brightness = 2.34,
        ExposureCompensation = -0.03,
        EnvironmentDiffuseScale = 0.52,
        EnvironmentSpecularScale = 1,
        Ambient = Color3.fromRGB(12, 14, 18),
        OutdoorAmbient = Color3.fromRGB(66, 72, 82),
        ColorShift_Top = Color3.fromRGB(255, 247, 238),
        ColorShift_Bottom = Color3.fromRGB(32, 40, 54),
        ShadowSoftness = 0.22,
    },
    ColorCorrection = {
        Brightness = 0.01,
        Contrast = 0.08,
        Saturation = 0.05,
        TintColor = Color3.fromRGB(255, 250, 245),
    },
    ColorGrading = {
        Enabled = true,
        TonemapperPreset = Enum.TonemapperPreset.Default,
    },
    Bloom = {
        Intensity = 0.075,
        Size = 24,
        Threshold = 1.55,
    },
    SunRays = {
        Intensity = 0.03,
        Spread = 0.66,
    },
    Atmosphere = {
        Density = 0.17,
        Offset = 0.04,
        Color = Color3.fromRGB(220, 226, 235),
        Decay = Color3.fromRGB(116, 126, 140),
        Glare = 0.03,
        Haze = 0.46,
    },
    DepthOfField = {
        Enabled = false,
        FarIntensity = 0.08,
        NearIntensity = 0.02,
        FocusDistance = 90,
        InFocusRadius = 72,
    },
    Terrain = {
        WaterWaveSize = 0.06,
        WaterWaveSpeed = 7.4,
        WaterReflectance = 0.88,
        WaterColor = Color3.fromRGB(24, 42, 60),
    },
    Clouds = {
        Enabled = true,
        Cover = 0.32,
        Density = 0.54,
        Color = Color3.fromRGB(250, 251, 255),
    },
    Sky = {
        Enabled = false,
        AssetId = nil,
        CelestialBodiesShown = false,
        StarCount = 0,
        SkyboxBk = "",
        SkyboxDn = "",
        SkyboxFt = "",
        SkyboxLf = "",
        SkyboxRt = "",
        SkyboxUp = "",
    },
    Autofocus = {
        Enabled = false,
        MinDistance = 14,
        MaxDistance = 700,
        UpdateInterval = 1 / 40,
        LerpAlpha = 0.14,
    },
    AutoExposure = {
        Enabled = false,
        MinExposure = -0.55,
        MaxExposure = 0.12,
        SkyDarkening = 0.08,
        IndoorLift = 0.1,
        AdaptSpeed = 0.07,
        UpdateInterval = 1 / 24,
    },
    CinemaOverlay = {
        Enabled = false,
        VignetteOpacity = 0.18,
        LetterboxOpacity = 0,
        EdgeSize = 0.18,
    },
    LocalLightInfluence = {
        Enabled = false,
        Radius = 90,
        MaxLights = 28,
        ScanBudget = 140,
        UpdateInterval = 0.24,
        TintStrength = 0.16,
        BloomStrength = 0.055,
        ExposureStrength = 0.045,
        ReflectionBoost = 0.18,
        AdaptSpeed = 0.16,
    },
    Reflections = {
        Enabled = true,
        Radius = 300,
        MaxParts = 220,
        SelectionMultiplier = 1.7,
        QueryMaxParts = 420,
        NearMaxParts = 180,
        MinPartSize = 1.5,
        MaxTransparency = 0.95,
        RefreshInterval = 0.95,
        ForceRefreshInterval = 3.8,
        MinCameraMoveForRefresh = 7,
        MinCameraLookDeltaForRefresh = 0.035,
        MinLightBoostRefreshDelta = 0.035,
        DefaultReflectance = 0.05,
        Multiplier = 1.28,
        FresnelPower = 1.35,
        AngularBoost = 0.85,
        MaxReflectance = 0.32,
        NearCoverageRadius = 120,
        MaterialReflectance = {
            [Enum.Material.Plastic] = 0.06,
            [Enum.Material.SmoothPlastic] = 0.09,
            [Enum.Material.Metal] = 0.24,
            [Enum.Material.DiamondPlate] = 0.18,
            [Enum.Material.Foil] = 0.28,
            [Enum.Material.Glass] = 0.14,
            [Enum.Material.Ice] = 0.12,
            [Enum.Material.Marble] = 0.08,
            [Enum.Material.Granite] = 0.06,
            [Enum.Material.Concrete] = 0.04,
            [Enum.Material.Brick] = 0.04,
            [Enum.Material.Cobblestone] = 0.035,
            [Enum.Material.Slate] = 0.05,
            [Enum.Material.Sandstone] = 0.035,
            [Enum.Material.Wood] = 0.03,
            [Enum.Material.WoodPlanks] = 0.04,
            [Enum.Material.Neon] = 0.02,
            [Enum.Material.Fabric] = 0.025,
            [Enum.Material.Asphalt] = 0.035,
            [Enum.Material.Basalt] = 0.05,
            [Enum.Material.Pavement] = 0.04,
            [Enum.Material.Limestone] = 0.05,
            [Enum.Material.Sand] = 0.02,
            [Enum.Material.Mud] = 0.02,
            [Enum.Material.Ground] = 0.02,
            [Enum.Material.LeafyGrass] = 0.02,
            [Enum.Material.Grass] = 0.02,
        },
    },
}

local PRESET_LIBRARY = {
    Balanced = {
        Tag = "Signature",
        Description = "Neutral filmic baseline with restrained bloom, cleaner air and more believable reflections.",
        Color = Color3.fromRGB(183, 232, 255),
        Config = {},
    },
    Dreamcore = {
        Tag = "Soft surreal",
        Description = "Nostalgic liminal grade with faded colors, soft camera glow and an unreal memory-like atmosphere.",
        Color = Color3.fromRGB(255, 190, 225),
        Config = {
            Lighting = {
                Brightness = 2.58,
                ExposureCompensation = 0.05,
                EnvironmentDiffuseScale = 0.5,
                EnvironmentSpecularScale = 0.68,
                Ambient = Color3.fromRGB(30, 30, 34),
                OutdoorAmbient = Color3.fromRGB(96, 95, 88),
                ColorShift_Top = Color3.fromRGB(255, 243, 214),
                ColorShift_Bottom = Color3.fromRGB(118, 132, 150),
                ShadowSoftness = 0.56,
            },
            ColorCorrection = {
                Brightness = 0.03,
                Contrast = -0.02,
                Saturation = -0.03,
                TintColor = Color3.fromRGB(245, 243, 226),
            },
            ColorGrading = {
                Enabled = true,
                TonemapperPreset = Enum.TonemapperPreset.Retro,
            },
            Bloom = {
                Intensity = 0.14,
                Size = 34,
                Threshold = 1.08,
            },
            SunRays = {
                Intensity = 0.03,
                Spread = 0.82,
            },
            Atmosphere = {
                Density = 0.29,
                Offset = 0.09,
                Color = Color3.fromRGB(236, 231, 214),
                Decay = Color3.fromRGB(158, 165, 182),
                Glare = 0.08,
                Haze = 1.08,
            },
            DepthOfField = {
                Enabled = true,
                FarIntensity = 0.18,
                NearIntensity = 0.05,
                FocusDistance = 68,
                InFocusRadius = 34,
            },
            Terrain = {
                WaterWaveSize = 0.042,
                WaterWaveSpeed = 4.4,
                WaterReflectance = 0.56,
                WaterColor = Color3.fromRGB(128, 146, 158),
            },
            Clouds = {
                Enabled = true,
                Cover = 0.58,
                Density = 0.64,
                Color = Color3.fromRGB(252, 249, 240),
            },
            Autofocus = {
                Enabled = true,
                MinDistance = 10,
                MaxDistance = 560,
                UpdateInterval = 1 / 40,
                LerpAlpha = 0.11,
            },
            Reflections = {
                Multiplier = 0.84,
                DefaultReflectance = 0.04,
                Radius = 230,
                MaxParts = 220,
                MinPartSize = 1.5,
                MaxTransparency = 0.96,
            },
        },
    },
    Realism = {
        Tag = "Filmic natural",
        Description = "Author-style photoreal overcast grade: deeper contact shadows, cool shadow bias, restrained highlights and atmospheric depth.",
        Color = Color3.fromRGB(180, 219, 198),
        Config = {
            Lighting = {
                LightingStyle = Enum.LightingStyle.Realistic,
                PrioritizeLightingQuality = true,
                Brightness = 1.48,
                ExposureCompensation = -0.31,
                EnvironmentDiffuseScale = 0.58,
                EnvironmentSpecularScale = 0.88,
                Ambient = Color3.fromRGB(5, 7, 10),
                OutdoorAmbient = Color3.fromRGB(38, 43, 52),
                ColorShift_Top = Color3.fromRGB(232, 232, 228),
                ColorShift_Bottom = Color3.fromRGB(22, 27, 36),
                ShadowSoftness = 0.27,
            },
            ColorCorrection = {
                Brightness = -0.018,
                Contrast = 0.115,
                Saturation = -0.035,
                TintColor = Color3.fromRGB(230, 235, 240),
            },
            ColorGrading = {
                Enabled = true,
                TonemapperPreset = Enum.TonemapperPreset.Default,
            },
            Bloom = {
                Intensity = 0.028,
                Size = 32,
                Threshold = 1.92,
            },
            SunRays = {
                Intensity = 0.012,
                Spread = 0.82,
            },
            Atmosphere = {
                Density = 0.285,
                Offset = 0.02,
                Color = Color3.fromRGB(204, 211, 220),
                Decay = Color3.fromRGB(82, 90, 104),
                Glare = 0.018,
                Haze = 1.08,
            },
            DepthOfField = {
                Enabled = true,
                FarIntensity = 0.018,
                NearIntensity = 0.004,
                FocusDistance = 165,
                InFocusRadius = 120,
            },
            Terrain = {
                WaterWaveSize = 0.038,
                WaterWaveSpeed = 5.2,
                WaterReflectance = 0.64,
                WaterColor = Color3.fromRGB(13, 21, 30),
            },
            Clouds = {
                Enabled = true,
                Cover = 0.84,
                Density = 0.74,
                Color = Color3.fromRGB(215, 220, 227),
            },
            Sky = {
                Enabled = true,
                AssetId = 12376964583,
                CelestialBodiesShown = false,
                StarCount = 0,
                SkyboxBk = "",
                SkyboxDn = "",
                SkyboxFt = "",
                SkyboxLf = "",
                SkyboxRt = "",
                SkyboxUp = "",
            },
            Autofocus = {
                Enabled = true,
                MinDistance = 8,
                MaxDistance = 900,
                UpdateInterval = 1 / 48,
                LerpAlpha = 0.2,
            },
            AutoExposure = {
                Enabled = true,
                MinExposure = -0.62,
                MaxExposure = -0.06,
                SkyDarkening = 0.13,
                IndoorLift = 0.12,
                AdaptSpeed = 0.1,
                UpdateInterval = 1 / 45,
            },
            CinemaOverlay = {
                Enabled = true,
                VignetteOpacity = 0.26,
                LetterboxOpacity = 0.08,
                EdgeSize = 0.2,
            },
            LocalLightInfluence = {
                Enabled = true,
                Radius = 145,
                MaxLights = 90,
                ScanBudget = 1200,
                UpdateInterval = 1 / 45,
                TintStrength = 0.22,
                BloomStrength = 0.09,
                ExposureStrength = 0.055,
                ReflectionBoost = 0.34,
                AdaptSpeed = 0.28,
            },
            Reflections = {
                Multiplier = 1.62,
                DefaultReflectance = 0.064,
                Radius = 620,
                MaxParts = 900,
                SelectionMultiplier = 2.4,
                QueryMaxParts = 1800,
                NearMaxParts = 850,
                MinPartSize = 0.38,
                MaxTransparency = 0.985,
                RefreshInterval = 0.18,
                ForceRefreshInterval = 0.7,
                MinCameraMoveForRefresh = 0.9,
                MinCameraLookDeltaForRefresh = 0.004,
                MinLightBoostRefreshDelta = 0.01,
                FresnelPower = 0.88,
                AngularBoost = 1.22,
                MaxReflectance = 0.48,
                NearCoverageRadius = 285,
                MaterialReflectance = {
                    [Enum.Material.Plastic] = 0.07,
                    [Enum.Material.SmoothPlastic] = 0.11,
                    [Enum.Material.Metal] = 0.32,
                    [Enum.Material.DiamondPlate] = 0.27,
                    [Enum.Material.Foil] = 0.36,
                    [Enum.Material.Glass] = 0.25,
                    [Enum.Material.Ice] = 0.22,
                    [Enum.Material.Marble] = 0.105,
                    [Enum.Material.Granite] = 0.075,
                    [Enum.Material.Concrete] = 0.055,
                    [Enum.Material.Brick] = 0.052,
                    [Enum.Material.Cobblestone] = 0.05,
                    [Enum.Material.Slate] = 0.07,
                    [Enum.Material.Sandstone] = 0.045,
                    [Enum.Material.Wood] = 0.038,
                    [Enum.Material.WoodPlanks] = 0.046,
                    [Enum.Material.Neon] = 0.035,
                    [Enum.Material.Fabric] = 0.024,
                    [Enum.Material.Asphalt] = 0.062,
                    [Enum.Material.Basalt] = 0.078,
                    [Enum.Material.Pavement] = 0.072,
                    [Enum.Material.Limestone] = 0.074,
                    [Enum.Material.Sand] = 0.026,
                    [Enum.Material.Mud] = 0.032,
                    [Enum.Material.Ground] = 0.035,
                    [Enum.Material.LeafyGrass] = 0.014,
                    [Enum.Material.Grass] = 0.014,
                },
            },
        },
    },
    GoldenHour = {
        Tag = "Cinematic warm",
        Description = "Warm filmic sunset with amber atmosphere, softer contrast and controlled solar bloom.",
        Color = Color3.fromRGB(255, 204, 136),
        Config = {
            Lighting = {
                Brightness = 2.64,
                ExposureCompensation = 0.02,
                EnvironmentDiffuseScale = 0.58,
                EnvironmentSpecularScale = 0.96,
                Ambient = Color3.fromRGB(26, 20, 17),
                OutdoorAmbient = Color3.fromRGB(108, 86, 68),
                ColorShift_Top = Color3.fromRGB(255, 220, 170),
                ColorShift_Bottom = Color3.fromRGB(88, 56, 34),
                ShadowSoftness = 0.3,
            },
            ColorCorrection = {
                Brightness = 0.03,
                Contrast = 0.1,
                Saturation = 0.12,
                TintColor = Color3.fromRGB(255, 238, 219),
            },
            ColorGrading = {
                Enabled = true,
                TonemapperPreset = Enum.TonemapperPreset.Default,
            },
            Bloom = {
                Intensity = 0.1,
                Size = 28,
                Threshold = 1.22,
            },
            SunRays = {
                Intensity = 0.075,
                Spread = 0.76,
            },
            Atmosphere = {
                Density = 0.26,
                Offset = 0.08,
                Color = Color3.fromRGB(255, 214, 168),
                Decay = Color3.fromRGB(184, 118, 84),
                Glare = 0.1,
                Haze = 0.82,
            },
            DepthOfField = {
                Enabled = true,
                FarIntensity = 0.11,
                NearIntensity = 0.03,
                FocusDistance = 84,
                InFocusRadius = 50,
            },
            Terrain = {
                WaterWaveSize = 0.06,
                WaterWaveSpeed = 6,
                WaterReflectance = 0.88,
                WaterColor = Color3.fromRGB(62, 58, 66),
            },
            Clouds = {
                Enabled = true,
                Cover = 0.42,
                Density = 0.56,
                Color = Color3.fromRGB(255, 224, 190),
            },
            Autofocus = {
                Enabled = true,
                MinDistance = 16,
                MaxDistance = 720,
                UpdateInterval = 1 / 32,
                LerpAlpha = 0.11,
            },
            Reflections = {
                Multiplier = 1.46,
                DefaultReflectance = 0.058,
                Radius = 320,
                MaxParts = 330,
                MinPartSize = 1.5,
                MaxTransparency = 0.96,
            },
        },
    },
    NeonPulse = {
        Tag = "Night pop",
        Description = "Night-grade profile with tighter highlights, richer emissive pop and controlled neon spill.",
        Color = Color3.fromRGB(131, 184, 255),
        Config = {
            Lighting = {
                Brightness = 2.02,
                ExposureCompensation = -0.22,
                EnvironmentDiffuseScale = 0.14,
                EnvironmentSpecularScale = 1,
                Ambient = Color3.fromRGB(8, 10, 18),
                OutdoorAmbient = Color3.fromRGB(42, 58, 96),
                ColorShift_Top = Color3.fromRGB(190, 222, 255),
                ColorShift_Bottom = Color3.fromRGB(18, 14, 42),
                ShadowSoftness = 0.12,
            },
            ColorCorrection = {
                Brightness = 0.015,
                Contrast = 0.18,
                Saturation = 0.22,
                TintColor = Color3.fromRGB(232, 238, 255),
            },
            ColorGrading = {
                Enabled = true,
                TonemapperPreset = Enum.TonemapperPreset.Default,
            },
            Bloom = {
                Intensity = 0.16,
                Size = 38,
                Threshold = 0.92,
            },
            SunRays = {
                Intensity = 0.01,
                Spread = 0.34,
            },
            Atmosphere = {
                Density = 0.19,
                Offset = 0.04,
                Color = Color3.fromRGB(118, 162, 255),
                Decay = Color3.fromRGB(68, 44, 132),
                Glare = 0.11,
                Haze = 0.58,
            },
            DepthOfField = {
                Enabled = true,
                FarIntensity = 0.14,
                NearIntensity = 0.05,
                FocusDistance = 66,
                InFocusRadius = 38,
            },
            Terrain = {
                WaterWaveSize = 0.025,
                WaterWaveSpeed = 3.6,
                WaterReflectance = 1,
                WaterColor = Color3.fromRGB(9, 16, 34),
            },
            Clouds = {
                Enabled = true,
                Cover = 0.14,
                Density = 0.28,
                Color = Color3.fromRGB(200, 224, 255),
            },
            Autofocus = {
                Enabled = true,
                MinDistance = 12,
                MaxDistance = 500,
                UpdateInterval = 1 / 45,
                LerpAlpha = 0.16,
            },
            Reflections = {
                Multiplier = 1.75,
                DefaultReflectance = 0.072,
                Radius = 340,
                MaxParts = 360,
                MinPartSize = 1.25,
                MaxTransparency = 0.97,
            },
        },
    },
    NoirRain = {
        Tag = "Wet dramatic",
        Description = "Desaturated wet-night grade with flatter tonemapping, moody atmosphere and selective wet reflections.",
        Color = Color3.fromRGB(166, 176, 204),
        Config = {
            Lighting = {
                Brightness = 1.78,
                ExposureCompensation = -0.24,
                EnvironmentDiffuseScale = 0.18,
                EnvironmentSpecularScale = 1,
                Ambient = Color3.fromRGB(6, 8, 10),
                OutdoorAmbient = Color3.fromRGB(36, 42, 52),
                ColorShift_Top = Color3.fromRGB(222, 228, 238),
                ColorShift_Bottom = Color3.fromRGB(18, 22, 30),
                ShadowSoftness = 0.1,
            },
            ColorCorrection = {
                Brightness = -0.015,
                Contrast = 0.16,
                Saturation = -0.12,
                TintColor = Color3.fromRGB(230, 236, 244),
            },
            ColorGrading = {
                Enabled = true,
                TonemapperPreset = Enum.TonemapperPreset.Retro,
            },
            Bloom = {
                Intensity = 0.035,
                Size = 20,
                Threshold = 1.65,
            },
            SunRays = {
                Intensity = 0,
                Spread = 0.3,
            },
            Atmosphere = {
                Density = 0.31,
                Offset = 0.06,
                Color = Color3.fromRGB(184, 194, 208),
                Decay = Color3.fromRGB(66, 72, 84),
                Glare = 0.012,
                Haze = 0.96,
            },
            DepthOfField = {
                Enabled = false,
                FarIntensity = 0.08,
                NearIntensity = 0.02,
                FocusDistance = 92,
                InFocusRadius = 66,
            },
            Terrain = {
                WaterWaveSize = 0.018,
                WaterWaveSpeed = 2.6,
                WaterReflectance = 0.94,
                WaterColor = Color3.fromRGB(10, 14, 22),
            },
            Clouds = {
                Enabled = true,
                Cover = 0.78,
                Density = 0.82,
                Color = Color3.fromRGB(212, 218, 228),
            },
            Autofocus = {
                Enabled = false,
            },
            Reflections = {
                Multiplier = 1.95,
                DefaultReflectance = 0.08,
                Radius = 360,
                MaxParts = 360,
                MinPartSize = 1.25,
                MaxTransparency = 0.97,
                RefreshInterval = 0.5,
            },
        },
    },
}

local PRESET_ORDER = {
    "Balanced",
    "Dreamcore",
    "Realism",
    "GoldenHour",
    "NeonPulse",
    "NoirRain",
}

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for key, item in pairs(value) do
        copy[key] = deepCopy(item)
    end
    return copy
end

local function mergeTableInto(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" and type(target[key]) == "table" then
            mergeTableInto(target[key], value)
        else
            target[key] = deepCopy(value)
        end
    end
end

local currentConfig = deepCopy(DEFAULT_CONFIG)
local effectRefs = {}
local uiRefs = {}
local controlRefreshers = {}
local reflectedParts = {}
local glassRefs = {}
local autoHeightUpdaters = {}
local skyAssetCache = {}
local localLightState = {
    Strength = 0,
    Color = Color3.fromRGB(255, 255, 255),
    ExposureOffset = 0,
    BloomOffset = 0,
    ReflectionBoost = 0,
}
local localLightRuntimeWasEnabled = false
local localLightCache = {}
local localLightCacheIndex = {}
local localLightScanOffset = 1

local isEnabled = false
local hubVisible = true
local selectedPresetName = "Balanced"
local savedState = nil
local focusConnection = nil
local reflectionRefreshConnection = nil
local reflectionRefreshQueued = false
local autoExposureConnection = nil
local localLightInfluenceConnection = nil
local localLightAddedConnection = nil
local localLightRemovingConnection = nil

local refreshAllControls
local applyRuntimeConfig
local enableRTX
local disableRTX
local setHubVisible
local syncAndRefresh
local setGlassVisual
local disconnectLocalLightCache

local function loadLiquidGlass()
    if not readfile or not loadstring then
        return nil
    end

    local candidates = {
        "LiquidGlass.luau",
        "liquidglass.luau",
        "C:\\Users\\Not4E\\Downloads\\shaders roblox lua\\LiquidGlass.luau",
    }

    for _, path in ipairs(candidates) do
        local ok, source = pcall(readfile, path)
        if ok and source and #source > 0 then
            local chunk = loadstring(source)
            if chunk then
                local success, module = pcall(chunk)
                if success and type(module) == "table" then
                    return module
                end
            end
        end
    end

    return nil
end

local LiquidGlass = loadLiquidGlass()

local function roundTo(value, decimals)
    if decimals <= 0 then
        return math.floor(value + 0.5)
    end

    local factor = 10 ^ decimals
    return math.floor(value * factor + 0.5) / factor
end

local function formatValue(value, decimals)
    if decimals <= 0 then
        return tostring(math.floor(value + 0.5))
    end

    return string.format("%." .. tostring(decimals) .. "f", value)
end

local function safeSetTechnology(technology)
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(Lighting, "Technology", technology)
        else
            Lighting.Technology = technology
        end
    end)
end

local function safeSetLightingStyle(style)
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(Lighting, "LightingStyle", style)
        else
            Lighting.LightingStyle = style
        end
    end)
end

local function safeSetPrioritizeLightingQuality(enabled)
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(Lighting, "PrioritizeLightingQuality", enabled)
        else
            Lighting.PrioritizeLightingQuality = enabled
        end
    end)
end

local function snapshotProperties(instance, keys)
    local snapshot = {}
    for _, key in ipairs(keys) do
        snapshot[key] = instance[key]
    end
    return snapshot
end

local function applyProperties(instance, properties)
    for key, value in pairs(properties) do
        if key == "Technology" then
            safeSetTechnology(value)
        elseif key == "LightingStyle" then
            safeSetLightingStyle(value)
        elseif key == "PrioritizeLightingQuality" then
            safeSetPrioritizeLightingQuality(value)
        else
            pcall(function()
                instance[key] = value
            end)
        end
    end
end

local function captureSkyTemplates()
    local templates = {}
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") and child.Name ~= MANAGED_NAMES.Sky then
            table.insert(templates, child:Clone())
        end
    end
    return templates
end

local function clearAllSkies()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then
            child:Destroy()
        end
    end
end

local function clearNonManagedSkies()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") and child.Name ~= MANAGED_NAMES.Sky then
            child:Destroy()
        end
    end
end

local function restoreSavedSky()
    clearAllSkies()
    if not savedState or not savedState.SkyTemplates then
        return
    end

    for _, template in ipairs(savedState.SkyTemplates) do
        local clone = template:Clone()
        clone.Parent = Lighting
    end
end

local function resolveAssetContent(path)
    if type(path) ~= "string" or path == "" then
        return nil
    end

    if path:match("^rbxassetid://") or path:match("^rbxasset://") or path:match("^https?://") then
        return path
    end

    local resolvers = {}
    if type(getcustomasset) == "function" then
        table.insert(resolvers, getcustomasset)
    end
    if type(getsynasset) == "function" then
        table.insert(resolvers, getsynasset)
    end
    if syn and type(syn.asset) == "function" then
        table.insert(resolvers, syn.asset)
    end

    for _, resolver in ipairs(resolvers) do
        local ok, content = pcall(resolver, path)
        if ok and type(content) == "string" and #content > 0 then
            return content
        end
    end

    return nil
end

local function ensureManagedSky()
    local existing = Lighting:FindFirstChild(MANAGED_NAMES.Sky)
    if existing and existing:IsA("Sky") then
        return existing
    end

    if existing then
        existing:Destroy()
    end

    local sky = Instance.new("Sky")
    sky.Name = MANAGED_NAMES.Sky
    sky.Parent = Lighting
    return sky
end

local function findSkyInInstance(root)
    if not root then
        return nil
    end

    if root:IsA("Sky") then
        return root
    end

    for _, descendant in ipairs(root:GetDescendants()) do
        if descendant:IsA("Sky") then
            return descendant
        end
    end

    return nil
end

local function loadSkyTemplateFromAsset(assetId)
    if type(assetId) ~= "number" then
        return nil
    end

    if skyAssetCache[assetId] then
        return skyAssetCache[assetId]:Clone()
    end

    local loader = game.GetObjects or getobjects
    if type(loader) ~= "function" then
        return nil
    end

    local ok, objects = pcall(loader, game, "rbxassetid://" .. tostring(assetId))
    if not ok or type(objects) ~= "table" then
        ok, objects = pcall(loader, "rbxassetid://" .. tostring(assetId))
    end
    if not ok or type(objects) ~= "table" then
        return nil
    end

    for _, object in ipairs(objects) do
        local foundSky = findSkyInInstance(object)
        if foundSky then
            local template = foundSky:Clone()
            skyAssetCache[assetId] = template
            return template:Clone()
        end
    end

    return nil
end

local function disconnectAutofocus()
    if focusConnection then
        focusConnection:Disconnect()
        focusConnection = nil
    end
end

local function disconnectReflectionRefresh()
    if reflectionRefreshConnection then
        reflectionRefreshConnection:Disconnect()
        reflectionRefreshConnection = nil
    end
end

local function disconnectAutoExposure()
    if autoExposureConnection then
        autoExposureConnection:Disconnect()
        autoExposureConnection = nil
    end
end

local function disconnectLocalLightInfluence()
    if localLightInfluenceConnection then
        localLightInfluenceConnection:Disconnect()
        localLightInfluenceConnection = nil
    end
end

disconnectLocalLightCache = function()
    if localLightAddedConnection then
        localLightAddedConnection:Disconnect()
        localLightAddedConnection = nil
    end

    if localLightRemovingConnection then
        localLightRemovingConnection:Disconnect()
        localLightRemovingConnection = nil
    end

    localLightCache = {}
    localLightCacheIndex = {}
    localLightScanOffset = 1
end

local function restoreReflections()
    for part, originalReflectance in pairs(reflectedParts) do
        if part and part.Parent then
            pcall(function()
                part.Reflectance = originalReflectance
            end)
        end
    end

    reflectedParts = {}
end

local function restoreOriginalState()
    if not savedState then
        return
    end

    applyProperties(Lighting, savedState.Lighting)
    applyProperties(Terrain, savedState.Terrain)
    restoreSavedSky()
end

local function destroyManagedEffects()
    disconnectAutofocus()
    disconnectReflectionRefresh()
    disconnectAutoExposure()
    disconnectLocalLightInfluence()
    disconnectLocalLightCache()
    restoreReflections()
    local cinemaOverlay = PlayerGui:FindFirstChild(CINEMA_OVERLAY_NAME)
    if cinemaOverlay then
        cinemaOverlay:Destroy()
    end

    for _, name in pairs(MANAGED_NAMES) do
        local parent = name == MANAGED_NAMES.Clouds and Terrain or Lighting
        local child = parent:FindFirstChild(name)
        if child then
            child:Destroy()
        end
    end

    effectRefs = {}
end

local function ensureLightingEffect(className, name)
    local existing = Lighting:FindFirstChild(name)
    if existing and existing.ClassName == className then
        return existing
    end

    if existing then
        existing:Destroy()
    end

    local success, effect = pcall(Instance.new, className)
    if not success or not effect then
        return nil
    end
    effect.Name = name
    effect.Parent = Lighting

    if effect:IsA("PostEffect") then
        effect.Enabled = true
    end

    return effect
end

local function ensureClouds()
    local clouds = Terrain:FindFirstChild(MANAGED_NAMES.Clouds)
    if clouds and clouds:IsA("Clouds") then
        return clouds
    end

    if clouds then
        clouds:Destroy()
    end

    clouds = Instance.new("Clouds")
    clouds.Name = MANAGED_NAMES.Clouds
    clouds.Parent = Terrain
    return clouds
end

local function makeOverlayEdge(parent, name, position, size, rotation, opacity)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = math.clamp(1 - opacity, 0, 1)
    frame.BorderSizePixel = 0
    frame.Position = position
    frame.Size = size
    frame.ZIndex = 999
    frame.Parent = parent

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = rotation
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.72, 0.62),
        NumberSequenceKeypoint.new(1, 1),
    })
    gradient.Parent = frame

    return frame
end

local function applyCinemaOverlay()
    local cfg = currentConfig.CinemaOverlay
    local existing = PlayerGui:FindFirstChild(CINEMA_OVERLAY_NAME)

    if not cfg or not cfg.Enabled then
        if existing then
            existing:Destroy()
        end
        return
    end

    local gui = existing
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = CINEMA_OVERLAY_NAME
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 999999
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = PlayerGui
    end

    gui:ClearAllChildren()

    local edgeSize = math.clamp(cfg.EdgeSize or 0.18, 0.05, 0.42)
    local vignetteOpacity = math.clamp(cfg.VignetteOpacity or 0.2, 0, 0.72)
    local letterboxOpacity = math.clamp(cfg.LetterboxOpacity or 0, 0, 0.6)

    makeOverlayEdge(gui, "VignetteLeft", UDim2.fromScale(0, 0), UDim2.fromScale(edgeSize, 1), 0, vignetteOpacity)
    makeOverlayEdge(gui, "VignetteRight", UDim2.fromScale(1 - edgeSize, 0), UDim2.fromScale(edgeSize, 1), 180, vignetteOpacity)
    makeOverlayEdge(gui, "VignetteTop", UDim2.fromScale(0, 0), UDim2.fromScale(1, edgeSize), 90, vignetteOpacity * 0.76)
    makeOverlayEdge(gui, "VignetteBottom", UDim2.fromScale(0, 1 - edgeSize), UDim2.fromScale(1, edgeSize), 270, vignetteOpacity * 0.76)

    if letterboxOpacity > 0 then
        local barHeight = 0.035
        local topBar = Instance.new("Frame")
        topBar.Name = "LetterboxTop"
        topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        topBar.BackgroundTransparency = 1 - letterboxOpacity
        topBar.BorderSizePixel = 0
        topBar.Size = UDim2.fromScale(1, barHeight)
        topBar.ZIndex = 1000
        topBar.Parent = gui

        local bottomBar = topBar:Clone()
        bottomBar.Name = "LetterboxBottom"
        bottomBar.Position = UDim2.fromScale(0, 1 - barHeight)
        bottomBar.Parent = gui
    end
end

local function collectCharacterModels()
    local models = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            table.insert(models, player.Character)
        end
    end
    return models
end

local function isCharacterPart(part)
    local model = part:FindFirstAncestorOfClass("Model")
    return model and model:FindFirstChildOfClass("Humanoid") ~= nil
end

local function lerpColor(a, b, alpha)
    return Color3.new(
        a.R + (b.R - a.R) * alpha,
        a.G + (b.G - a.G) * alpha,
        a.B + (b.B - a.B) * alpha
    )
end

local function getLightWorldPosition(light)
    local parent = light.Parent
    if not parent then
        return nil
    end

    if parent:IsA("Attachment") then
        return parent.WorldPosition
    end

    if parent:IsA("BasePart") then
        return parent.Position
    end

    if parent:IsA("Model") then
        local primary = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
        return primary and primary.Position or nil
    end

    return nil
end

local function readLightNumber(light, key, fallback)
    local ok, value = pcall(function()
        return light[key]
    end)
    if ok and type(value) == "number" then
        return value
    end
    return fallback
end

local function isSupportedLight(instance)
    return instance:IsA("PointLight") or instance:IsA("SpotLight") or instance:IsA("SurfaceLight")
end

local function trackLocalLight(instance)
    if localLightCacheIndex[instance] or not isSupportedLight(instance) then
        return
    end

    table.insert(localLightCache, instance)
    localLightCacheIndex[instance] = #localLightCache
end

local function untrackLocalLight(instance)
    local index = localLightCacheIndex[instance]
    if not index then
        return
    end

    local last = localLightCache[#localLightCache]
    localLightCache[index] = last
    if last then
        localLightCacheIndex[last] = index
    end

    localLightCache[#localLightCache] = nil
    localLightCacheIndex[instance] = nil
end

local function startLocalLightCache()
    disconnectLocalLightCache()

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        trackLocalLight(descendant)
    end

    localLightAddedConnection = Workspace.DescendantAdded:Connect(function(instance)
        trackLocalLight(instance)
    end)

    localLightRemovingConnection = Workspace.DescendantRemoving:Connect(function(instance)
        untrackLocalLight(instance)
    end)
end

local function sampleLocalLightInfluence(origin)
    local cfg = currentConfig.LocalLightInfluence
    local samples = {}
    local lightCount = #localLightCache
    if lightCount == 0 then
        return {
            Strength = 0,
            Color = Color3.fromRGB(255, 255, 255),
            ExposureOffset = 0,
            BloomOffset = 0,
            ReflectionBoost = 0,
        }
    end

    local scanBudget = math.min(lightCount, math.max(1, math.floor(cfg.ScanBudget or 140)))
    local startIndex = math.clamp(localLightScanOffset, 1, lightCount)
    for scanIndex = 1, scanBudget do
        local index = ((startIndex + scanIndex - 2) % lightCount) + 1
        local descendant = localLightCache[index]
        if descendant and descendant.Parent and descendant.Enabled then
            local position = getLightWorldPosition(descendant)
            if position then
                local range = math.max(readLightNumber(descendant, "Range", cfg.Radius * 0.55), 1)
                local distance = (position - origin).Magnitude
                if distance <= cfg.Radius and distance <= range then
                    local brightness = math.max(readLightNumber(descendant, "Brightness", 1), 0)
                    local rangeAlpha = 1 - math.clamp(distance / range, 0, 1)
                    local typeWeight = descendant:IsA("PointLight") and 1 or (descendant:IsA("SpotLight") and 0.88 or 0.72)
                    local weight = (rangeAlpha ^ 2) * math.clamp(brightness / 2.6, 0.08, 2.2) * typeWeight

                    if weight > 0.003 then
                        table.insert(samples, {
                            Color = descendant.Color,
                            Weight = weight,
                        })
                    end
                end
            end
        end
    end
    localLightScanOffset = ((startIndex + scanBudget - 1) % lightCount) + 1

    table.sort(samples, function(a, b)
        return a.Weight > b.Weight
    end)

    local totalWeight = 0
    local r, g, b = 0, 0, 0
    local maxLights = math.min(#samples, cfg.MaxLights or 24)
    for index = 1, maxLights do
        local sample = samples[index]
        totalWeight += sample.Weight
        r += sample.Color.R * sample.Weight
        g += sample.Color.G * sample.Weight
        b += sample.Color.B * sample.Weight
    end

    if totalWeight <= 0 then
        return {
            Strength = 0,
            Color = Color3.fromRGB(255, 255, 255),
            ExposureOffset = 0,
            BloomOffset = 0,
            ReflectionBoost = 0,
        }
    end

    local strength = math.clamp(totalWeight / 2.4, 0, 1)
    local color = Color3.new(r / totalWeight, g / totalWeight, b / totalWeight)
    local brightness = (color.R + color.G + color.B) / 3

    return {
        Strength = strength,
        Color = color,
        ExposureOffset = math.clamp((brightness - 0.5) * cfg.ExposureStrength * strength, -0.04, 0.07),
        BloomOffset = cfg.BloomStrength * strength,
        ReflectionBoost = cfg.ReflectionBoost * strength,
    }
end

local function applyLocalLightRuntime()
    local cfg = currentConfig.LocalLightInfluence
    local strength = cfg.Enabled and localLightState.Strength or 0

    if effectRefs.ColorCorrection then
        local tintAlpha = math.clamp(strength * cfg.TintStrength, 0, 0.32)
        effectRefs.ColorCorrection.TintColor = lerpColor(currentConfig.ColorCorrection.TintColor, localLightState.Color, tintAlpha)
        effectRefs.ColorCorrection.Brightness = currentConfig.ColorCorrection.Brightness + localLightState.ExposureOffset
        effectRefs.ColorCorrection.Saturation = currentConfig.ColorCorrection.Saturation + math.clamp(strength * 0.025, 0, 0.04)
    end

    if effectRefs.Bloom then
        effectRefs.Bloom.Intensity = currentConfig.Bloom.Intensity + localLightState.BloomOffset
        effectRefs.Bloom.Threshold = math.max(0.65, currentConfig.Bloom.Threshold - strength * 0.16)
    end
end

local function resetLocalLightState()
    localLightState.Strength = 0
    localLightState.Color = Color3.fromRGB(255, 255, 255)
    localLightState.ExposureOffset = 0
    localLightState.BloomOffset = 0
    localLightState.ReflectionBoost = 0
    localLightRuntimeWasEnabled = false
    applyLocalLightRuntime()
end

local function getDominantSurfaceNormal(part, cameraPosition)
    local halfSize = part.Size * 0.5
    local localCamera = part.CFrame:PointToObjectSpace(cameraPosition)

    local xScore = math.abs(localCamera.X) / math.max(halfSize.X, 0.001)
    local yScore = math.abs(localCamera.Y) / math.max(halfSize.Y, 0.001)
    local zScore = math.abs(localCamera.Z) / math.max(halfSize.Z, 0.001)

    local localNormal
    if xScore >= yScore and xScore >= zScore then
        localNormal = Vector3.new(localCamera.X >= 0 and 1 or -1, 0, 0)
    elseif yScore >= zScore then
        localNormal = Vector3.new(0, localCamera.Y >= 0 and 1 or -1, 0)
    else
        localNormal = Vector3.new(0, 0, localCamera.Z >= 0 and 1 or -1)
    end

    return part.CFrame:VectorToWorldSpace(localNormal).Unit
end

local function getTargetReflectance(part, cameraPosition)
    if isCharacterPart(part) then
        return nil, nil, nil
    end

    if part.Transparency >= currentConfig.Reflections.MaxTransparency then
        return nil, nil, nil
    end

    if part.Size.Magnitude < currentConfig.Reflections.MinPartSize then
        return nil, nil, nil
    end

    local baseReflectance = currentConfig.Reflections.MaterialReflectance[part.Material] or currentConfig.Reflections.DefaultReflectance
    local strength = currentConfig.Reflections.Multiplier * (1 + (localLightState.ReflectionBoost or 0))
    local offset = part.Position - cameraPosition
    local distance = offset.Magnitude
    local distanceAlpha = 1 - math.clamp(distance / currentConfig.Reflections.Radius, 0, 1)

    local viewDirection = distance > 0 and (cameraPosition - part.Position).Unit or Vector3.new(0, 1, 0)
    local surfaceNormal = getDominantSurfaceNormal(part, cameraPosition)
    local facing = math.clamp(surfaceNormal:Dot(viewDirection), 0, 1)
    local fresnel = (1 - facing) ^ (currentConfig.Reflections.FresnelPower or 1.35)
    local angularAlpha = 0.58 + fresnel * (currentConfig.Reflections.AngularBoost or 0.85)
    local sizeAlpha = math.clamp(part.Size.Magnitude / 16, 0.72, 1.2)

    local scaledReflectance = baseReflectance * strength * (0.62 + distanceAlpha * 0.38) * angularAlpha * sizeAlpha
    local score = scaledReflectance * (0.65 + distanceAlpha * 0.35) * sizeAlpha

    return math.clamp(scaledReflectance, baseReflectance * 0.45, currentConfig.Reflections.MaxReflectance or 0.32), distance, score
end

local function refreshPseudoReflections()
    if not currentConfig.Reflections.Enabled then
        restoreReflections()
        return
    end

    local camera = Workspace.CurrentCamera
    if not camera then
        return
    end

    local cameraPosition = camera.CFrame.Position
    local maxParts = math.min(1400, math.max(1, math.floor(currentConfig.Reflections.MaxParts or 160)))
    local queryMaxParts = math.min(2600, math.max(
        maxParts,
        math.floor(currentConfig.Reflections.QueryMaxParts or (maxParts * (currentConfig.Reflections.SelectionMultiplier or 1.7)))
    ))
    local nearMaxParts = math.clamp(
        math.floor(currentConfig.Reflections.NearMaxParts or math.floor(maxParts * 0.8)),
        1,
        queryMaxParts
    )
    local excludedModels = collectCharacterModels()
    local nearCoverageRadius = currentConfig.Reflections.NearCoverageRadius or 0

    local nearParams = OverlapParams.new()
    nearParams.FilterType = Enum.RaycastFilterType.Exclude
    nearParams.FilterDescendantsInstances = excludedModels
    nearParams.MaxParts = nearMaxParts

    local farParams = OverlapParams.new()
    farParams.FilterType = Enum.RaycastFilterType.Exclude
    farParams.FilterDescendantsInstances = excludedModels
    farParams.MaxParts = queryMaxParts

    local nearbyParts = nearCoverageRadius > 0 and Workspace:GetPartBoundsInRadius(
        cameraPosition,
        nearCoverageRadius,
        nearParams
    ) or {}

    local farParts = Workspace:GetPartBoundsInRadius(
        cameraPosition,
        currentConfig.Reflections.Radius,
        farParams
    )

    local candidates = {}
    local nearCandidates = {}
    local farCandidates = {}
    local seenParts = {}

    for _, part in ipairs(nearbyParts) do
        seenParts[part] = true
        local targetReflectance, distance, score = getTargetReflectance(part, cameraPosition)
        if targetReflectance then
            local entry = {
                Part = part,
                Distance = distance,
                Score = score or 0,
                Reflectance = targetReflectance,
            }

            table.insert(nearCandidates, entry)
        end
    end

    for _, part in ipairs(farParts) do
        if not seenParts[part] then
            local targetReflectance, distance, score = getTargetReflectance(part, cameraPosition)
            if targetReflectance then
                table.insert(farCandidates, {
                    Part = part,
                    Distance = distance,
                    Score = score or 0,
                    Reflectance = targetReflectance,
                })
            end
        end
    end

    table.sort(nearCandidates, function(a, b)
        if a.Distance == b.Distance then
            return a.Score > b.Score
        end
        return a.Distance < b.Distance
    end)

    table.sort(farCandidates, function(a, b)
        if a.Score == b.Score then
            return a.Distance < b.Distance
        end
        return a.Score > b.Score
    end)

    for _, entry in ipairs(nearCandidates) do
        table.insert(candidates, entry)
    end

    for _, entry in ipairs(farCandidates) do
        table.insert(candidates, entry)
    end

    local activeParts = {}
    local activeCount = math.min(#candidates, maxParts)
    for index = 1, activeCount do
        local entry = candidates[index]
        activeParts[entry.Part] = true

        if reflectedParts[entry.Part] == nil then
            reflectedParts[entry.Part] = entry.Part.Reflectance
        end

        pcall(function()
            entry.Part.Reflectance = math.max(reflectedParts[entry.Part], entry.Reflectance)
        end)
    end

    for part, originalReflectance in pairs(reflectedParts) do
        if (not activeParts[part]) or (not part) or (not part.Parent) then
            if part and part.Parent then
                pcall(function()
                    part.Reflectance = originalReflectance
                end)
            end
            reflectedParts[part] = nil
        end
    end
end

local function requestReflectionRefresh()
    if reflectionRefreshQueued then
        return
    end

    reflectionRefreshQueued = true
    task.defer(function()
        reflectionRefreshQueued = false
        if isEnabled then
            refreshPseudoReflections()
        end
    end)
end

local function startReflectionRefresh()
    disconnectReflectionRefresh()
    requestReflectionRefresh()

    local elapsed = 0
    local forcedElapsed = 0
    local lastCameraPosition = nil
    local lastCameraLook = nil
    local lastReflectionBoost = localLightState.ReflectionBoost or 0

    reflectionRefreshConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not currentConfig.Reflections.Enabled then
            return
        end

        elapsed += deltaTime
        forcedElapsed += deltaTime

        local interval = currentConfig.Reflections.RefreshInterval or 1
        if elapsed < interval then
            return
        end

        local camera = Workspace.CurrentCamera
        if not camera then
            elapsed = 0
            return
        end

        local cameraPosition = camera.CFrame.Position
        local cameraLook = camera.CFrame.LookVector
        local moved = not lastCameraPosition
            or (cameraPosition - lastCameraPosition).Magnitude >= (currentConfig.Reflections.MinCameraMoveForRefresh or 7)
        local turned = not lastCameraLook
            or (1 - math.clamp(cameraLook:Dot(lastCameraLook), -1, 1)) >= (currentConfig.Reflections.MinCameraLookDeltaForRefresh or 0.035)
        local boostChanged = math.abs((localLightState.ReflectionBoost or 0) - lastReflectionBoost)
            >= (currentConfig.Reflections.MinLightBoostRefreshDelta or 0.035)
        local forced = forcedElapsed >= (currentConfig.Reflections.ForceRefreshInterval or 4)

        if moved or turned or boostChanged or forced then
            elapsed = 0
            forcedElapsed = 0
            lastCameraPosition = cameraPosition
            lastCameraLook = cameraLook
            lastReflectionBoost = localLightState.ReflectionBoost or 0
            refreshPseudoReflections()
        else
            elapsed = interval * 0.55
        end
    end)
end

local function startAutofocus()
    disconnectAutofocus()

    local depthOfField = effectRefs.DepthOfField
    if not depthOfField then
        return
    end

    local currentFocus = currentConfig.DepthOfField.FocusDistance
    local targetFocus = currentFocus
    local elapsed = 0

    focusConnection = RunService.RenderStepped:Connect(function(deltaTime)
        local camera = Workspace.CurrentCamera
        if not camera or not depthOfField or depthOfField.Parent ~= Lighting then
            return
        end

        if not currentConfig.DepthOfField.Enabled then
            return
        end

        if not currentConfig.Autofocus.Enabled then
            targetFocus = currentConfig.DepthOfField.FocusDistance
            currentFocus = currentFocus + (targetFocus - currentFocus) * 0.12
            depthOfField.FocusDistance = currentFocus
            return
        end

        elapsed = elapsed + deltaTime
        if elapsed >= currentConfig.Autofocus.UpdateInterval then
            elapsed = 0

            local raycastParams = RaycastParams.new()
            raycastParams.IgnoreWater = false
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = LocalPlayer.Character and { LocalPlayer.Character } or {}

            local result = Workspace:Raycast(
                camera.CFrame.Position,
                camera.CFrame.LookVector * currentConfig.Autofocus.MaxDistance,
                raycastParams
            )

            if result then
                targetFocus = math.clamp(
                    result.Distance,
                    currentConfig.Autofocus.MinDistance,
                    currentConfig.Autofocus.MaxDistance
                )
            else
                targetFocus = currentConfig.DepthOfField.FocusDistance
            end
        end

        currentFocus = currentFocus + (targetFocus - currentFocus) * currentConfig.Autofocus.LerpAlpha
        depthOfField.FocusDistance = currentFocus
    end)
end

local function startAutoExposure()
    disconnectAutoExposure()

    local currentExposure = currentConfig.Lighting.ExposureCompensation or Lighting.ExposureCompensation
    local elapsed = currentConfig.AutoExposure.UpdateInterval

    autoExposureConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not currentConfig.AutoExposure.Enabled then
            return
        end

        local camera = Workspace.CurrentCamera
        if not camera then
            return
        end

        elapsed += deltaTime
        if elapsed < currentConfig.AutoExposure.UpdateInterval then
            return
        end
        elapsed = 0

        local raycastParams = RaycastParams.new()
        raycastParams.IgnoreWater = true
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = LocalPlayer.Character and { LocalPlayer.Character } or {}

        local ceilingHit = Workspace:Raycast(camera.CFrame.Position, Vector3.new(0, 260, 0), raycastParams)
        local skyVisible = ceilingHit and 0 or 1
        local skyLookAlpha = math.clamp((camera.CFrame.LookVector.Y + 0.15) / 1.15, 0, 1)
        local brightSkyAlpha = skyVisible * (0.35 + skyLookAlpha * 0.65)
        local indoorAlpha = 1 - skyVisible

        local baseExposure = currentConfig.Lighting.ExposureCompensation or 0
        local targetExposure = baseExposure
            + indoorAlpha * currentConfig.AutoExposure.IndoorLift
            - brightSkyAlpha * currentConfig.AutoExposure.SkyDarkening

        targetExposure = math.clamp(
            targetExposure,
            currentConfig.AutoExposure.MinExposure,
            currentConfig.AutoExposure.MaxExposure
        )

        local lerpAlpha = math.clamp(currentConfig.AutoExposure.AdaptSpeed * currentConfig.AutoExposure.UpdateInterval * 60, 0, 1)
        currentExposure = currentExposure + (targetExposure - currentExposure) * lerpAlpha
        Lighting.ExposureCompensation = currentExposure
    end)
end

local function startLocalLightInfluence()
    disconnectLocalLightInfluence()
    resetLocalLightState()

    if not currentConfig.LocalLightInfluence.Enabled then
        disconnectLocalLightCache()
        return
    end

    startLocalLightCache()

    local elapsed = currentConfig.LocalLightInfluence.UpdateInterval
    localLightInfluenceConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not currentConfig.LocalLightInfluence.Enabled then
            if localLightRuntimeWasEnabled or localLightState.Strength > 0.001 then
                resetLocalLightState()
            end
            disconnectLocalLightCache()
            return
        end

        localLightRuntimeWasEnabled = true

        local camera = Workspace.CurrentCamera
        if not camera then
            return
        end

        elapsed += deltaTime
        if elapsed >= currentConfig.LocalLightInfluence.UpdateInterval then
            elapsed = 0

            local target = sampleLocalLightInfluence(camera.CFrame.Position)
            local alpha = math.clamp(currentConfig.LocalLightInfluence.AdaptSpeed, 0.01, 1)

            localLightState.Strength += (target.Strength - localLightState.Strength) * alpha
            localLightState.Color = lerpColor(localLightState.Color, target.Color, alpha)
            localLightState.ExposureOffset += (target.ExposureOffset - localLightState.ExposureOffset) * alpha
            localLightState.BloomOffset += (target.BloomOffset - localLightState.BloomOffset) * alpha
            localLightState.ReflectionBoost += (target.ReflectionBoost - localLightState.ReflectionBoost) * alpha
            applyLocalLightRuntime()
        end
    end)
end

applyRuntimeConfig = function()
    if not isEnabled then
        return
    end

    safeSetTechnology(Enum.Technology.Future)
    applyProperties(Lighting, currentConfig.Lighting)
    applyProperties(Terrain, currentConfig.Terrain)

    if effectRefs.ColorCorrection then
        applyProperties(effectRefs.ColorCorrection, currentConfig.ColorCorrection)
        effectRefs.ColorCorrection.Enabled = true
    end

    if effectRefs.ColorGrading then
        applyProperties(effectRefs.ColorGrading, currentConfig.ColorGrading)
        effectRefs.ColorGrading.Enabled = currentConfig.ColorGrading.Enabled
    end

    if effectRefs.Bloom then
        applyProperties(effectRefs.Bloom, currentConfig.Bloom)
        effectRefs.Bloom.Enabled = true
    end

    if effectRefs.SunRays then
        applyProperties(effectRefs.SunRays, currentConfig.SunRays)
        effectRefs.SunRays.Enabled = true
    end

    if effectRefs.Atmosphere then
        applyProperties(effectRefs.Atmosphere, currentConfig.Atmosphere)
    end

    if effectRefs.DepthOfField then
        applyProperties(effectRefs.DepthOfField, currentConfig.DepthOfField)
        effectRefs.DepthOfField.Enabled = currentConfig.DepthOfField.Enabled
    end

    if currentConfig.Clouds.Enabled then
        effectRefs.Clouds = ensureClouds()
        effectRefs.Clouds.Cover = currentConfig.Clouds.Cover
        effectRefs.Clouds.Density = currentConfig.Clouds.Density
        effectRefs.Clouds.Color = currentConfig.Clouds.Color
    else
        local existingClouds = Terrain:FindFirstChild(MANAGED_NAMES.Clouds)
        if existingClouds then
            existingClouds:Destroy()
        end
        effectRefs.Clouds = nil
    end

    if currentConfig.Sky and currentConfig.Sky.Enabled then
        local loadedManagedSky = nil

        if currentConfig.Sky.AssetId then
            loadedManagedSky = loadSkyTemplateFromAsset(currentConfig.Sky.AssetId)
        end

        if loadedManagedSky then
            clearNonManagedSkies()
            local existingManagedSky = Lighting:FindFirstChild(MANAGED_NAMES.Sky)
            if existingManagedSky then
                existingManagedSky:Destroy()
            end
            loadedManagedSky.Name = MANAGED_NAMES.Sky
            loadedManagedSky.Parent = Lighting

            local sky = loadedManagedSky
            sky.CelestialBodiesShown = currentConfig.Sky.CelestialBodiesShown
            sky.StarCount = currentConfig.Sky.StarCount
            effectRefs.Sky = sky
        else
            local resolvedContent = {}
            local hasAllFaces = true

            for _, key in ipairs(SKYBOX_KEYS) do
                local content = resolveAssetContent(currentConfig.Sky[key])
                if not content then
                    hasAllFaces = false
                    break
                end
                resolvedContent[key] = content
            end

            if hasAllFaces then
                clearNonManagedSkies()

                local sky = ensureManagedSky()
                sky.CelestialBodiesShown = currentConfig.Sky.CelestialBodiesShown
                sky.StarCount = currentConfig.Sky.StarCount

                for key, content in pairs(resolvedContent) do
                    sky[key] = content
                end

                effectRefs.Sky = sky
            else
                effectRefs.Sky = nil
                restoreSavedSky()
            end
        end
    else
        effectRefs.Sky = nil
        restoreSavedSky()
    end

    applyCinemaOverlay()
    requestReflectionRefresh()

    if not currentConfig.AutoExposure.Enabled then
        Lighting.ExposureCompensation = currentConfig.Lighting.ExposureCompensation
    end

    if not currentConfig.LocalLightInfluence.Enabled then
        disconnectLocalLightInfluence()
        disconnectLocalLightCache()
        resetLocalLightState()
    else
        if not localLightInfluenceConnection then
            startLocalLightInfluence()
        else
            applyLocalLightRuntime()
        end
    end
end

local function updateStatusLabels()
    if uiRefs.StatusValue then
        uiRefs.StatusValue.Text = isEnabled and "ON" or "OFF"
        uiRefs.StatusValue.TextColor3 = isEnabled and THEME.Positive or THEME.Danger
    end

    if uiRefs.StatusChip then
        setGlassVisual(uiRefs.StatusChip, {
            BackgroundTransparency = isEnabled and 0.14 or 0.28,
            BlurTint = isEnabled and Color3.fromRGB(234, 240, 238) or Color3.fromRGB(248, 241, 241),
            BorderTransparency = isEnabled and 0.18 or 0.26,
        })
    end

    if uiRefs.PresetValue then
        uiRefs.PresetValue.Text = string.upper(selectedPresetName or "CUSTOM")
        uiRefs.PresetValue.TextColor3 = THEME.Text
    end

    if uiRefs.ShaderActionTitle then
        uiRefs.ShaderActionTitle.Text = isEnabled and "POWER OFF" or "POWER ON"
    end
end

enableRTX = function()
    if isEnabled then
        return
    end

    destroyManagedEffects()

    savedState = {
        Lighting = snapshotProperties(Lighting, LIGHTING_KEYS),
        Terrain = snapshotProperties(Terrain, TERRAIN_KEYS),
        SkyTemplates = captureSkyTemplates(),
    }

    effectRefs.ColorCorrection = ensureLightingEffect("ColorCorrectionEffect", MANAGED_NAMES.ColorCorrection)
    effectRefs.ColorGrading = ensureLightingEffect("ColorGradingEffect", MANAGED_NAMES.ColorGrading)
    effectRefs.Bloom = ensureLightingEffect("BloomEffect", MANAGED_NAMES.Bloom)
    effectRefs.SunRays = ensureLightingEffect("SunRaysEffect", MANAGED_NAMES.SunRays)
    effectRefs.Atmosphere = ensureLightingEffect("Atmosphere", MANAGED_NAMES.Atmosphere)
    effectRefs.DepthOfField = ensureLightingEffect("DepthOfFieldEffect", MANAGED_NAMES.DepthOfField)

    isEnabled = true
    applyRuntimeConfig()
    startAutofocus()
    startReflectionRefresh()
    startAutoExposure()
    startLocalLightInfluence()
    updateStatusLabels()
end

disableRTX = function()
    if not isEnabled then
        return
    end

    destroyManagedEffects()
    restoreOriginalState()

    savedState = nil
    isEnabled = false
    updateStatusLabels()
end

local function registerRefresher(refresh)
    table.insert(controlRefreshers, refresh)
    refresh()
end

refreshAllControls = function()
    for _, refresh in ipairs(controlRefreshers) do
        pcall(refresh)
    end
    updateStatusLabels()
end

local function applyGlassTexture(frame, intensity)
    local alpha = intensity or 0.92

    local topEdge = Instance.new("Frame")
    topEdge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topEdge.BackgroundTransparency = alpha
    topEdge.BorderSizePixel = 0
    topEdge.Size = UDim2.new(1, 0, 0, 1)
    topEdge.Parent = frame

    local sheen = Instance.new("Frame")
    sheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sheen.BackgroundTransparency = 1
    sheen.BorderSizePixel = 0
    sheen.Size = UDim2.new(1.1, 0, 1.1, 0)
    sheen.Position = UDim2.new(-0.05, 0, -0.05, 0)
    sheen.Parent = frame

    local sheenGradient = Instance.new("UIGradient")
    sheenGradient.Rotation = 18
    sheenGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.35, 0.98),
        NumberSequenceKeypoint.new(0.5, 0.9),
        NumberSequenceKeypoint.new(0.62, 0.98),
        NumberSequenceKeypoint.new(1, 1),
    })
    sheenGradient.Parent = sheen

    local verticalTrace = Instance.new("Frame")
    verticalTrace.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    verticalTrace.BackgroundTransparency = 0.97
    verticalTrace.BorderSizePixel = 0
    verticalTrace.Position = UDim2.new(0, 18, 0, 0)
    verticalTrace.Size = UDim2.new(0, 1, 1, 0)
    verticalTrace.Parent = frame

    local horizontalTrace = Instance.new("Frame")
    horizontalTrace.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    horizontalTrace.BackgroundTransparency = 0.975
    horizontalTrace.BorderSizePixel = 0
    horizontalTrace.Position = UDim2.new(0, 0, 0, 18)
    horizontalTrace.Size = UDim2.new(1, 0, 0, 1)
    horizontalTrace.Parent = frame
end

local function styleCard(frame, color, textured)
    local baseColor = color or THEME.Surface
    frame.BackgroundColor3 = baseColor
    frame.BackgroundTransparency = 0.34
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Stroke
    stroke.Transparency = 0.6
    stroke.Thickness = 1
    stroke.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, baseColor:Lerp(Color3.new(1, 1, 1), 0.18)),
        ColorSequenceKeypoint.new(0.55, baseColor),
        ColorSequenceKeypoint.new(1, baseColor:Lerp(Color3.new(0, 0, 0), 0.03)),
    })
    gradient.Parent = frame

    if textured then
        applyGlassTexture(frame, 0.9)
    end
end

local function styleButton(button, normalColor, hoverColor)
    button.AutoButtonColor = false
    button.BackgroundColor3 = normalColor
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 0
    button.ClipsDescendants = true

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Stroke
    stroke.Transparency = 0.58
    stroke.Parent = button

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, normalColor:Lerp(Color3.new(1, 1, 1), 0.16)),
        ColorSequenceKeypoint.new(0.55, normalColor),
        ColorSequenceKeypoint.new(1, normalColor:Lerp(Color3.new(0, 0, 0), 0.03)),
    })
    gradient.Parent = button

    applyGlassTexture(button, 0.92)

    local enterTween = TweenService:Create(
        button,
        TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { BackgroundColor3 = hoverColor, BackgroundTransparency = 0.18 }
    )

    local leaveTween = TweenService:Create(
        button,
        TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { BackgroundColor3 = normalColor, BackgroundTransparency = 0.3 }
    )

    button.MouseEnter:Connect(function()
        enterTween:Play()
    end)

    button.MouseLeave:Connect(function()
        leaveTween:Play()
    end)
end

local function destroyGlassRefs()
    for _, glass in ipairs(glassRefs) do
        pcall(function()
            glass:Destroy()
        end)
    end
    glassRefs = {}
end

local function resetAutoHeightUpdaters()
    autoHeightUpdaters = {}
end

local function createLiquidPanel(options, interactive)
    if not LiquidGlass then
        return nil
    end

    local glass = LiquidGlass.new(options)
    local inputCapture = glass:GetFrame():FindFirstChild("InputCapture")
    if inputCapture then
        local inputEnabled = interactive == true
        inputCapture.Visible = inputEnabled
        if inputCapture:IsA("GuiButton") then
            inputCapture.Active = inputEnabled
            inputCapture.Selectable = inputEnabled
        end
    end
    table.insert(glassRefs, glass)
    return glass
end

local function makeDraggable(frame, handle)
    if handle and handle:IsA("GuiObject") then
        handle.Active = true
    end

    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

local function makeGlassOptions(overrides)
    local options = {
        ZIndex = 20,
        CornerRadius = UDim.new(0, 0),
        BackgroundColor = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.52,
        BlurTint = Color3.fromRGB(246, 247, 250),
        BorderColor = Color3.fromRGB(255, 255, 255),
        BorderTransparency = 0.34,
        BorderThickness = 1,
        ShadowColor = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.99,
        ShadowOffset = Vector2.new(0, 6),
        ShadowSize = 3,
        Elasticity = 0,
        HoverHighlight = false,
        ClickScale = 1,
    }

    for key, value in pairs(overrides or {}) do
        options[key] = value
    end

    return options
end

setGlassVisual = function(glass, properties)
    if not glass then
        return
    end

    for key, value in pairs(properties) do
        glass:SetProperty(key, value)
    end
end

local function createGlassListItem(parent, height, layoutOrder, overrides, interactive)
    local host = Instance.new("Frame")
    host.BackgroundTransparency = 1
    host.BorderSizePixel = 0
    host.Size = UDim2.new(1, 0, 0, height)
    host.LayoutOrder = layoutOrder or 0
    host.Parent = parent

    local options = makeGlassOptions(overrides)
    options.Parent = host
    options.Size = UDim2.new(1, 0, 1, 0)
    options.Position = UDim2.new(0, 0, 0, 0)
    options.AnchorPoint = Vector2.new(0, 0)

    local glass = createLiquidPanel(options, interactive)
    local content = glass and glass:GetContentFrame() or host
    content.ClipsDescendants = true

    return host, glass, content
end

local function createGlassAbsolute(parent, position, size, overrides, interactive)
    local host = Instance.new("Frame")
    host.BackgroundTransparency = 1
    host.BorderSizePixel = 0
    host.Position = position
    host.Size = size
    host.Parent = parent

    local options = makeGlassOptions(overrides)
    options.Parent = host
    options.Size = UDim2.new(1, 0, 1, 0)
    options.Position = UDim2.new(0, 0, 0, 0)
    options.AnchorPoint = Vector2.new(0, 0)

    local glass = createLiquidPanel(options, interactive)
    local content = glass and glass:GetContentFrame() or host
    content.ClipsDescendants = true

    return host, glass, content
end

local function bindAutoHeight(host, layout, padding)
    local extra = padding or 0

    local function update()
        host.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + extra)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    table.insert(autoHeightUpdaters, update)
    update()
end

local function refreshAutoHeights()
    for _, update in ipairs(autoHeightUpdaters) do
        pcall(update)
    end
end

local function createSection(parent, title, subtitle, layoutOrder)
    local host, _, section = createGlassListItem(parent, 48, layoutOrder, {
        BackgroundTransparency = 0.58,
        BlurTint = Color3.fromRGB(244, 246, 249),
        BorderTransparency = 0.4,
        ShadowTransparency = 1,
        ShadowSize = 0,
    }, false)

    section.Name = title:gsub("%s+", "")

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = section

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = section

    local header = Instance.new("TextLabel")
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 16)
    header.LayoutOrder = 10
    header.Font = Enum.Font.GothamBold
    header.Text = string.upper(title)
    header.TextColor3 = THEME.Text
    header.TextSize = 11
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = section

    local divider = Instance.new("Frame")
    divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    divider.BackgroundTransparency = 0.9
    divider.BorderSizePixel = 0
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.LayoutOrder = 20
    divider.Parent = section

    bindAutoHeight(host, listLayout, 20)
    return section
end

local function createSlider(parent, title, subtitle, minValue, maxValue, decimals, getter, setter, layoutOrder)
    local _, _, row = createGlassListItem(parent, 54, 100 + (layoutOrder or 0), {
        BackgroundTransparency = 0.44,
        BlurTint = Color3.fromRGB(246, 247, 250),
        BorderTransparency = 0.32,
        ShadowTransparency = 1,
        ShadowSize = 0,
    }, false)

    local topRow = Instance.new("Frame")
    topRow.BackgroundTransparency = 1
    topRow.Position = UDim2.new(0, 12, 0, 8)
    topRow.Size = UDim2.new(1, -24, 0, 16)
    topRow.Parent = row

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0.72, 0, 1, 0)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Text = title
    titleLabel.TextColor3 = THEME.Text
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topRow

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.AnchorPoint = Vector2.new(1, 0)
    valueLabel.Position = UDim2.new(1, 0, 0, 0)
    valueLabel.Size = UDim2.new(0.28, 0, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextColor3 = THEME.Text
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = topRow

    local trackHost, _, track = createGlassAbsolute(row, UDim2.new(0, 12, 0, 31), UDim2.new(1, -24, 0, 10), {
        ZIndex = 34,
        BackgroundTransparency = 0.68,
        BlurTint = Color3.fromRGB(244, 246, 249),
        BorderTransparency = 0.58,
        BorderThickness = 0.8,
        ShadowTransparency = 1,
        ShadowSize = 0,
    }, false)
    track.ClipsDescendants = true

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BackgroundTransparency = 0.38
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.Parent = track

    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 233, 238)),
    })
    fillGradient.Parent = fill

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0.5, 0, 0.5, 0)
    knob.Size = UDim2.fromOffset(12, 12)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 0.06
    knob.BorderSizePixel = 0
    knob.Parent = track

    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = Color3.fromRGB(255, 255, 255)
    knobStroke.Transparency = 0.5
    knobStroke.Thickness = 1
    knobStroke.Parent = knob

    local dragging = false

    local function updateVisual()
        local currentValue = getter()
        local alpha = (currentValue - minValue) / (maxValue - minValue)
        alpha = math.clamp(alpha, 0, 1)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLabel.Text = formatValue(currentValue, decimals)
    end

    local function commitFromPosition(positionX)
        local alpha = math.clamp((positionX - trackHost.AbsolutePosition.X) / trackHost.AbsoluteSize.X, 0, 1)
        local value = minValue + (maxValue - minValue) * alpha
        value = roundTo(value, decimals)
        local wasPreset = selectedPresetName ~= "Custom"
        if value ~= getter() then
            selectedPresetName = "Custom"
        end
        setter(value)
        updateVisual()
        if wasPreset and selectedPresetName == "Custom" then
            refreshAllControls()
        end
    end

    trackHost.Active = true
    trackHost.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            commitFromPosition(input.Position.X)
        end
    end)

    trackHost.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            commitFromPosition(input.Position.X)
        end
    end)

    registerRefresher(updateVisual)
    return row
end

local function createToggle(parent, title, subtitle, getter, setter, layoutOrder)
    local _, _, row = createGlassListItem(parent, 42, 100 + (layoutOrder or 0), {
        BackgroundTransparency = 0.44,
        BlurTint = Color3.fromRGB(246, 247, 250),
        BorderTransparency = 0.32,
        ShadowTransparency = 1,
        ShadowSize = 0,
    }, false)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 12, 0, 10)
    titleLabel.Size = UDim2.new(1, -90, 0, 20)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Text = title
    titleLabel.TextColor3 = THEME.Text
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row

    local switchHost, switchGlass, switchContent = createGlassAbsolute(row, UDim2.new(1, -70, 0.5, -11), UDim2.fromOffset(58, 22), {
        ZIndex = 34,
        BackgroundTransparency = 0.36,
        BlurTint = Color3.fromRGB(246, 247, 250),
        BorderTransparency = 0.34,
        ShadowTransparency = 1,
        ShadowSize = 0,
        HoverHighlight = true,
        Elasticity = 0.02,
        ClickScale = 0.985,
        OnClick = function()
            local wasPreset = selectedPresetName ~= "Custom"
            selectedPresetName = "Custom"
            setter(not getter())
            if wasPreset then
                refreshAllControls()
            else
                syncAndRefresh()
            end
        end,
    }, true)

    local stateLabel = Instance.new("TextLabel")
    stateLabel.BackgroundTransparency = 1
    stateLabel.Position = UDim2.new(0, 8, 0, 0)
    stateLabel.Size = UDim2.new(1, -16, 1, 0)
    stateLabel.Font = Enum.Font.GothamBold
    stateLabel.TextSize = 10
    stateLabel.TextXAlignment = Enum.TextXAlignment.Center
    stateLabel.Parent = switchContent

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Size = UDim2.fromOffset(12, 12)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 0.04
    knob.BorderSizePixel = 0
    knob.Parent = switchContent

    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = Color3.fromRGB(255, 255, 255)
    knobStroke.Transparency = 0.48
    knobStroke.Thickness = 1
    knobStroke.Parent = knob

    local fallbackButton
    if not switchGlass then
        fallbackButton = Instance.new("TextButton")
        fallbackButton.BackgroundTransparency = 1
        fallbackButton.Size = UDim2.new(1, 0, 1, 0)
        fallbackButton.Text = ""
        fallbackButton.Parent = switchHost
        fallbackButton.Activated:Connect(function()
            local wasPreset = selectedPresetName ~= "Custom"
            selectedPresetName = "Custom"
            setter(not getter())
            if wasPreset then
                refreshAllControls()
            else
                syncAndRefresh()
            end
        end)
    end

    local function updateVisual()
        local enabled = getter()
        stateLabel.Text = enabled and "ON" or "OFF"
        stateLabel.TextColor3 = enabled and THEME.Text or THEME.Muted
        knob.Position = enabled and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)

        if switchGlass then
            setGlassVisual(switchGlass, {
                BackgroundTransparency = enabled and 0.12 or 0.38,
                BlurTint = enabled and Color3.fromRGB(234, 238, 244) or Color3.fromRGB(246, 247, 250),
                BorderTransparency = enabled and 0.18 or 0.42,
            })
        end
    end

    registerRefresher(updateVisual)
    return row
end

local function createSidebarAction(parent, title, subtitle, callback, accentColor, layoutOrder)
    local host, glass, content = createGlassListItem(parent, 32, 100 + (layoutOrder or 0), {
        BackgroundTransparency = 0.42,
        BlurTint = Color3.fromRGB(246, 247, 250),
        BorderTransparency = 0.3,
        ShadowTransparency = 1,
        ShadowSize = 0,
        HoverHighlight = true,
        Elasticity = 0.02,
        ClickScale = 0.985,
        OnClick = callback,
    }, true)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 7)
    titleLabel.Size = UDim2.new(1, -20, 0, 16)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = string.upper(title)
    titleLabel.TextColor3 = THEME.Text
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = content

    if not glass then
        local fallbackButton = Instance.new("TextButton")
        fallbackButton.BackgroundTransparency = 1
        fallbackButton.Size = UDim2.new(1, 0, 1, 0)
        fallbackButton.Text = ""
        fallbackButton.Parent = host
        fallbackButton.Activated:Connect(callback)
    end

    return {
        Host = host,
        Glass = glass,
        Title = titleLabel,
        Subtitle = nil,
    }
end

local function createInfoCard(parent, layoutOrder)
    local _, _, card = createGlassListItem(parent, 40, layoutOrder, {
        BackgroundTransparency = 0.5,
        BlurTint = Color3.fromRGB(245, 246, 249),
        BorderTransparency = 0.36,
        ShadowTransparency = 1,
        ShadowSize = 0,
    }, false)

    local shaderKey = Instance.new("TextLabel")
    shaderKey.BackgroundTransparency = 1
    shaderKey.Position = UDim2.new(0, 12, 0, 11)
    shaderKey.Size = UDim2.new(1, -24, 0, 18)
    shaderKey.Font = Enum.Font.GothamMedium
    shaderKey.Text = "F4 TOGGLE  /  RIGHTSHIFT HUB"
    shaderKey.TextColor3 = THEME.Muted
    shaderKey.TextSize = 10
    shaderKey.TextXAlignment = Enum.TextXAlignment.Left
    shaderKey.Parent = card
end

syncAndRefresh = function()
    applyRuntimeConfig()
    updateStatusLabels()
end

local function applyPresetByName(name)
    local preset = PRESET_LIBRARY[name]
    if not preset then
        return
    end

    currentConfig = deepCopy(DEFAULT_CONFIG)
    mergeTableInto(currentConfig, preset.Config)
    selectedPresetName = name
    refreshAllControls()
    syncAndRefresh()
end

local function resetPreset()
    applyPresetByName("Balanced")
end

local function applyGlossyBoost()
    currentConfig.Lighting.Brightness = math.max(currentConfig.Lighting.Brightness, 2.58)
    currentConfig.Lighting.ExposureCompensation = math.max(currentConfig.Lighting.ExposureCompensation, -0.02)
    currentConfig.Lighting.EnvironmentDiffuseScale = math.max(currentConfig.Lighting.EnvironmentDiffuseScale, 0.56)
    currentConfig.Lighting.EnvironmentSpecularScale = 1
    currentConfig.Bloom.Intensity = math.max(currentConfig.Bloom.Intensity, 0.11)
    currentConfig.Bloom.Threshold = math.min(currentConfig.Bloom.Threshold, 1.2)
    currentConfig.Bloom.Size = math.max(currentConfig.Bloom.Size, 28)
    currentConfig.Reflections.Multiplier = math.max(currentConfig.Reflections.Multiplier, 1.82)
    currentConfig.Reflections.DefaultReflectance = math.max(currentConfig.Reflections.DefaultReflectance, 0.072)
    currentConfig.Reflections.Radius = math.max(currentConfig.Reflections.Radius, 560)
    currentConfig.Reflections.MaxParts = math.max(currentConfig.Reflections.MaxParts, 760)
    currentConfig.Reflections.QueryMaxParts = math.max(currentConfig.Reflections.QueryMaxParts or 0, 1500)
    currentConfig.Reflections.NearMaxParts = math.max(currentConfig.Reflections.NearMaxParts or 0, 720)
    currentConfig.Reflections.RefreshInterval = math.min(currentConfig.Reflections.RefreshInterval or 0.18, 0.18)
    currentConfig.Reflections.ForceRefreshInterval = math.min(currentConfig.Reflections.ForceRefreshInterval or 0.7, 0.7)
    currentConfig.Reflections.MinPartSize = math.min(currentConfig.Reflections.MinPartSize, 1.25)
    currentConfig.Reflections.MaxTransparency = math.min(currentConfig.Reflections.MaxTransparency, 0.97)
    currentConfig.Reflections.MaxReflectance = math.max(currentConfig.Reflections.MaxReflectance or 0.32, 0.42)
    currentConfig.Terrain.WaterReflectance = math.max(currentConfig.Terrain.WaterReflectance, 0.96)
    currentConfig.Terrain.WaterWaveSize = math.min(currentConfig.Terrain.WaterWaveSize, 0.04)
    currentConfig.DepthOfField.Enabled = false
    if currentConfig.ColorGrading then
        currentConfig.ColorGrading.Enabled = true
        currentConfig.ColorGrading.TonemapperPreset = Enum.TonemapperPreset.Default
    end
    selectedPresetName = "Custom"

    refreshAllControls()
    syncAndRefresh()
end

local function createPresetCard(parent, presetName, layoutOrder)
    local host, glass, content = createGlassListItem(parent, 28, 100 + (layoutOrder or 0), {
        BackgroundTransparency = 0.44,
        BlurTint = Color3.fromRGB(246, 247, 250),
        BorderTransparency = 0.32,
        ShadowTransparency = 1,
        ShadowSize = 0,
        HoverHighlight = true,
        Elasticity = 0.02,
        ClickScale = 0.985,
        OnClick = function()
            applyPresetByName(presetName)
        end,
    }, true)

    local activeBar = Instance.new("Frame")
    activeBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    activeBar.BackgroundTransparency = 0.9
    activeBar.BorderSizePixel = 0
    activeBar.Position = UDim2.new(0, 0, 0, 0)
    activeBar.Size = UDim2.new(0, 2, 1, 0)
    activeBar.Parent = content

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Size = UDim2.new(1, -20, 0, 18)
    title.Font = Enum.Font.GothamBold
    title.Text = string.upper(presetName)
    title.TextColor3 = THEME.Text
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = content

    if not glass then
        local fallbackButton = Instance.new("TextButton")
        fallbackButton.BackgroundTransparency = 1
        fallbackButton.Size = UDim2.new(1, 0, 1, 0)
        fallbackButton.Text = ""
        fallbackButton.Parent = host
        fallbackButton.Activated:Connect(function()
            applyPresetByName(presetName)
        end)
    end

    local function updateVisual()
        local active = selectedPresetName == presetName
        activeBar.BackgroundTransparency = active and 0.18 or 0.9
        title.TextColor3 = active and THEME.Text or THEME.Muted

        if glass then
            setGlassVisual(glass, {
                BackgroundTransparency = active and 0.16 or 0.44,
                BlurTint = active and Color3.fromRGB(236, 240, 246) or Color3.fromRGB(246, 247, 250),
                BorderTransparency = active and 0.16 or 0.36,
            })
        end
    end

    registerRefresher(updateVisual)
end

local function buildHub()
    local existing = PlayerGui:FindFirstChild(GUI_NAME)
    if existing then
        existing:Destroy()
    end

    destroyGlassRefs()
    resetAutoHeightUpdaters()
    uiRefs = {}
    controlRefreshers = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = GUI_NAME
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui

    local mainFrame
    local mainContent
    local topBar
    local leftPane
    local content
    local topBarFrameRef
    local leftFrameRef
    local rightFrameRef
    local introTargets = {}

    local function animateGuiOffset(guiObject, delayTime, offsetX, offsetY)
        if not guiObject then
            return
        end

        local targetPosition = guiObject.Position
        guiObject.Position = UDim2.new(
            targetPosition.X.Scale,
            targetPosition.X.Offset + (offsetX or 0),
            targetPosition.Y.Scale,
            targetPosition.Y.Offset + (offsetY or 0)
        )

        task.delay(delayTime or 0, function()
            if guiObject and guiObject.Parent then
                TweenService:Create(
                    guiObject,
                    TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    { Position = targetPosition }
                ):Play()
            end
        end)
    end

    local function animateTextIntro(root, delayTime)
        if not root then
            return
        end

        for _, node in ipairs(root:GetDescendants()) do
            if node:IsA("TextLabel") or node:IsA("TextButton") then
                local targetTransparency = node.TextTransparency
                node.TextTransparency = 1

                task.delay(delayTime or 0, function()
                    if node and node.Parent then
                        TweenService:Create(
                            node,
                            TweenInfo.new(0.34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            { TextTransparency = targetTransparency }
                        ):Play()
                    end
                end)
            end
        end
    end

    local function attachButtonMotion(glass, contentRoot, label, accentBar, restoreVisual)
        if not glass or not contentRoot or not label then
            return
        end

        local inputCapture = glass:GetFrame():FindFirstChild("InputCapture")
        if not (inputCapture and inputCapture:IsA("GuiButton")) then
            return
        end

        local baseLabelPosition = label.Position
        local sweep = Instance.new("Frame")
        sweep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sweep.BackgroundTransparency = 0.88
        sweep.BorderSizePixel = 0
        sweep.AnchorPoint = Vector2.new(0.5, 0.5)
        sweep.Position = UDim2.new(-0.35, 0, 0.5, 0)
        sweep.Size = UDim2.new(0, 30, 1.6, 0)
        sweep.Rotation = 12
        sweep.Parent = contentRoot

        local sweepGradient = Instance.new("UIGradient")
        sweepGradient.Rotation = 90
        sweepGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.72),
            NumberSequenceKeypoint.new(1, 1),
        })
        sweepGradient.Parent = sweep

        local function runSweep()
            sweep.Position = UDim2.new(-0.35, 0, 0.5, 0)
            TweenService:Create(
                sweep,
                TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Position = UDim2.new(1.25, 0, 0.5, 0) }
            ):Play()
        end

        inputCapture.MouseEnter:Connect(function()
            TweenService:Create(
                label,
                TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Position = UDim2.new(baseLabelPosition.X.Scale, baseLabelPosition.X.Offset + 4, baseLabelPosition.Y.Scale, baseLabelPosition.Y.Offset) }
            ):Play()

            if accentBar then
                TweenService:Create(
                    accentBar,
                    TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { BackgroundTransparency = 0.38, Size = UDim2.new(0, 3, 1, 0) }
                ):Play()
            end

            runSweep()
        end)

        inputCapture.MouseLeave:Connect(function()
            TweenService:Create(
                label,
                TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Position = baseLabelPosition }
            ):Play()

            if restoreVisual then
                restoreVisual()
            elseif accentBar then
                TweenService:Create(
                    accentBar,
                    TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { BackgroundTransparency = 0.9, Size = UDim2.new(0, 2, 1, 0) }
                ):Play()
            end
        end)
    end

    local function queueIntro(guiObject, fadeRoot, delayTime, offsetX, offsetY)
        table.insert(introTargets, {
            Gui = guiObject,
            FadeRoot = fadeRoot or guiObject,
            Delay = delayTime or 0,
            OffsetX = offsetX or 0,
            OffsetY = offsetY or 0,
        })
    end

    local function playHubIntro()
        if not mainFrame then
            return
        end

        local targetSize = mainFrame.Size
        local targetPosition = mainFrame.Position

        mainFrame.Size = UDim2.new(
            targetSize.X.Scale,
            math.max(0, targetSize.X.Offset - 44),
            targetSize.Y.Scale,
            math.max(0, targetSize.Y.Offset - 24)
        )
        mainFrame.Position = UDim2.new(
            targetPosition.X.Scale,
            targetPosition.X.Offset,
            targetPosition.Y.Scale,
            targetPosition.Y.Offset + 18
        )

        TweenService:Create(
            mainFrame,
            TweenInfo.new(0.46, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {
                Size = targetSize,
                Position = targetPosition,
            }
        ):Play()

        animateTextIntro(topBar, 0.1)
        animateTextIntro(content, 0.16)

        animateGuiOffset(topBarFrameRef, 0.04, 0, -10)
        animateGuiOffset(leftFrameRef, 0.08, -18, 0)
        animateGuiOffset(rightFrameRef, 0.12, 18, 0)

        for _, item in ipairs(introTargets) do
            animateGuiOffset(item.Gui, item.Delay, item.OffsetX, item.OffsetY)
            animateTextIntro(item.FadeRoot, item.Delay + 0.02)
        end
    end

    if LiquidGlass then
        local mainGlass = createLiquidPanel(makeGlassOptions({
            Size = UDim2.fromOffset(930, 560),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = gui,
            ZIndex = 10,
            BackgroundTransparency = 0.46,
            BlurTint = Color3.fromRGB(244, 246, 250),
            BorderTransparency = 0.18,
            BorderThickness = 1.1,
            ShadowTransparency = 0.985,
            ShadowOffset = Vector2.new(0, 10),
            ShadowSize = 4,
            Elasticity = 0.015,
        }), false)

        mainFrame = mainGlass:GetFrame()
        mainContent = mainGlass:GetContentFrame()
        mainFrame.Name = "Main"
        mainContent.ClipsDescendants = false

        local topBarGlass = createLiquidPanel(makeGlassOptions({
            Size = UDim2.new(1, -24, 0, 36),
            Position = UDim2.new(0, 12, 0, 12),
            AnchorPoint = Vector2.new(0, 0),
            Parent = mainContent,
            ZIndex = 20,
            BackgroundTransparency = 0.42,
            BlurTint = Color3.fromRGB(248, 249, 252),
            BorderTransparency = 0.22,
            ShadowTransparency = 1,
            ShadowSize = 0,
            ShadowOffset = Vector2.new(),
        }), false)
        topBar = topBarGlass:GetContentFrame()
        local topBarFrame = topBarGlass:GetFrame()
        topBarFrameRef = topBarFrame

        local hubTitle = Instance.new("TextLabel")
        hubTitle.BackgroundTransparency = 1
        hubTitle.Position = UDim2.new(0, 10, 0, 8)
        hubTitle.Size = UDim2.new(0, 140, 0, 18)
        hubTitle.Font = Enum.Font.GothamBold
        hubTitle.Text = "SHADERS"
        hubTitle.TextColor3 = THEME.Text
        hubTitle.TextSize = 12
        hubTitle.TextXAlignment = Enum.TextXAlignment.Left
        hubTitle.Parent = topBar

        local presetChipHost, presetChipGlass, presetChipContent = createGlassAbsolute(topBar, UDim2.new(1, -196, 0.5, -11), UDim2.fromOffset(106, 22), {
            ZIndex = 24,
            BackgroundTransparency = 0.28,
            BlurTint = Color3.fromRGB(246, 247, 250),
            BorderTransparency = 0.2,
            ShadowTransparency = 1,
            ShadowSize = 0,
        }, false)

        local presetValue = Instance.new("TextLabel")
        presetValue.BackgroundTransparency = 1
        presetValue.Position = UDim2.new(0, 8, 0, 0)
        presetValue.Size = UDim2.new(1, -16, 1, 0)
        presetValue.Font = Enum.Font.GothamBold
        presetValue.Text = "BALANCED"
        presetValue.TextColor3 = THEME.Text
        presetValue.TextSize = 10
        presetValue.TextXAlignment = Enum.TextXAlignment.Center
        presetValue.Parent = presetChipContent
        uiRefs.PresetValue = presetValue
        uiRefs.PresetChip = presetChipGlass

        local statusChipHost, statusChipGlass, statusChipContent = createGlassAbsolute(topBar, UDim2.new(1, -82, 0.5, -11), UDim2.fromOffset(46, 22), {
            ZIndex = 24,
            BackgroundTransparency = 0.14,
            BlurTint = Color3.fromRGB(234, 240, 238),
            BorderTransparency = 0.18,
            ShadowTransparency = 1,
            ShadowSize = 0,
        }, false)

        local statusValue = Instance.new("TextLabel")
        statusValue.BackgroundTransparency = 1
        statusValue.Position = UDim2.new(0, 0, 0, 0)
        statusValue.Size = UDim2.new(1, 0, 1, 0)
        statusValue.Font = Enum.Font.GothamBold
        statusValue.Text = "ON"
        statusValue.TextColor3 = THEME.Positive
        statusValue.TextSize = 10
        statusValue.TextXAlignment = Enum.TextXAlignment.Center
        statusValue.Parent = statusChipContent
        uiRefs.StatusValue = statusValue
        uiRefs.StatusChip = statusChipGlass

        local closeHost, closeGlass, closeContent = createGlassAbsolute(topBar, UDim2.new(1, -28, 0.5, -11), UDim2.fromOffset(20, 22), {
            ZIndex = 25,
            BackgroundTransparency = 0.3,
            BlurTint = Color3.fromRGB(246, 247, 250),
            BorderTransparency = 0.2,
            ShadowTransparency = 1,
            ShadowSize = 0,
            HoverHighlight = true,
            Elasticity = 0.02,
            ClickScale = 0.985,
            OnClick = function()
                setHubVisible(false)
            end,
        }, true)

        local closeLabel = Instance.new("TextLabel")
        closeLabel.BackgroundTransparency = 1
        closeLabel.Size = UDim2.new(1, 0, 1, 0)
        closeLabel.Font = Enum.Font.GothamBold
        closeLabel.Text = "X"
        closeLabel.TextColor3 = THEME.Text
        closeLabel.TextSize = 10
        closeLabel.Parent = closeContent

        local leftGlass = createLiquidPanel(makeGlassOptions({
            Size = UDim2.new(0, 188, 1, -70),
            Position = UDim2.new(0, 12, 0, 58),
            AnchorPoint = Vector2.new(0, 0),
            Parent = mainContent,
            ZIndex = 20,
            BackgroundTransparency = 0.48,
            BlurTint = Color3.fromRGB(246, 247, 250),
            BorderTransparency = 0.24,
            ShadowTransparency = 1,
            ShadowSize = 0,
            ShadowOffset = Vector2.new(),
        }), false)
        leftPane = leftGlass:GetContentFrame()
        leftFrameRef = leftGlass:GetFrame()

        local rightGlass = createLiquidPanel(makeGlassOptions({
            Size = UDim2.new(1, -238, 1, -70),
            Position = UDim2.new(0, 226, 0, 58),
            AnchorPoint = Vector2.new(0, 0),
            Parent = mainContent,
            ZIndex = 20,
            BackgroundTransparency = 0.5,
            BlurTint = Color3.fromRGB(246, 247, 250),
            BorderTransparency = 0.24,
            ShadowTransparency = 1,
            ShadowSize = 0,
            ShadowOffset = Vector2.new(),
        }), false)
        local rightPane = rightGlass:GetContentFrame()
        rightFrameRef = rightGlass:GetFrame()

        content = Instance.new("ScrollingFrame")
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.Size = UDim2.new(1, 0, 1, 0)
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = THEME.AccentSoft
        content.CanvasSize = UDim2.new()
        content.Parent = rightPane

        makeDraggable(mainFrame, topBarFrame)

        uiRefs.Gui = gui
        uiRefs.Main = mainFrame
        uiRefs.TopBar = topBarFrame
    else
        local main = Instance.new("Frame")
        main.Name = "Main"
        main.AnchorPoint = Vector2.new(0.5, 0.5)
        main.Position = UDim2.new(0.5, 0, 0.5, 0)
        main.Size = UDim2.fromOffset(930, 560)
        main.Parent = gui
        styleCard(main, THEME.Background, true)
        main.BackgroundTransparency = 0.34

        local topBarFrame = Instance.new("Frame")
        topBarFrame.BackgroundTransparency = 1
        topBarFrame.Position = UDim2.new(0, 12, 0, 12)
        topBarFrame.Size = UDim2.new(1, -24, 0, 36)
        topBarFrame.Parent = main
        topBar = topBarFrame
        topBarFrameRef = topBarFrame

        local leftFrame = Instance.new("Frame")
        leftFrame.BackgroundTransparency = 1
        leftFrame.Position = UDim2.new(0, 12, 0, 58)
        leftFrame.Size = UDim2.new(0, 188, 1, -70)
        leftFrame.Parent = main
        leftPane = leftFrame
        leftFrameRef = leftFrame

        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        contentFrame.Position = UDim2.new(0, 226, 0, 58)
        contentFrame.Size = UDim2.new(1, -238, 1, -70)
        contentFrame.ScrollBarThickness = 4
        contentFrame.Parent = main
        content = contentFrame
        rightFrameRef = contentFrame
        mainFrame = main
        mainContent = main
        uiRefs.Gui = gui
        uiRefs.Main = main
        uiRefs.TopBar = topBarFrame
        makeDraggable(main, topBarFrame)

        local hubTitle = Instance.new("TextLabel")
        hubTitle.BackgroundTransparency = 1
        hubTitle.Position = UDim2.new(0, 10, 0, 8)
        hubTitle.Size = UDim2.new(0, 140, 0, 18)
        hubTitle.Font = Enum.Font.GothamBold
        hubTitle.Text = "SHADERS"
        hubTitle.TextColor3 = THEME.Text
        hubTitle.TextSize = 12
        hubTitle.TextXAlignment = Enum.TextXAlignment.Left
        hubTitle.Parent = topBarFrame
    end

    local function createLeftHeader(text, y)
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 12, 0, y)
        label.Size = UDim2.new(1, -24, 0, 14)
        label.Font = Enum.Font.GothamBold
        label.Text = string.upper(text)
        label.TextColor3 = THEME.Muted
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = leftPane

        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BackgroundTransparency = 0.9
        line.BorderSizePixel = 0
        line.Position = UDim2.new(0, 12, 0, y + 18)
        line.Size = UDim2.new(1, -24, 0, 1)
        line.Parent = leftPane
    end

    local function createLeftGlassButton(text, y, callback)
        local host, glass, content = createGlassAbsolute(leftPane, UDim2.new(0, 10, 0, y), UDim2.new(1, -20, 0, 30), {
            ZIndex = 34,
            BackgroundTransparency = 0.42,
            BlurTint = Color3.fromRGB(246, 247, 250),
            BorderTransparency = 0.28,
            ShadowTransparency = 1,
            ShadowSize = 0,
            HoverHighlight = true,
            Elasticity = 0.02,
            ClickScale = 0.985,
            OnClick = callback,
        }, true)

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 7)
        label.Size = UDim2.new(1, -20, 0, 16)
        label.Font = Enum.Font.GothamBold
        label.Text = string.upper(text)
        label.TextColor3 = THEME.Text
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = content

        local accentBar = Instance.new("Frame")
        accentBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        accentBar.BackgroundTransparency = 0.9
        accentBar.BorderSizePixel = 0
        accentBar.Position = UDim2.new(0, 0, 0, 0)
        accentBar.Size = UDim2.new(0, 2, 1, 0)
        accentBar.Parent = content

        if not glass then
            local fallbackButton = Instance.new("TextButton")
            fallbackButton.BackgroundTransparency = 1
            fallbackButton.Size = UDim2.new(1, 0, 1, 0)
            fallbackButton.Text = ""
            fallbackButton.Parent = host
            fallbackButton.Activated:Connect(callback)
        end

        attachButtonMotion(glass, content, label, accentBar)
        queueIntro(host, content, 0.16 + (#introTargets * 0.025), -10, 0)

        return {
            Host = host,
            Glass = glass,
            Label = label,
        }
    end

    local function createLeftPreset(text, y)
        local host, glass, content = createGlassAbsolute(leftPane, UDim2.new(0, 10, 0, y), UDim2.new(1, -20, 0, 28), {
            ZIndex = 34,
            BackgroundTransparency = 0.44,
            BlurTint = Color3.fromRGB(246, 247, 250),
            BorderTransparency = 0.32,
            ShadowTransparency = 1,
            ShadowSize = 0,
            HoverHighlight = true,
            Elasticity = 0.02,
            ClickScale = 0.985,
            OnClick = function()
                applyPresetByName(text)
            end,
        }, true)

        local activeBar = Instance.new("Frame")
        activeBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        activeBar.BackgroundTransparency = 0.9
        activeBar.BorderSizePixel = 0
        activeBar.Position = UDim2.new(0, 0, 0, 0)
        activeBar.Size = UDim2.new(0, 2, 1, 0)
        activeBar.Parent = content

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Size = UDim2.new(1, -20, 0, 18)
        label.Font = Enum.Font.GothamBold
        label.Text = string.upper(text)
        label.TextColor3 = THEME.Muted
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = content

        if not glass then
            local fallbackButton = Instance.new("TextButton")
            fallbackButton.BackgroundTransparency = 1
            fallbackButton.Size = UDim2.new(1, 0, 1, 0)
            fallbackButton.Text = ""
            fallbackButton.Parent = host
            fallbackButton.Activated:Connect(function()
                applyPresetByName(text)
            end)
        end

        local function updateVisual()
            local active = selectedPresetName == text
            activeBar.BackgroundTransparency = active and 0.18 or 0.9
            label.TextColor3 = active and THEME.Text or THEME.Muted
            if glass then
                setGlassVisual(glass, {
                    BackgroundTransparency = active and 0.16 or 0.44,
                    BlurTint = active and Color3.fromRGB(236, 240, 246) or Color3.fromRGB(246, 247, 250),
                    BorderTransparency = active and 0.16 or 0.36,
                })
            end
        end

        attachButtonMotion(glass, content, label, activeBar, updateVisual)
        registerRefresher(updateVisual)
        queueIntro(host, content, 0.24 + (#introTargets * 0.022), -12, 0)
    end

    createLeftHeader("Tools", 10)
    local shaderAction = createLeftGlassButton("POWER ON", 34, function()
        if isEnabled then
            disableRTX()
        else
            enableRTX()
        end
    end)
    uiRefs.ShaderActionTitle = shaderAction.Label

    createLeftGlassButton("MIRROR", 68, applyGlossyBoost)
    createLeftGlassButton("RESET", 102, resetPreset)

    createLeftHeader("Presets", 146)
    local presetY = 170
    for _, presetName in ipairs(PRESET_ORDER) do
        createLeftPreset(presetName, presetY)
        presetY = presetY + 32
    end

    local infoHost, _, infoContent = createGlassAbsolute(leftPane, UDim2.new(0, 10, 1, -50), UDim2.new(1, -20, 0, 40), {
        ZIndex = 34,
        BackgroundTransparency = 0.5,
        BlurTint = Color3.fromRGB(245, 246, 249),
        BorderTransparency = 0.36,
        ShadowTransparency = 1,
        ShadowSize = 0,
    }, false)

    local infoLabel = Instance.new("TextLabel")
    infoLabel.BackgroundTransparency = 1
    infoLabel.Position = UDim2.new(0, 12, 0, 11)
    infoLabel.Size = UDim2.new(1, -24, 0, 18)
    infoLabel.Font = Enum.Font.GothamMedium
    infoLabel.Text = "F4 TOGGLE  /  RIGHTSHIFT HUB"
    infoLabel.TextColor3 = THEME.Muted
    infoLabel.TextSize = 10
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = infoContent
    queueIntro(infoHost, infoContent, 0.44, -10, 0)

    local contentHolder = Instance.new("Frame")
    contentHolder.BackgroundTransparency = 1
    contentHolder.Size = UDim2.new(1, -8, 0, 0)
    contentHolder.AutomaticSize = Enum.AutomaticSize.Y
    contentHolder.Parent = content

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = contentHolder

    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 8)
    end)

    local runtimeSection = createSection(contentHolder, "Runtime", nil, 0)
    createToggle(
        runtimeSection,
        "Depth Of Field",
        "Enable cinematic blur with adjustable focus distance.",
        function()
            return currentConfig.DepthOfField.Enabled
        end,
        function(value)
            currentConfig.DepthOfField.Enabled = value
            syncAndRefresh()
        end,
        10
    )
    createToggle(
        runtimeSection,
        "Autofocus",
        "Continuously refocus on whatever the camera points at.",
        function()
            return currentConfig.Autofocus.Enabled
        end,
        function(value)
            currentConfig.Autofocus.Enabled = value
            syncAndRefresh()
        end,
        11
    )
    createToggle(
        runtimeSection,
        "3D Clouds",
        "Spawn and control volumetric clouds inside Terrain.",
        function()
            return currentConfig.Clouds.Enabled
        end,
        function(value)
            currentConfig.Clouds.Enabled = value
            syncAndRefresh()
        end,
        12
    )
    createToggle(
        runtimeSection,
        "Reflections",
        "Pseudo-reflections and gloss around the camera.",
        function()
            return currentConfig.Reflections.Enabled
        end,
        function(value)
            currentConfig.Reflections.Enabled = value
            syncAndRefresh()
        end,
        13
    )
    createToggle(
        runtimeSection,
        "Auto Exposure",
        "Camera-style exposure adaptation for sky and interiors.",
        function()
            return currentConfig.AutoExposure.Enabled
        end,
        function(value)
            currentConfig.AutoExposure.Enabled = value
            syncAndRefresh()
        end,
        14
    )
    createToggle(
        runtimeSection,
        "Local Light Influence",
        "Nearby colored lights affect tint, glow, shadows and gloss.",
        function()
            return currentConfig.LocalLightInfluence.Enabled
        end,
        function(value)
            currentConfig.LocalLightInfluence.Enabled = value
            syncAndRefresh()
        end,
        15
    )

    local lightingSection = createSection(contentHolder, "Lighting", "Global light balance and shadow response.", 2)
    createSlider(
        lightingSection,
        "Brightness",
        "Overall scene brightness before post FX.",
        0.6,
        4,
        2,
        function()
            return currentConfig.Lighting.Brightness
        end,
        function(value)
            currentConfig.Lighting.Brightness = value
            syncAndRefresh()
        end,
        20
    )
    createSlider(
        lightingSection,
        "Exposure",
        "Camera exposure compensation.",
        -1.2,
        0.8,
        2,
        function()
            return currentConfig.Lighting.ExposureCompensation
        end,
        function(value)
            currentConfig.Lighting.ExposureCompensation = value
            syncAndRefresh()
        end,
        21
    )
    createSlider(
        lightingSection,
        "Env Diffuse",
        "Soft global light coming from the environment.",
        0,
        1,
        2,
        function()
            return currentConfig.Lighting.EnvironmentDiffuseScale
        end,
        function(value)
            currentConfig.Lighting.EnvironmentDiffuseScale = value
            syncAndRefresh()
        end,
        22
    )
    createSlider(
        lightingSection,
        "Env Specular",
        "How much the environment creates shiny highlights.",
        0,
        1,
        2,
        function()
            return currentConfig.Lighting.EnvironmentSpecularScale
        end,
        function(value)
            currentConfig.Lighting.EnvironmentSpecularScale = value
            syncAndRefresh()
        end,
        23
    )
    createSlider(
        lightingSection,
        "Shadow Softness",
        "Blur amount on shadows with Future lighting.",
        0,
        1,
        2,
        function()
            return currentConfig.Lighting.ShadowSoftness
        end,
        function(value)
            currentConfig.Lighting.ShadowSoftness = value
            syncAndRefresh()
        end,
        24
    )
    createSlider(
        lightingSection,
        "AE Sky Darken",
        "How much open sky pulls exposure down.",
        0,
        0.2,
        3,
        function()
            return currentConfig.AutoExposure.SkyDarkening
        end,
        function(value)
            currentConfig.AutoExposure.SkyDarkening = value
            syncAndRefresh()
        end,
        25
    )
    createSlider(
        lightingSection,
        "AE Indoor Lift",
        "How much covered spaces are lifted.",
        0,
        0.22,
        3,
        function()
            return currentConfig.AutoExposure.IndoorLift
        end,
        function(value)
            currentConfig.AutoExposure.IndoorLift = value
            syncAndRefresh()
        end,
        26
    )
    createSlider(
        lightingSection,
        "Local Light Tint",
        "How strongly nearby colored lights tint the image.",
        0,
        0.38,
        2,
        function()
            return currentConfig.LocalLightInfluence.TintStrength
        end,
        function(value)
            currentConfig.LocalLightInfluence.TintStrength = value
            syncAndRefresh()
        end,
        27
    )

    local postSection = createSection(contentHolder, "Post FX", "Tone, bloom, rays and atmosphere.", 3)
    createSlider(
        postSection,
        "Contrast",
        "Adds depth and punch to the final image.",
        0,
        0.4,
        2,
        function()
            return currentConfig.ColorCorrection.Contrast
        end,
        function(value)
            currentConfig.ColorCorrection.Contrast = value
            syncAndRefresh()
        end,
        30
    )
    createSlider(
        postSection,
        "Saturation",
        "Push colors harder or soften them down.",
        0,
        0.35,
        2,
        function()
            return currentConfig.ColorCorrection.Saturation
        end,
        function(value)
            currentConfig.ColorCorrection.Saturation = value
            syncAndRefresh()
        end,
        31
    )
    createSlider(
        postSection,
        "Bloom Intensity",
        "Controls bright glow around emissive areas.",
        0,
        0.3,
        2,
        function()
            return currentConfig.Bloom.Intensity
        end,
        function(value)
            currentConfig.Bloom.Intensity = value
            syncAndRefresh()
        end,
        32
    )
    createSlider(
        postSection,
        "Bloom Threshold",
        "Higher values reduce bloom on normal surfaces.",
        0.8,
        2.5,
        2,
        function()
            return currentConfig.Bloom.Threshold
        end,
        function(value)
            currentConfig.Bloom.Threshold = value
            syncAndRefresh()
        end,
        33
    )
    createSlider(
        postSection,
        "Sun Rays",
        "Adds shafts around the sun direction.",
        0,
        0.12,
        3,
        function()
            return currentConfig.SunRays.Intensity
        end,
        function(value)
            currentConfig.SunRays.Intensity = value
            syncAndRefresh()
        end,
        34
    )
    createSlider(
        postSection,
        "Atmosphere Haze",
        "Distance haze for softer skies and depth.",
        0,
        1.5,
        2,
        function()
            return currentConfig.Atmosphere.Haze
        end,
        function(value)
            currentConfig.Atmosphere.Haze = value
            syncAndRefresh()
        end,
        35
    )
    createSlider(
        postSection,
        "Atmosphere Glare",
        "Lens-style glow from the atmosphere layer.",
        0,
        0.25,
        2,
        function()
            return currentConfig.Atmosphere.Glare
        end,
        function(value)
            currentConfig.Atmosphere.Glare = value
            syncAndRefresh()
        end,
        36
    )
    createSlider(
        postSection,
        "Local Light Bloom",
        "Extra bloom from nearby bright colored lights.",
        0,
        0.18,
        3,
        function()
            return currentConfig.LocalLightInfluence.BloomStrength
        end,
        function(value)
            currentConfig.LocalLightInfluence.BloomStrength = value
            syncAndRefresh()
        end,
        37
    )

    local depthSection = createSection(contentHolder, "Depth & Clouds", "Focus blur and sky volume controls.", 4)
    createSlider(
        depthSection,
        "DOF Far Blur",
        "How strong the far blur should be.",
        0,
        0.35,
        2,
        function()
            return currentConfig.DepthOfField.FarIntensity
        end,
        function(value)
            currentConfig.DepthOfField.FarIntensity = value
            syncAndRefresh()
        end,
        40
    )
    createSlider(
        depthSection,
        "Focus Distance",
        "Base focus point when autofocus is off.",
        10,
        200,
        0,
        function()
            return currentConfig.DepthOfField.FocusDistance
        end,
        function(value)
            currentConfig.DepthOfField.FocusDistance = value
            syncAndRefresh()
        end,
        41
    )
    createSlider(
        depthSection,
        "Focus Radius",
        "How much stays sharp around the focus point.",
        8,
        80,
        0,
        function()
            return currentConfig.DepthOfField.InFocusRadius
        end,
        function(value)
            currentConfig.DepthOfField.InFocusRadius = value
            syncAndRefresh()
        end,
        42
    )
    createSlider(
        depthSection,
        "Cloud Cover",
        "Amount of cloud spread in the sky.",
        0,
        1,
        2,
        function()
            return currentConfig.Clouds.Cover
        end,
        function(value)
            currentConfig.Clouds.Cover = value
            syncAndRefresh()
        end,
        43
    )
    createSlider(
        depthSection,
        "Cloud Density",
        "Thicker or thinner volumetric clouds.",
        0,
        1,
        2,
        function()
            return currentConfig.Clouds.Density
        end,
        function(value)
            currentConfig.Clouds.Density = value
            syncAndRefresh()
        end,
        44
    )
    local reflectionSection = createSection(contentHolder, "Reflections", "Gloss, range and water response.", 5)
    createSlider(
        reflectionSection,
        "Reflection Strength",
        "Global multiplier for pseudo-reflections.",
        0.4,
        3.2,
        2,
        function()
            return currentConfig.Reflections.Multiplier
        end,
        function(value)
            currentConfig.Reflections.Multiplier = value
            syncAndRefresh()
        end,
        50
    )
    createSlider(
        reflectionSection,
        "Base Reflectance",
        "Fallback shine for materials not explicitly mapped.",
        0,
        0.12,
        3,
        function()
            return currentConfig.Reflections.DefaultReflectance
        end,
        function(value)
            currentConfig.Reflections.DefaultReflectance = value
            syncAndRefresh()
        end,
        51
    )
    createSlider(
        reflectionSection,
        "Reflection Ceiling",
        "Maximum gloss allowed on enhanced surfaces.",
        0.08,
        0.55,
        2,
        function()
            return currentConfig.Reflections.MaxReflectance or 0.32
        end,
        function(value)
            currentConfig.Reflections.MaxReflectance = value
            syncAndRefresh()
        end,
        52
    )
    createSlider(
        reflectionSection,
        "Light Reflection Boost",
        "Extra surface gloss near local lights.",
        0,
        0.55,
        2,
        function()
            return currentConfig.LocalLightInfluence.ReflectionBoost
        end,
        function(value)
            currentConfig.LocalLightInfluence.ReflectionBoost = value
            syncAndRefresh()
        end,
        53
    )
    createSlider(
        reflectionSection,
        "Reflection Radius",
        "How far from camera the glossy scan reaches.",
        80,
        650,
        0,
        function()
            return currentConfig.Reflections.Radius
        end,
        function(value)
            currentConfig.Reflections.Radius = value
            syncAndRefresh()
        end,
        54
    )
    createSlider(
        reflectionSection,
        "Reflection Parts",
        "Number of nearby parts enhanced for gloss.",
        40,
        1400,
        0,
        function()
            return currentConfig.Reflections.MaxParts
        end,
        function(value)
            currentConfig.Reflections.MaxParts = value
            syncAndRefresh()
        end,
        55
    )
    createSlider(
        reflectionSection,
        "Water Reflectance",
        "Mirror feel on terrain water.",
        0,
        1,
        2,
        function()
            return currentConfig.Terrain.WaterReflectance
        end,
        function(value)
            currentConfig.Terrain.WaterReflectance = value
            syncAndRefresh()
        end,
        56
    )
    createSlider(
        reflectionSection,
        "Water Wave Size",
        "Smaller waves look calmer and cleaner.",
        0,
        0.3,
        2,
        function()
            return currentConfig.Terrain.WaterWaveSize
        end,
        function(value)
            currentConfig.Terrain.WaterWaveSize = value
            syncAndRefresh()
        end,
        57
    )
    refreshAutoHeights()
    task.defer(refreshAutoHeights)
    refreshAllControls()
    task.defer(playHubIntro)
end

setHubVisible = function(visible)
    hubVisible = visible
    if uiRefs.Main then
        uiRefs.Main.Visible = visible
    end
end

buildHub()
enableRTX()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == SHADER_KEY then
        if isEnabled then
            disableRTX()
        else
            enableRTX()
        end
    elseif input.KeyCode == HUB_KEY then
        setHubVisible(not hubVisible)
    end
end)
