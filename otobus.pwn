// Creds: ajeX

#include <a_samp>
#include <sscanf2>
#include <pawn.cmd>
#include <easyDialog>

main() { }

//1752.7146, -1899.5071, 13.5613, 271.4468
#define OTOBUS_NPC_X (1752.7146)
#define OTOBUS_NPC_Y (-1899.5071)
#define OTOBUS_NPC_Z (13.5613)
#define OTOBUS_NPC_R (271.4468)

#define OTOBUS_NPC_LABEL_TEXT "{FF7733}[OTOBÜS ÞOFÖRÜ]\n{FFFFFF} Baþlamak için\n{93c47d}/isbasi"

enum e_player
{
	bool:isbasi,
	pCheckpoint
}
new PlayerData[MAX_PLAYERS][e_player];

new otobus[3], otobusnpc[1];

public OnGameModeInit()
{
	
	//Otobüsleri oluþturur.

	otobus[0] = CreateVehicle(431, 1800.5710, -1932.9688, 13.3862, 90.4434, 0xFFFFFFFF, 0xFFFFFFFF, 0, 0);
	otobus[1] = CreateVehicle(431, 1800.4041, -1924.2020, 13.3905, 83.8258, 0xFFFFFFFF, 0xFFFFFFFF, 0, 0);
	otobus[2] = CreateVehicle(431, 1800.5194, -1916.4858, 13.3943, 88.0170, 0xFFFFFFFF, 0xFFFFFFFF, 0, 0);
	
	//Otobüs iþbaþýný almanýzý saðlayan NPC.
	otobusnpc[0] = CreateActor(147, OTOBUS_NPC_X, OTOBUS_NPC_Y, OTOBUS_NPC_Z, OTOBUS_NPC_R);
	Create3DTextLabel(OTOBUS_NPC_LABEL_TEXT, 0, OTOBUS_NPC_X, OTOBUS_NPC_Y, OTOBUS_NPC_Z, 30.0, 0, -1);
	
	return 1;
}

public OnPlayerConnect(playerid)
{
	MeslekDegiskenSifirla(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	MeslekDegiskenSifirla(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerPos(playerid, 300.145, 159.45, 5.144);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(PlayerData[playerid][isbasi] == true)
	{
		OtobusAyrilis(playerid);
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
    {
		for(new i = 0; i < sizeof otobus; i++)
		{
			if(IsPlayerInVehicle(playerid, otobus[i]))
			{
				if(PlayerData[playerid][isbasi] == false)
					SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Mesleðe baþlayabilmek için iþbaþýnda olmalýsýn."), RemovePlayerFromVehicle(playerid);
				else
				{
					OtobusDialog(playerid);
				}
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerData[playerid][pCheckpoint] == 1)
	{
		PlayerData[playerid][pCheckpoint] = 0;
		FreezePlayer(playerid);
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    SetPlayerPosFindZ(playerid, fX, fY, fZ); 
    return 1;
}

CMD:isbasi(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, OTOBUS_NPC_X, OTOBUS_NPC_Y, OTOBUS_NPC_Z))
	{
		if(PlayerData[playerid][isbasi] == false)
		{
			PlayerData[playerid][isbasi] = true;
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Ýþbaþýna geçtin, otobüslere binerek mesleðe baþlayabilirsin.");
		}
		else
		{
			PlayerData[playerid][isbasi] = false;
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Ýþbaþýndan ayrýldýn.");
		}
	}
	else return SendClientMessage(playerid, -1, "{e06666}HATA:{ffffff} Ýþbaþý noktasýna yakýn deðilsin.");
	return 1;
}

MeslekDegiskenSifirla(playerid)
{
	PlayerData[playerid][isbasi] = false;
	PlayerData[playerid][pCheckpoint] = 0;

	return 1;
}

OtobusDialog(playerid)
{
	new caption[32], info[48];

	format(caption, sizeof(caption), "Otobüs Mesleði");
	format(info, sizeof(info), "Otobüs mesleðine baþlamaya hazýr mýsýn?");

	Dialog_Show(playerid, OTOBUS, DIALOG_STYLE_MSGBOX, caption, info, "Baþla", "Ýptal");

	return 1;
}

OtobusAyrilis(playerid)
{
	SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Araçtan ayrýldýðýn için tüm verilerin sýfýrlandý.");
	new vehid = GetPlayerVehicleID(playerid);
	SetVehicleToRespawn(vehid);
	MeslekDegiskenSifirla(playerid);
	return 1;
}

RandomPositions(playerid)
{
	new randpoints = random(11); //Eðer nokta arttýrýrsanýz burayý güncelleyin.

	switch(randpoints)
	{
		case 0:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 1384.7963, -1816.2880, 13.3828, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;
		}
		case 1: 
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 1693.6567,-1629.6473,13.3828, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;
		}
		case 2:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 2027.4825,-1345.0819,23.8203, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;
		}
		case 3:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 2423.2925,-1261.0089,23.8333, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;			
		}
		case 4:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 2742.1333,-1203.6300,67.4839, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;			
		}
		case 5:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 2792.7478,-1345.7960,28.5055, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;			
		}
		case 6:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 2736.3032,-1661.8198,13.0703, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;			
		}
		case 7:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 2862.3560,-1974.4596,10.9333, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;			
		}
		case 8:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 2222.0056,-1913.2017,13.3387, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;			
		}
		case 9:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 1940.7716,-1928.0336,13.3867, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;			
		}
		case 10:
		{
			SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yeni durak iþaretlendi.");
			SetPlayerCheckpoint(playerid, 1873.0223,-1607.9380,13.3828, 5.0);
			PlayerData[playerid][pCheckpoint] = 1;		
		}
	} 
	return 1;
}

stock FreezePlayer(playerid)
{
	TogglePlayerControllable(playerid, 0);
	SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Yolcular otobüse biniyor, lütfen bekleyin.");
	//UnFreezePlayer(playerid);
	SetTimerEx("UnFreezePlayer", 5000, 0, "d", playerid);
	return 1;
}

forward UnFreezePlayer(playerid);
public UnFreezePlayer(playerid)
{
	new pay = 300 + randomEx(100, 150), str[160];
	GivePlayerMoney(playerid, pay);
	TogglePlayerControllable(playerid, 1);
	format(str, sizeof(str), "{FF7733}[OTOBÜS]: {ffffff}Yolcular otobüse bindi, bir sonraki noktaya ilerleyin. [Kazanç: {6aa84f}$%d{ffffff}]", pay);
	SendClientMessage(playerid, -1, str);
	RandomPositions(playerid);
	return 1;
}

Dialog:OTOBUS(playerid, response, listitem, inputtext[])
{
	if(!response) return RemovePlayerFromVehicle(playerid), SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Baþlamak istemediðin için araçtan indirildin.");
	else
	{
		SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Mesleðe baþarýyla baþladýn.");
		SendClientMessage(playerid, -1, "{FF7733}[OTOBÜS]: {ffffff}Haritada gördüðün hedeflere sür.");

		RandomPositions(playerid);
	}
	return 1;
}

stock randomEx(min, max)
{
    new randm = random(max-min)+min;
    return randm;
}