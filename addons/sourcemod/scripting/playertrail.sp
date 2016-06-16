#include <sourcemod>
#include <sdktools>

#define VERSION "0.0.0.1"

public Plugin:myinfo =
{
	name = "PlayerTrail",
	author = "mkpoli",
	description = "Display PlayerTrail.",
	version = VERSION,
	url = ""
}

new g_Beam;
new Float:g_fLastPosition[MAXPLAYERS + 1][3];
new bool:g_bTrail[MAXPLAYERS + 1];

public void OnPluginStart()
{
	CreateConVar("sm_playertrail_version", VERSION, "Simple PlayerTrail", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	RegConsoleCmd("sm_trail", Client_PlayerTrail, "[PlayerTrail] on/off - showing the trajectory of the movement of player.");
}

public void OnMapStart()
{
	g_Beam = PrecacheModel("materials/sprites/purplelaser1.vmt", true);
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2]) 
{
	decl Float:origin[3];
	GetClientAbsOrigin(client, origin);
	DrawPreStrafeBeam(client, origin);
	g_fLastPosition[client] = origin;
}

public void DrawPreStrafeBeam(client, Float:origin[3])
{
	if (!g_bTrail[client])
		return;
	new Float:v1[3], Float:v2[3];
	v1[0] = origin[0];
	v1[1] = origin[1];
	v1[2] = origin[2];	
	v2[0] = g_fLastPosition[client][0];
	v2[1] = g_fLastPosition[client][1];
	v2[2] = g_fLastPosition[client][2];
	TE_SetupBeamPoints(v1, v2, g_Beam, 0, 0, 0, 2.5, 3.0, 3.0, 10, 0.0, {255, 255, 255, 100}, 0);
	TE_SendToClient(client);
}

public OnPlayerPutInServer(client)
{
	SetClientDefaults(client);
}

public SetClientDefaults(client)
{
	g_bTrail[client] = false;
}
 
 
public Action:Client_PlayerTrail(client, args)
{
	PlayerTrail(client);
	if (g_bTrail[client])
		PrintToChat(client, "[PT] Trail On");
	else
		PrintToChat(client, "[PT] Trail Off");
	return Plugin_Handled;
}

public PlayerTrail(client)
{
	if(g_bTrail[client])
		g_bTrail[client] = false;
	else
		g_bTrail[client] = true;
}
