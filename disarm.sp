//includes
#include <sourcemod>
#include <cstrike>
#include <sdktools>


//Compiler Options
#pragma semicolon 1
#pragma newdecls required

//ConVars
ConVar gc_bPlugin;
ConVar gc_bKnifes;

public Plugin myinfo = {
	name = "disarm",
	author = "shanapu",
	description = "Disarm when shot in a arm",
	version = "0.2",
	url = "shanapu.de"
};

public void OnPluginStart()
{
	CreateConVar("sm_disarm_version", "0.2", "The version of the SourceMod plugin", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	gc_bPlugin = CreateConVar("sm_disarm_enable", "1", "0 - disabled, 1 - enable plugin");
	gc_bKnifes = CreateConVar("sm_disarm_knife", "1", "0 - don't disarm knife, 1 - disarm also knifes");

	HookEvent("player_hurt", Event_PlayerHurt);
}

public Action Event_PlayerHurt(Handle event, char[] name, bool dontBroadcast)
{
	if(gc_bPlugin.BoolValue)
	{
		int victim = GetClientOfUserId(GetEventInt(event, "userid"));
		int hitgroup = GetEventInt(event, "hitgroup");
		int weapon = GetEntPropEnt(victim, Prop_Send, "m_hActiveWeapon");

		if(hitgroup == 4 || hitgroup == 5)
		{
			if(weapon != -1)
			{
				char sWeaponName[64];
				GetEdictClassname(weapon, sWeaponName, sizeof(sWeaponName));

				if (!gc_bKnifes.BoolValue && (StrContains(sWeaponName, "knife", false) != -1 || StrContains(sWeaponName, "bayonet", false) != -1))
					return Plugin_Continue;

				CS_DropWeapon(victim, weapon, true, true);
				ReplaceString(sWeaponName, sizeof(sWeaponName), "weapon_","", false);
				PrintToChatAll("%N is disarmed '%s'", victim, sWeaponName);
				PrintHintText(victim, "Wounded to the arm! You lost your weapon!");

				return Plugin_Stop;
			}
		}
	}

	return Plugin_Continue;
}
