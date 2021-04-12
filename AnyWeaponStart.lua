--[[
    AnyWeaponStart v0.1
    Author:
        cgull (Discord: cgull#4469)

    Allows for equipping of any weapon aspect for a new savefile.

    Current behavior forces the weapon to be equipped upon death, since 
    the used aspect is not unlocked in the courtyard. This may be resolved in a future version.
]]

ModUtil.RegisterMod( "AnyWeaponStart" )

-- Update config to match desired Aspect + Rarity level. Details below. 
-- Default config loads Common (Level 1) Aspect of Arthur, code "SB4", rarity 1
local config = {
    StartingAspect = "SB4",
    StartingRarity = 1
}

--[[
    StartingAspect Codes (string):

    SB1: Stygian Blade, Aspect of Zagreus
    SB2: Stygian Blade, Aspect of Nemesis
    SB3: Stygian Blade, Aspect of Poseidon
    SB4: Stygian Blade, Aspect of Arthur

    ES1: Eternal Spear, Aspect of Zagreus
    ES2: Eternal Spear, Aspect of Achilles
    ES3: Eternal Spear, Aspect of Hades
    ES4: Eternal Spear, Aspect of Guan Yu
    
    SC1: Shield of Chaos, Aspect of Zagreus
    SC2: Shield of Chaos, Aspect of Chaos
    SC3: Shield of Chaos, Aspect of Zeus
    SC4: Shield of Chaos, Aspect of Beowulf

    HB1: Heart-Seeking Bow, Aspect of Zagreus
    HB2: Heart-Seeking Bow, Aspect of Chiron
    HB3: Heart-Seeking Bow, Aspect of Hera
    HB4: Heart-Seeking Bow, Aspect of Rama

    TF1: Twin Fists, Aspect of Zagreus
    TF2: Twin Fists, Aspect of Talos
    TF3: Twin Fists, Aspect of Demeter
    TF4: Twin Fists, Aspect of Gilgamesh

    AR1: Adamant Rail, Aspect of Zagreus
    AR2: Adamant Rail, Aspect of Eris
    AR3: Adamant Rail, Aspect of Hestia
    AR4: Adamant Rail, Aspect of Lucifer

    StartingRarity Codes (integer):

    0 - Base form of Aspects of Zagreus (no bonus). If used for a non-Zagreus aspect, will default to Common (Level 1)
    1 - Common (Level 1)
    2 - Rare (Level 2)
    3 - Epic (Level 3)
    4 - Heroic (Level 4)
    5 - Legendary (Level 5)
]]

AnyWeaponStart.Config = config

AnyWeaponStart.AspectData = {
    SB1 =
    {
        WeaponName = "SwordWeapon",
        TraitName = "SwordBaseUpgradeTrait"
    },
    SB2 = 
    {
        WeaponName = "SwordWeapon",
        TraitName = "SwordCriticalParryTrait"
    },
    SB3 = 
    {
        WeaponName = "SwordWeapon",
        TraitName = "DislodgeAmmoTrait"
    },
    SB4 = 
    {
        WeaponName = "SwordWeapon",
        TraitName = "SwordConsecrationTrait"
    },
    ES1 = 
    {
        WeaponName = "SpearWeapon",
        TraitName = "SpearBaseUpgradeTrait"
    },
    ES2 = 
    {
        WeaponName = "SpearWeapon",
        TraitName = "SpearTeleportTrait"
    },
    ES3 = 
    {
        WeaponName = "SpearWeapon",
        TraitName = "SpearWeaveTrait"
    },
    ES4 = 
    {
        WeaponName = "SpearWeapon",
        TraitName = "SpearSpinTravel"
    },
    SC1 = 
    {
        WeaponName = "ShieldWeapon",
        TraitName = "ShieldBaseUpgradeTrait"
    },
    SC2 = 
    {
        WeaponName = "ShieldWeapon",
        TraitName = "ShieldRushBonusProjectileTrait"
    },
    SC3 = 
    {
        WeaponName = "ShieldWeapon",
        TraitName = "ShieldTwoShieldTrait"
    },
    SC4 = 
    {
        WeaponName = "ShieldWeapon",
        TraitName = "ShieldLoadAmmoTrait"
    },
    HB1 = 
    {
        WeaponName = "BowWeapon",
        TraitName = "BowBaseUpgradeTrait"
    },
    HB2 = 
    {
        WeaponName = "BowWeapon",
        TraitName = "BowMarkHomingTrait"
    },
    HB3 = 
    {
        WeaponName = "BowWeapon",
        TraitName = "BowLoadAmmoTrait"
    },
    HB4 = 
    {
        WeaponName = "BowWeapon",
        TraitName = "BowBondTrait"
    },
    TF1 = 
    {
        WeaponName = "FistWeapon",
        TraitName = "FistBaseUpgradeTrait"
    },
    TF2 = 
    {
        WeaponName = "FistWeapon",
        TraitName = "FistVacuumTrait"
    },
    TF3 = 
    {
        WeaponName = "FistWeapon",
        TraitName = "FistWeaveTrait"
    },
    TF4 = 
    {
        WeaponName = "FistWeapon",
        TraitName = "FistDetonateTrait"
    },
    AR1 = 
    {
        WeaponName = "GunWeapon",
        TraitName = "GunBaseUpgradeTrait"
    },
    AR2 = 
    {
        WeaponName = "GunWeapon",
        TraitName = "GunGrenadeSelfEmpowerTrait"
    },
    AR3 = 
    {
        WeaponName = "GunWeapon",
        TraitName = "GunManualReloadTrait"
    },
    AR4 = 
    {
        WeaponName = "GunWeapon",
        TraitName = "GunLoadedGrenadeTrait"
    }
}

local function EquipAspect(weaponName, traitName, rarityIndex)
    EquipPlayerWeapon(WeaponData[weaponName], { PreLoadBinks = true })

    if rarityIndex ~= 0 then
        AddTraitToHero({ TraitName = traitName, Rarity = GetRarityKey(rarityIndex)})
    end
end

ModUtil.WrapBaseFunction( "StartNewGame", 
    function(baseFunc)
        baseFunc()

        local weaponAspectData = AnyWeaponStart.AspectData[AnyWeaponStart.Config.StartingAspect]

        -- handling invalid level 0 rarity
        if (AnyWeaponStart.Config.StartingRarity == 0 and string.sub(AnyWeaponStart.Config.StartingAspect, 3, 3) ~= "1") then
            local rarityIndex = 1
        else
            local rarityIndex = AnyWeaponStart.Config.StartingRarity
        end

        EquipAspect(weaponAspectData.WeaponName, weaponAspectData.TraitName, rarityIndex)

        GameState.AnyWeaponStartConfig = { 
            WeaponName = weaponAspectData.WeaponName,
            TraitName = weaponAspectData.TraitName,
            RarityIndex = rarityIndex
        }
    end, AnyWeaponStart
)

ModUtil.WrapBaseFunction("StartDeathLoopPresentation", 
    function ( baseFunc, currentRun )
	    baseFunc( currentRun )

        if GameState.AnyWeaponStartConfig then
	        EquipAspect(
                GameState.AnyWeaponStartConfig.WeaponName,
                GameState.AnyWeaponStartConfig.TraitName,
                GameState.AnyWeaponStartConfig.RarityIndex
            )
        end
    end, AnyWeaponStart
)

ModUtil.WrapBaseFunction("StartNewRun",
    function ( baseFunc, prevRun, args )
        local run = baseFunc( prevRun, args )

        if GameState.AnyWeaponStartConfig then
	        EquipAspect(
                GameState.AnyWeaponStartConfig.WeaponName,
                GameState.AnyWeaponStartConfig.TraitName,
                GameState.AnyWeaponStartConfig.RarityIndex
            )
        end
    
        return run
    end, AnyWeaponStart
)