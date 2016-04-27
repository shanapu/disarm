//includes
#include <sourcemod>
#include <cstrike>
#include <sdktools>


//Compiler Options
#pragma semicolon 1
#pragma newdecls required

//ConVars
ConVar gc_bPlugin;

public Plugin myinfo = {
	name = "disarm",
	author = "shanapu",
	description = "Disarm when shot in a arm",
	version = "0.1",
	url = "shanapu.de"
};

public void OnPluginStart()
{
	
	CreateConVar("sm_disarm_version", "0.1", "The version of the SourceMod plugin", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	gc_bPlugin = CreateConVar("sm_disarm_enable", "1", "0 - disabled, 1 - enable plugin");
	
	
	//Hooks
	HookEvent("player_hurt", Event_PlayerHurt);
	
}



public Action Event_PlayerHurt(Handle event, char[] name, bool dontBroadcast)
{
	if(gc_bPlugin.BoolValue)
	{
	
		int victim 			= GetClientOfUserId(GetEventInt(event, "userid"));
		int hitgroup		= GetEventInt(event, "hitgroup");
		int hClientWeapon = GetEntPropEnt(victim, Prop_Send, "m_hActiveWeapon");
		
	
		if(hitgroup == 4 || hitgroup == 5)
		{
			if(hClientWeapon != -1)
			{
				CS_DropWeapon(victim, hClientWeapon, true, true);
				PrintToChatAll("%N is disarmed %i", victim, hClientWeapon);
				PrintHintText(victim, "Wounded to the arm! You lost your weapon!")
				return Plugin_Stop;
			}
		}

	}	
		
}
