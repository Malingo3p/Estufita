Class SSGReplacer : RandomSpawner Replaces SuperShotgun
{
	Default {
	DropItem "Q2SuperShotgun", 256, 100;
	DropItem "Q2Phalanx", 256, 40; }
}
Class ChaingunReplacer : RandomSpawner Replaces Chaingun
{
	Default {
	DropItem "Q2Machinegun", 256, 100;
	DropItem "IonRipper", 256, 33;
	DropItem "Q2Chaingun", 256, 33; }
}

Class RocketLauncherReplacer : RandomSpawner Replaces RocketLauncher
{
	Default {
	DropItem "Q2GrenadeLauncher";
	DropItem "Q2RocketLauncher"; }
}

Class PlasmaRifleReplacer : RandomSpawner Replaces PlasmaRifle
{
	Default {
	DropItem "Q2HyperBlaster", 256, 100;
	DropItem "Q2PlasmaBeamer", 256, 30;
	DropItem "Q2Railgun", 256, 50; }
}
Class ShellReplacer : RandomSpawner Replaces Shell
{
	Default {
	DropItem "Q2Shell", 256, 100;
	DropItem "Q2Magslug", 256, 40; }
}
Class RocketAmmoReplacer : RandomSpawner Replaces RocketAmmo
{
	Default {
	DropItem "Q2Bullets", 256, 100;
	DropItem "Q2Shell", 256, 100;
	DropItem "Q2Magslug", 256, 60;
	DropItem "Q2Cell", 256, 60;
	DropItem "Q2Trapito", 256, 10;
	DropItem "Q2GrenadeAmmoItem", 256, 20; }
}
Class RocketBoxReplacer : RandomSpawner Replaces RocketBox
{
	Default {
	DropItem "Q2Rockets", 256, 100;
	DropItem "Q2Magslug", 256, 30;
	DropItem "Q2GrenadeAmmoItem", 256, 30;
	DropItem "Q2Trapito", 256, 20; }
}
Class CellReplacer : RandomSpawner Replaces Cell
{
	Default {
	DropItem "Q2Cell", 256, 100;
	DropItem "Q2SlugPickupSmall", 256, 45; }
}
Class CellPackReplacer : RandomSpawner Replaces CellPack
{
	Default {
	DropItem "Q2CellPack", 256, 100;
	DropItem "Q2Magslug", 256, 75;
	DropItem "Q2Slugs", 256, 66; }
}

Class BackPackReplacer : RandomSpawner Replaces BackPack
{
	Default {
	DropItem "Q2Bandolier", 256, 100;
	DropItem "Q2AmmoPack", 256, 33; }
}

Class ChainSawReplacer : RandomSpawner Replaces ChainSaw
{
	Default {
	DropItem "Q2Adrenaline";
	DropItem "BackPack";
	DropItem "Q2Silencer";
	DropItem "Q2QuadDamage";
	DropItem "Q2EnvironmentSuit";
	DropItem "BlueArmor";
	DropItem "GreenArmor";
	DropItem "CellPack";
	DropItem "RocketBox";
	DropItem "ShellBox";
	DropItem "ClipBox"; }
}
Class GreenArmorReplacer : RandomSpawner Replaces GreenArmor
{
	Default {
	DropItem "Q2JacketArmor";
	DropItem "Q2CombatArmor";
	DropItem "Q2PowerShield"; }
}
Class BlueArmorReplacer : RandomSpawner Replaces BlueArmor
{
	Default {
	DropItem "Q2BodyArmor",255, 255;
	DropItem "Q2PowerShield",255, 100; }
}
Class ZombiemanReplacer : RandomSpawner Replaces Zombieman
{
	Default {
	DropItem "Q2LightGuard",  256, 61; }
}
Class ShotgunGuyReplacer : RandomSpawner Replaces Shotgunguy
{
	Default {
    DropItem "Q2ShotgunGuard", 256, 51; } 
}
Class ChaingunGuyReplacer : RandomSpawner Replaces Chaingunguy
{
	Default {
    DropItem "Q2MachinegunGuard", 256, 56;
	DropItem "Q2Infantry", 256, 28;
    DropItem "Q2LaserGuard", 256, 14; }
}
Class DoomImpReplacer : RandomSpawner Replaces Doomimp
{
	Default {
    DropItem "Q2RipperGuard", 256, 28;
    DropItem "Q2HyperBlasterGuard", 256, 28;
	DropItem "Q2LaserGuard", 256, 14; }
}
Class DemonReplacer : RandomSpawner Replaces Demon
{
	Default {
    DropItem "Q2Berserker", 256, 65;
	DropItem "Q2Parasite", 256, 8;
	DropItem "Q2Brain", 256, 3; }
}
Class SpectreReplacer : RandomSpawner Replaces Spectre
{
	Default {
    DropItem "Q2Berserker", 256, 65;
	DropItem "Q2Parasite", 256, 8;
	DropItem "Q2Brain", 256, 3; }
}
Class LostSoulReplacer : RandomSpawner Replaces LostSoul
{
	Default {
    DropItem "Q2Flyer" ; }
}
Class CacoDemonReplacer : RandomSpawner Replaces CacoDemon
{
	Default {
    DropItem "Q2Hover" ; }
}
Class PainElementalReplacer : RandomSpawner Replaces PainElemental
{
	Default {
    DropItem "Technician" ; }
}
Class RevenantReplacer : RandomSpawner Replaces Revenant
{
	Default {
	DropItem "Q2Gunner"; }
}
Class BaronOfHellReplacer : RandomSpawner Replaces BaronOfHell
{
	Default {
    DropItem "Q2Gladiator", 256, 100;
    DropItem "Q2Gladiator", 256, 10; }
}
Class HellKnightReplacer : RandomSpawner Replaces HellKnight
{
	Default {
    DropItem "Q2IronMaiden", 256, 70;
    DropItem "Q2IronMaiden", 256, 24; }
}
Class FatsoReplacer : RandomSpawner Replaces Fatso
{
	Default {
    DropItem "Q2Tank" ; }
}
Class ArachnotronReplacer : RandomSpawner Replaces Arachnotron
{
	Default {
    DropItem "Q2TankCommander" ; }
}
Class ArchVileReplacer : RandomSpawner Replaces ArchVile
{
	Default {
    DropItem "Q2Medic" ; }
}
Class CyberDemonReplacer : RandomSpawner Replaces Cyberdemon
{
	Default {
	DropItem "Q2Jorg"; }
}
Class SpiderMastermindReplacer : RandomSpawner Replaces SpiderMastermind
{
	Default {
	DropItem "Q2TankBoss", 256, 83;
	DropItem "Q2Hornet", 256, 24; }
}
Class WolfensteinssReplacer : RandomSpawner Replaces Wolfensteinss
{
	Default {
	DropItem "USMCSoldier", 256, 53; 
	DropItem "Q1Ranger", 256, 3; }
}

Class MarineShotgunReplacer : RandomSpawner Replaces MarineShotgun
{
	Default {
    DropItem "Q2MarineShotgun", 256, 51; } 
}

Class MarineChaingunReplacer : RandomSpawner Replaces MarineChaingun
{
	Default {
    DropItem "Q2MarineMachinegun", 256, 51; } 
}