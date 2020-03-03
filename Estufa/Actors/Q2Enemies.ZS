Class EnemyFlashSpawner : EffectBase
{
	Scale 0.75;
	States
	{
	Spawn:
		TNT1 AAAAAAAAAA 0 A_SpawnItemEx("Q2BulletPuffParticle",FRandom(0,4),0,FRandom(-4,4),FRandom(0,0.75),0,FRandom(-1,-0.25),Random(1,360),SXF_TRANSFERSCALE);
		TNT1 A 0 A_SpawnItem("Q2BulletPuffFlash");
		Stop;
	}
}
Class DestroyableBodyThing // this thing does not work on Zandronum
{
Default
    {
	Radius 25;
	Height 10;
	Health 60;
	Mass 0x7fffffff;
	+NOTARGETSWITCH;
	+NOTAUTOAIMED;
	+CORPSE;
	}
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_Warp(AAPTR_MASTER,0,0,0,0,WARPF_NOCHECKPOSITION,1);
		Stop;
		TNT1 A 0 A_SetShootable;
		TNT1 A 1 A_JumpIfInTargetInventory("ResurrectedToken",1,"Null");
		Loop;
	Death:
	Crush:
		TNT1 A 0 A_RemoveMaster;
		TNT1 AAAAAAA 0 A_SpawnItemEx("Q2Gib",Random(0,40),0,5,Random(0,1),0,2,Random(1,360));
		TNT1 A 5 A_XScream;
		Stop;
	}
}
Class ResurrectedToken : InvBoolean {}

