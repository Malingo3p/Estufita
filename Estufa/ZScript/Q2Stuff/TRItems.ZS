Class Q2Magslug : Ammo
{
	Default {
	Inventory.PickupMessage "Magslugs.";
	Inventory.Amount 5;
	Inventory.MaxAmount 50;
	Ammo.BackPackAmount 5;
	Ammo.BackPackMaxAmount 100;
	Inventory.Icon "A_MSLUGS"; }
	States
	{
	Spawn:
		CELP A -1;
		Stop;
	}
}