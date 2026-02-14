// TibiaMapTile.cpp: implementation of the CTibiaMapTile class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "tibiaauto_util.h"
#include "TibiaMapTile.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#define new DEBUG_NEW
#endif // ifdef _DEBUG

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTibiaMapTile::CTibiaMapTile()
{
	count = 0;
	memset(items, 0, sizeof(CTibiaMapTileItem) * 14);
}

CTibiaMapTileAddress::CTibiaMapTileAddress()
{
	CTibiaMapTileAddress(0);
}

CTibiaMapTileAddress::CTibiaMapTileAddress(int initAddr = 0)
{
	// Tibia 7.72: tile = count(4) + 14 items * 12 bytes = 172 bytes
	// No stackind array in 7.72
	int *dummy = (int*)initAddr;
	int offset = 0;
	count = int(&dummy[offset++]);
	for (int i = 0; i < 14; i++)
	{
		items[i] = CTibiaMapTileItemAddress(int(&dummy[offset]));
		offset  += sizeof(CTibiaMapTileItemAddress) / sizeof(int);
	}
}
