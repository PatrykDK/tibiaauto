#pragma once
#include "tibiaauto_util.h"

// Tibia 7.72: map tile items are 12 bytes (3 ints)
class TIBIAAUTOUTIL_API CTibiaMapTileItem
{
public:
	CTibiaMapTileItem();
	int extra;    // +0
	int itemId;   // +4
	int quantity; // +8
};

class CTibiaMapTileItemAddress
{
public:
	CTibiaMapTileItemAddress();
	CTibiaMapTileItemAddress(int initAddr /*=0*/);
	int extra;    // +0
	int itemId;   // +4
	int quantity; // +8
};