Class Q2SoldierBase : Zombieman
{
    Default
    {
	Speed 11;
	Health 40; 
	Mass 100;
	AttackSound "";
	SeeSound "Q2Soldier/Sight";
	ActiveSound "Q2Soldier/Active";
	PainSound "Q2Soldier/Pain";
	DeathSound "Q2Soldier/Death";
	DropItem "";
	Obituary "%o fue chancleteado por tu mamasita.";
	GibHealth -30;
    }
	States
	{
	Spawn:
		GRD1 A 1 A_Jump(256,"Idle1","Idle2");
		Loop;
	Idle1:
		GRS2 ABCDEFGHIJKLMNOPQRSTUVW 4 A_Look;
		GRS2 X 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRS2 X 4 A_Look;
		GRS2 YZ 4 A_Look;
		GRS3 ABCDEFGHIJKLM 4 A_Look;
		Goto Idle2;
	Idle2:
		GRD1 ABCDEFGHIJKLMNOPQRSTUVWXYZ 4 A_Look;
		GRS1 ABCD 4 A_Look;
        TNT1 A 0 A_Jump (54, "Idle1");
        Loop;
	See:
		GRR1 A 0 A_ChangeFlag(NOPAIN,0);
		TNT1 A 0 A_TakeInventory(Clip);
		GRR1 ABCDEFG 3 A_Chase;
		Loop;
	Missile:
		TNT1 A 0 A_JumpIf(Mass==101,"BlasterATK");
		TNT1 A 0 A_JumpIf(Mass==102,"ShotgunATK");
		TNT1 A 0 A_JumpIf(Mass==103,"MachinegunATK");
		TNT1 A 0 A_JumpIf(Mass==104,"IonRipperATK");
		TNT1 A 0 A_JumpIf(Mass==105,"HyperBlasterATK");
		TNT1 A 0 A_JumpIf(Mass==106,"LaserATK");
		TNT1 A 1 A_SetMass(Random(101,106));
		Goto Pain; // 404 attack not found
	BlasterATK:
		TNT1 A 0 A_Jump(256,"Blaster", "Blaster2");
		Stop;
	Blaster:
		GRDA ABCD 5 A_FaceTarget;
		GRDA E 0 A_CustomMissile(LightGuardBlaster,32,10,Random(-3,3),CMF_OFFSETPITCH,Random(-3,3));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		GRDA EFGHPQR 4 A_FaceTarget(10);
		Goto See;
	Blaster2:
		GRD2 HI 5 A_FaceTarget;
		GRD2 J 0 A_CustomMissile(LightGuardBlaster,32,10,Random(-3,3),CMF_OFFSETPITCH,Random(-3,3));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		GRD2 JKLMPQRS 4 A_FaceTarget(10);
		Goto See;
	ShotgunATK:
		TNT1 A 0 A_Jump(256,"Shotgun", "Shotgun2");
		Stop;
	Shotgun:
		GRDA ABCD 5 A_FaceTarget;
		GRDA E 0 A_CustomBulletAttack(8,8,5,2);
		TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,32,12,38);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		GRDA EFGHIJK 4 A_FaceTarget(10);
		GRDA L 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRDA LMNOPQR 4 A_FaceTarget(10);
		Goto See;
	Shotgun2:
		GRD2 HI 5 A_FaceTarget;
		GRD2 J 0 A_CustomBulletAttack(8,8,5,2);
		TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,14,11,29);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		GRD2 JKLM 4 A_FaceTarget(10);
		GRD2 N 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRD2 NOPQRS 4 A_FaceTarget(10);
		Goto See;
	MachineGunATK:
        TNT1 A 0 A_Jump(256,"MachineGun", "MachineGun2");
		Stop;
    MachineGun:
        GRD2 H 10 A_FaceTarget;
        GRD2 IIII 4 A_GuardMachinegun;
        GRD2 JLM 4 A_FaceTarget(10);
        Goto See;
	MachineGun2:
        GRD2 H 10 A_FaceTarget;
        GRD2 IIIIIIIIIII 4 A_GuardMachinegun;
        GRD2 JLM 4 A_FaceTarget(10);
        Goto See;
	IonRipperATK:
		TNT1 A 0 A_Jump(256,"IonRipper", "IonRipper2");
		Stop;
	IonRipper:
		GRDA ABCD 4 A_FaceTarget;
        GRDA E 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
        GRDA E 4 A_CustomMissile(RipperGuardProjectile,42,10);
        GRDA F 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
        GRDA F 4 A_CustomMissile(RipperGuardProjectile,42,10);
        GRDA G 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		GRDA HPQR 3 A_FaceTarget(10);
		Goto See;
	IonRipper2:
		GRD2 HI 4 A_FaceTarget;
        GRD2 I 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
        GRD2 I 4 A_CustomMissile(RipperGuardProjectile,32,10,0);
        GRD2 I 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
        GRD2 J 4 A_CustomMissile(RipperGuardProjectile,32,10,0);
        GRD2 J 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
        GRD2 K 4 A_CustomMissile(RipperGuardProjectile,32,10,0);
		GRD2 LMPQRS 4 A_FaceTarget(10);
		Goto See;
	HyperBlasterATK:
		TNT1 A 0 A_Jump(256,"HyperBlasterReady", "HyperBlaster2Ready");
		Stop;
	HyperBlasterReady:
		GRDA A 4 A_FaceTarget;
		GRDA ABC 4 A_FaceTarget;
		Goto HyperBlaster1;
	HyperBlaster1:
        GRDA D 4 A_FaceTarget;
        TNT1 A 0 A_PlaySound("Weapons/HyperBlasterLoop",CHAN_5,0.75);
        GRDA I 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,28,10,42);
        TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
        GRDA E 4 A_CustomMissile(HBGuardProjectile,42,10);
        GRDA I 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,28,10,42);
        TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
        GRDA F 3 A_CustomMissile(HBGuardProjectile,42,10);
        GRDA G 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,28,10,42);
        TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
        GRDA G 4 A_CustomMissile(HBGuardProjectile,42,10);
        GRDA D 3 A_FaceTarget;
        TNT1 A 0 A_Jump (64, "HyperBlaster1Stop");
        TNT1 A 0 A_MonsterRefire(40,2);
        Goto HyperBlaster1
	HyperBlaster1Stop:
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterStop",CHAN_5);
		GRDA HIJK 4 A_FaceTarget(10);
		GRDA L 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRDA LMNOPQR 4 A_FaceTarget(10);
		Goto See;
	HyperBlaster2Ready:
		GRD2 HI 4 A_FaceTarget;
		Goto HyperBlaster2;
    HyperBlaster2:
        TNT1 A 0 A_PlaySound("Weapons/HyperBlasterLoop",CHAN_5,0.75);
        GRD2 I 4 A_FaceTarget;
        GRD2 I 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,14,11,29);
        TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
        GRD2 I 3 A_CustomMissile(HBGuardProjectile,32,10,0);
        GRD2 I 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,14,11,29);
        TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
        GRD2 J 4 A_CustomMissile(HBGuardProjectile,32,10,0);
        GRD2 J 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,14,11,29);
        TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
        GRD2 K 3 A_CustomMissile(HBGuardProjectile,32,10,0);
        GRD2 LM 3 A_FaceTarget(10);
        TNT1 A 0 A_Jump (64, "HyperBlaster2Stop");
        TNT1 A 0 A_MonsterRefire(40,2);
        Goto HyperBlaster2;
	 HyperBlaster2Stop:
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterStop",CHAN_5);
		GRD2 M 4 A_FaceTarget(10);
		GRD2 N 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRD2 NOPQRS 4 A_FaceTarget(10);
		Goto See;
	LaserATK:
        TNT1 A 0 A_Jump(256,"Laser", "Laser2");
		Stop;
	Laser:	
		GRD2 H 10 A_FaceTarget;
		GRD2 IIII 2
		{
            A_FaceTarget();
            A_CustomRailgun(1+Random(1,3),14,11,29,RGF_SILENT|RGF_NOPIERCING,1,0,"Q2BulletPuff",0,0,8129,0,3,0,"RedLaserBeam",-6);
        }
		GRD2 JLM 4 A_FaceTarget(10);
		Goto See;
	Laser2:
		GRD2 H 10 A_FaceTarget;
		GRD2 IIIIIIIIIII 2
		{
            A_FaceTarget();
            A_CustomRailgun(1+Random(1,3),14,11,29,RGF_SILENT|RGF_NOPIERCING,1,0,"Q2BulletPuff",0,0,8129,0,3,0,"RedLaserBeam",-6);
        }
		GRD2 JLM 4 A_FaceTarget(10);
		Goto See;
	Pain:
		TNT1 A 0 A_Pain;
		TNT1 A 0 A_ChangeFlag(NOPAIN,1);
		TNT1 A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
	    GRD3 A 4;
		GRD3 ABCDE 3;
		Goto See;
	Pain2:
	    GRD3 F 4;
		GRD3 FGHIJKL 3;
		Goto See;
	Pain3:
	    GRD3 M 4;
		GRD3 "MNOPQRSTUVXYZ[^]" 4;
		Goto See;
	Pain.Explosion:
	    TNT1 A 0 A_Pain;
		TNT1 A 0 A_ChangeFlag(NOPAIN,1);
		GRD4 A 4;
		GRD4 ABCDEFGHIJKLMNOPQ 4;
		Goto See;
	Death:
		TNT1 A 0 A_SpawnItemEx(DestroyableBodyThing,0,0,0,0,0,0,0,SXF_NOCHECKPOSITION|SXF_SETMASTER);
		TNT1 A 0 A_ScreamAndUnblock;
		TNT1 A 0 A_Jump(256,"Death1","Death2","Death3","Death4","Death5","Death6","Death7","Death8","Death9");
	Death1:
		GR12 A 4;
		GR12 ABCDEFGHIJKLMN 3;
		GR12 OPQRSTUVWXYZ 4;
		GR13 ABCDEFGHIJKLMNOPQRSTUV 4;
		GR13 WXYZ 4;
		GR14 A -1;
		Stop;
	Death2:
		GRD5 L 4;
		GRD5 "LMNOPQRSTUVWXYZ[^]" 4;
		GRD6 ABCD 4;
		GRD6 D 0 A_JumpIf(Mass==101,"Death2Blaster");
		GRD6 D 0 A_JumpIf(Mass==102,"Death2Shotgun");
		GRD6 D 0 A_JumpIf(Mass==103,"Death2MachineGun");
		GRD6 D 0 A_JumpIf(Mass==104,"Death2IonRipper");
		GRD6 D 0 A_JumpIf(Mass==105,"Death2HyperBlaster");
		GRD6 D 0 A_JumpIf(Mass==106,"Death2Laser");		
	Death2Blaster:
		GRD6 D 0 A_CustomMissile(LightGuardBlaster,15,3,Random(-5,5),2,Random(-5,5));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		GRD6 DEF 4;
		GRD6 D 0 A_CustomMissile(LightGuardBlaster,15,3,Random(-5,5),2,Random(-5,5));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		Goto Death2Proceed;
	Death2Shotgun:
		GRD6 D 0 A_CustomBulletAttack(8,8,5,2,"BulletPuff",1024,CBAF_AIMFACING);
		TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,37,5,18);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		GRD6 DEF 4;
		GRD6 G 0 A_CustomBulletAttack(8,8,5,2,"BulletPuff",1024,CBAF_AIMFACING);
		TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,37,5,18);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		Goto Death2Proceed;
	Death2Machinegun:
        GRD6 DDDDDDDDDDD 4 A_GuardMachinegun;
		GRD6 EF 4
        GRD6 GGGG 4 A_GuardMachinegun;
		Goto Death2Proceed;
	Death2IonRipper:
		GRD6 D 0 A_CustomMissile(RipperGuardProjectile,15,3,Random(-5,5),2,Random(-5,5));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		GRD6 DEF 4;
		GRD6 D 0 A_CustomMissile(RipperGuardProjectile,15,3,Random(-5,5),2,Random(-5,5));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
		Goto Death2Proceed;
    Death2HyperBlaster:
        GRD6 D 0 A_CustomMissile(HBGuardProjectile,15,3,0,2);
        TNT1 A 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,28,10,42);
        TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
        GRD6 DEF 4;
        GRD6 D 0 A_CustomMissile(HBGuardProjectile,15,3,0,2);
        TNT1 A 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx(EnemyFlashSpawner,28,10,42);
        TNT1 A 0 A_SpawnItem(WeaponFlash,0,32);
        Goto Death2Proceed;
	Death2Laser:
		GRD6 D 0 ;
		GRD6 DEF 4;
		Goto Death2Proceed;
	Death2Proceed:
		GRD6 GHIJKLMNOPQ 4;
		GRD6 R -1;
		Stop;
	Death3:
		GRD6 S 4;
		GRD6 "STUVWXYZ[^]" 4;
		GRD7 ABCDEFGHIJKLMNOPQ 4;
		GRD7 R -1;
		Stop;
	Death4:
		GRD8 A 4;
		GRD8 ABCD 4;
		GRD8 EFGHIJKLMNOPQRSTUVWXYZ 3;
		GR10 A 3;
		GR10 BCDEFGHIJKLMNOPQR 4;
		GR10 S -1;
		Stop;
	Death5:
		GRDC A 4;
		GRDC ABCDEFGHIJKL 6;
		GRDC M -1;
		Stop;
	Death6:
		GRDC N 4;
		GRDC NOPQRSTUV 4;
		GRDC W -1;
		Stop;
	Death7:
		GSD1 A 4;
		GSD1 ABCDEFGHIJKLMNOPQ 4;
		GSD1 Q -1;
		Stop;
	Death8:
		GSD2 A 4;
		GSD2 ABCDEF 4;
		GSD2 F -1;
		Stop;
	Death9:
		GSD3 A 4;
		GSD3 ABCDEFGHIJ 4;
		GSD3 J -1;
		Stop;
	XDeath:
		TNT1 A 0 A_Fall;
		TNT1 A 5 A_SpawnItem(Q2GibSpawner);
		Stop;
	Raise:
		"----" A 0 A_GiveInventory(ResurrectedToken,1);
		"----" A 25 A_StopSound(CHAN_BODY);
		"----" A 6 A_TakeInventory(ResurrectedToken,1);
		Goto See;
	Crush:
		TNT1 AAAAAAA 0 A_SpawnItemEx(Q2Gib,Random2(40),0,5,Random(0,1),0,2,Random(1,360));
		TNT1 A 5 A_XScream;
		Stop;
	}
}

Extend Class Q2SoldierBase
{
      Void A_GuardMachinegun()
      {
            A_FaceTarget();
            A_CustomBulletAttack(15,8,1,2*random(1,3),"BulletPuff",0,CBAF_NORANDOM);
            A_SpawnItemEx(EnemyFlashSpawner,14,11,29);
            A_SpawnItem(WeaponFlash,0,32);
      }
}