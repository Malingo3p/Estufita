Class Q2MarineShotgun : Q2MonsterBase
{
	Default {
	Health 100;
	radius 16;
    height 56;
	DeathSound "Grunt/Death";
	PainSound "Grunt/Pain100";
	AttackSound "Weapons/ShotgunFire";
	+NOINFIGHTSPECIES
	Obituary "%o is dead, not big surprise.";
	DropItem "Q2Shell", 128;
	DropItem "Q2Shotgun", 64; }
	Void A_MarineSGAttack()
	{
		double a=angle;
		A_SpawnItemEx("EnemyFlashSpawner",12,10,31);
		A_SpawnItem("WeaponFlash",0,32);
		A_CustomBulletAttack(8,8,10,4*FRandom(1,2),"BulletPuff",0,CBAF_NORANDOM);
		angle=a;
		A_SmoothFace(target);
	}
	States
	{
	Spawn:
		GRN0 A 6 A_Look;
		Loop;
	See:
		GRN0 Q 0 { bNoPain=False; }
		GRN0 QRSTUV 3 A_SmoothChase;
		Loop;
	Missile:
		"----" A 1 { special1=0; }
		"----" A 8 A_SmoothFace(target);
		GRN1 A 1 A_MarineSGAttack;
		GRN1 A 4 A_SmoothFace(target,10);
		GRN1 B 1 A_SmoothFace(target,10);
		GRN1 B 0 A_PlaySound("Weapons/ShotgunPump",0);
		GRN1 CDE 4 A_SmoothFace(target,10);
		GRN1 FGH 4 A_SmoothFace(target,10);
		Goto See;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
		"----" A 3;
		GRN1 IJKL 3;
		Goto See;
	Pain2:
		"----" A 3;
		GRN1 MNOP 3;
		Goto See;
	Pain3:
		"----" A 3;
		GRN1 QRST 3;
		Goto See;
	Death:
		"----" A 0 A_Scream;
		"----" A 0 A_Jump(256,"Death1","Death2","Death3");
	Death1:
		"----" A 3;
		GRN2 AB 6;
		GRN2 C 6 A_NoBlocko;
		GRN2 DE 6;
		GRN2 F -1;
		Stop;
	Death2:
		"----" A 3;
		GRN2 GH 6;
		GRN2 I 6 A_NoBlocko;
		GRN2 JK 6;
		GRN2 L -1;
		Stop;
	Death3:
		"----" A 3;
		GRN2 NO 6;
		GRN2 P 6 A_NoBlocko;
		GRN2 QRS 6;
		GRN2 T -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}

Class Q2MarineMachinegun : Q2MonsterBase
{
	Default {
	Health 100;
	radius 16;
    height 56;
	DeathSound "Grunt/Death";
	PainSound "Grunt/Pain100";
	AttackSound "Weapons/MachineGunFire";
	+NOINFIGHTSPECIES
	Obituary "%o is dead, not big surprise.";
	DropItem "Q2Bullets", 128;
	DropItem "Q2MachineGun", 64; }
	Void A_MarineMGAttack()
	{
		double a=angle;
		A_SpawnItemEx("EnemyFlashSpawner",12,10,31);
		A_SpawnItem("WeaponFlash",0,32);
		A_CustomBulletAttack(8,8,1,2*FRandom(1,2),"BulletPuff",0,CBAF_NORANDOM);
		angle=a;
		A_SmoothFace(target);
	}
	States
	{
	Spawn:
		GRN0 A 6 A_Look;
		Loop;
	See:
		GRN0 Q 0 { bNoPain=False; }
		GRN0 QRSTUV 3 A_SmoothChase;
		Loop;
	Missile:
		"----" A 1 { special1=0; }
		"----" A 8 A_SmoothFace(target);
		GRN1 A 3 A_MarineMGAttack;
		GRN1 A 1 A_CPosRefire;
		Goto Missile+2;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
		"----" A 3;
		GRN1 IJKL 3;
		Goto See;
	Pain2:
		"----" A 3;
		GRN1 MNOP 3;
		Goto See;
	Pain3:
		"----" A 3;
		GRN1 QRST 3;
		Goto See;
	Death:
		"----" A 0 A_Scream;
		"----" A 0 A_Jump(256,"Death1","Death2","Death3");
	Death1:
		"----" A 3;
		GRN2 AB 6;
		GRN2 C 6 A_NoBlocko;
		GRN2 DE 6;
		GRN2 F -1;
		Stop;
	Death2:
		"----" A 3;
		GRN2 GH 6;
		GRN2 I 6 A_NoBlocko;
		GRN2 JK 6;
		GRN2 L -1;
		Stop;
	Death3:
		"----" A 3;
		GRN2 NO 6;
		GRN2 P 6 A_NoBlocko;
		GRN2 QRS 6;
		GRN2 T -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}