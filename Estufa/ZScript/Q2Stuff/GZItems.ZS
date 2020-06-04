Class Q2FlachetteAmmo : Ammo
{
	Default {
	Inventory.PickupMessage "Flachettes.";
	Inventory.Amount 50;
	Inventory.MaxAmount 200;
	Ammo.BackPackAmount 5;
	Ammo.BackPackMaxAmount 100;
	Inventory.Icon "A_FLECHS"; }
	States
	{
	Spawn:
		FLCA A -1;
		Stop;
	}
}