#pragma once
#include "tibiaauto_util.h"

#include "TibiaMapTileItem.h"

// Tibia 7.72: map tile is 172 bytes = count(4) + 14 items * 12 bytes
class TIBIAAUTOUTIL_API CTibiaMapTile
{
public:
	CTibiaMapTile();

	int count;
	CTibiaMapTileItem items[14];
};

class CTibiaMapTileAddress
{
public:
	CTibiaMapTileAddress();
	CTibiaMapTileAddress(int initAddr /*=0*/);

	int count;
	CTibiaMapTileItemAddress items[14];
};

