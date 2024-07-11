--[[
    COPYRIGHT NOTICE
    DATE: XX/01/2024

    AUTHOR: maalos/regex/soczek
    CONTACT: discord:maalos:339395111895040003

    THIS SCRIPT IS A PART OF OPEN-SOURCED RESOURCE ARCHIVE WRITTEN BY maalos, FREE TO USE, MODIFY
]]

-- pseudo enums
-- state
DISABLED = 0
ENABLED = 1

-- policy (NO_TRUST disables clientside seteldata, STRONG checks the client and the allowance flag, NORMAL checks client global variable, WEAK checks for the flag)
WEAK = 3
NORMAL = 2
STRONG = 1
NO_TRUST = 0

-- action to take on detection
PASSWORD_AND_SHUTDOWN = -1
BAN = 0
KICK = 1
LOG = 2
DISABLED = 3
MUTE = 4
WARN = 5

-- logging type
BASIC = 0
VERBOSE = 1 -- logs even the OK ones

-- log type
GENERAL = 1
MISC_CHEATING = 2
EVENT_HACKING = 3
ELDATA_HACKING = 4
AC_DETECTIONS = 5
CLIENT_MODS = 6

-- global JI configuration
config = {
    version = "0.7",

    logging = {
        discordWebhookUrl = "https://discord.com/api/webhooks/.../...",
    },
    
    events = {
        state = ENABLED,
        policy = NO_TRUST,
        logging = BASIC,
        action = KICK, -- default action, recommended to set to BAN

        damage = {
            check_damage_justification = ENABLED,
            check_stealth_kills = ENABLED,
            action = KICK,
        },

        explosions = {
            check_satchel_detonator_ownage = ENABLED,
            check_projectile_creators = ENABLED,
            action = KICK,
        },
    },

    chat_commands = {
        execution_interval = 200,
        max_commands_per_second_before_action = 10,
        command_spam_action = WARN,
        chat_spam_action = WARN,
        blocked_commands = {
            "whois",
            "register",
            "chgpass",
            "chgmypass",
        },
        prohibited_commands = {
            "run",
            "crun",
            "srun",
            "debugscript",
        },
        prohibited_commands_action = KICK,
    },

    auto_clicker = {
        state = ENABLED,
        max_cps = 15,
        action = KICK,
    },

    elementdata = {
        state = ENABLED,
        policy = NORMAL,
        logging = BASIC,
        protected_keys = {
            -- "ji.ped.frozen", -- for freezing with no option to unfreeze
            -- "ji.ped.armor",
            -- "ji.ped.health",
            -- "ji.player.money",
            -- "ji.ped.gangdriveby", -- this one and all the ones above are disabled/unused because of different

            "ji.flag.allowWeaponUpdate", -- set to true when giving a weapon clientside

            -- owlgaming
            "admin_level",
            "hiddenadmin",
            "supporter_level",
            "loggedin",
            "account:id",
            "reconx",
            "recontp",
            "account:username",
            "invisible",
            "money",
            "bankmoney",
            "character:credits",
        },
        protected_keys_action = KICK,

        whitelisted_keys = {
            -- keys that can be changed by the client without any restrictions
            "hedit:saved",

        }
    },

    scan_for_high_ping_delay = 2000,
    high_ping_threshold = 500,

    ac_stuff = {
        state = ENABLED,
        resend_time = 120000,
        action = LOG,
    },

    movement_cheats = {
        state = ENABLED,
        check_time = 3000,
    },

    whitelistedSerials = {
        ["777AE7A158C07DA91B2E93B7AB874B93"] = false, -- maalos
        -- add your serial here, disables all punishments and logging
    },

    weapons = {
        check_for_flag = DISABLED, -- check if the flag that allows for weapon change is enabled, without it giving weapons is permitted
    },
}
