Class Q2RipperGuard : Q2GuardBase
{
	Default {
    Health 50;
    Mass 104;
    Obituary "%o was ripped in two by a \cmRipper \c[g4]Guard";
	Tag "\cmRipper \c[g4]Guard";
    Species "IRGuard";
	AttackSound "Q2Soldier/Blaster";
	MissileType "RipperGuardProjectile";
	+NOINFIGHTSPECIES
    DropItem "Q2Cell", 50; }
	Void A_GuardRipper(Vector2 XYOffs)
	{
		If(Health>0)
		{
			A_SmoothFace(target);
			A_SpawnProjectile(MissileName,XYOffs.X,XYOffs.Y);
		}
		Else
		A_SpawnProjectile(MissileName,XYOffs.X,XYOffs.Y,0,2);
		A_PlaySound(AttackSound,CHAN_WEAPON);
		A_SpawnItem("WeaponFlash",0,32);
	}
	States
	{
	Missile:
		"----" A 0 A_Jump(256,"IonRipper", "IonRipper2","RipperRun");
		Stop;
	IonRipper:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRDA ABCD 4 A_SmoothFace(target);
        GRDA EFG 4 A_GuardRipper((42,10));
		GRDA HPQR 3 A_SmoothFace(target,10);
		Goto See;
	IonRipper2:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRD2 HI 4 A_SmoothFace(target);
        GRD2 IJK 4 A_GuardRipper((32,10));
		GRD2 LMPQRS 4 A_SmoothFace(target,10);
		Goto See;
	RipperRun:
		"----" A 5 A_SmoothChase(null,null);
		GR15 CDE 4 { A_SmoothChase(null,null); A_GuardRipper((38,12)); }
		GR15 FGHI 4 A_SmoothChase(null,null);
		GR15 J 4 { A_SmoothChase(null,null); A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.66); }
		GR15 KLMN 4 A_SmoothChase(null,null);
		Goto See;
	Death2Special:
		GRD6 D 4 A_GuardRipper((15,3));
		GRD6 EF 4;
		GRD6 D 0 A_GuardRipper((15,3));
		Goto Death2Proceed;
	}
}
Class RipperGuardProjectile : IonRipperProjectile { Default { Damage 3; } }

Class Q2HyperBlasterGuard : Q2GuardBase
{
	Default {
    Health 60;
    Mass 105;
    Obituary "%o was killed by an HyperBlaster Guard";
	Tag "Hyper Blaster Guard";
    Species "HBGuard";
	+NOINFIGHTSPECIES
	AttackSound "Tank/Attack2";
	MissileType "HBGuardProjectile";
    DropItem "Q2Cell", 64; }
	Void A_HyperBlaster(Vector2 XYOffs, int position=0)
	{
		If(Health>0)
		{
			A_SmoothFace(target);
			A_SpawnProjectile(MissileName,XYOffs.X,XYOffs.Y);
		}
		Else
		A_SpawnProjectile(MissileName,XYOffs.X,XYOffs.Y,0,2);
		A_PlaySound(AttackSound,CHAN_WEAPON);
		A_GuardMuzzleFlash(position);
	}
	States
	{
	Missile:
		"----" A 0 A_Jump(256,"HyperBlasterReady", "HyperBlaster2Ready","HyperRun");
		Stop;
	HyperBlasterReady:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRDA A 4 A_SmoothFace(target);
		GRDA ABC 4 A_SmoothFace(target);
		Goto HyperBlaster1;
	HyperBlaster1:
        GRDA D 4 A_SmoothFace(target);
        TNT1 A 0 A_PlaySound("Weapons/HyperBlasterLoop",CHAN_5,0.75);
        GRDA E 4 A_HyperBlaster((42,10),0);
        GRDA F 3 A_HyperBlaster((42,10),0);
        GRDA G 4 A_HyperBlaster((42,10),0);
        GRDA D 3 A_SmoothFace(target);
        TNT1 A 0 A_Jump (64, "HyperBlaster1Stop");
        TNT1 A 0 A_MonsterRefire(40,2);
        Goto HyperBlaster1;
	HyperBlaster1Stop:
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterStop",CHAN_5);
		GRDA HIJK 4 A_SmoothFace(target);
		GRDA L 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRDA LMNOPQR 4 A_SmoothFace(target,10);
		Goto See;
	HyperBlaster2Ready:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRD2 HI 4 A_FaceTarget;
		Goto HyperBlaster2;
    HyperBlaster2:
        TNT1 A 0 A_PlaySound("Weapons/HyperBlasterLoop",CHAN_5,0.75);
        GRD2 I 4 A_SmoothFace(target);
        GRD2 I 3 A_HyperBlaster((32,10),1);
        GRD2 J 4 A_HyperBlaster((32,10),1);
        GRD2 K 3 A_HyperBlaster((32,10),1);
        GRD2 LM 3 A_SmoothFace(target,10);
        TNT1 A 0 A_Jump (64, "HyperBlaster2Stop");
        TNT1 A 0 A_MonsterRefire(40,2);
        Goto HyperBlaster2;
	 HyperBlaster2Stop:
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterStop",CHAN_5);
		GRD2 M 4 A_SmoothFace(target,10);
		GRD2 N 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRD2 NOPQRS 4 A_SmoothFace(target,10);
		Goto See;
	HyperRun:
		"----" A 5 A_SmoothChase(null,null);
		GR15 C 3 { A_SmoothChase(null,null); A_HyperBlaster((42,10)); }
		GR15 D 4 { A_SmoothChase(null,null); A_HyperBlaster((42,10)); }
		GR15 E 3 { A_SmoothChase(null,null); A_HyperBlaster((42,10)); }
		GR15 FGHI 4 A_SmoothChase(null,null);
		GR15 J 4 { A_SmoothChase(null,null); A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.66); }
		GR15 KLMN 4 A_SmoothChase(null,null);
		Goto See;
    Death2Special:
        GRD6 D 0 A_HyperBlaster((15,3),2);
        GRD6 DEF 4;
        GRD6 D 0 A_HyperBlaster((15,3),2);
        Goto Death2Proceed;
	}
}

Class HBGuardProjectile : HyperBlasterProjectile
{
	Default { Damage 3; Speed 28; +STRIFEDAMAGE }
	States
	{
	Spawn:
		NULL A 1 Light("BlueBlaster") Bright A_PlaySound("Weapons/LaserFly",CHAN_VOICE,0.5,1);
		Loop;
	Death:
		TNT1 A 0 A_SpawnItem("BlasterProjectileImpact");
		TNT1 A 3 Light("BlueProjectile_X1");
		TNT1 A 3 Light("BlueProjectile_X2");
		TNT1 A 3 Light("BlueProjectile_X3");
		TNT1 A 3 Light("BlueProjectile_X4");
		Stop;
	}
}

Class Q2LaserGuard : Q2GuardBase
{
	Default {
    Health 70;
    Obituary "%o was killed by a Laser Guard";
	Tag "Laser Guard";
    Species "LAGuard";
	+NOINFIGHTSPECIES
	DropItem "Q2Cell", 70; }
	Void A_GuardLaser(Int Position=1)
	{
		If(!target) Return;
		A_SmoothFace(target);
		Vector3 P;
		Switch(Position)
		{
			Case 0: P=(32,-12,38); Break; // with extended arm
			Case 1: P=(14,-11,29); Break; // down
		}
		P.XY=RotateVector(P.XY,Angle);
		Target.SetOrigin(Target.Pos-target.vel*(tics+1),1);
		Actor Beam=SpawnMissileXYZ(P+Pos,target,"LaserGuardBeam",1,Self);/*
		Vector3 Dest=Target.Pos+(0,0,Target.Height/2);
		Vector2 Dir=Q2StuffLib.FaceVector(Dest,Beam.Pos);
		Beam.Vel=Q2StuffLib.Vec3ToDir(Beam.Speed,Dir.X,Dir.Y);*/
		Target.SetOrigin(Target.Pos+target.vel*(tics+1),1);
	}
	States
	{
	Missile:
        "----" A 0 A_Jump(256,"Laser", "Laser2");
		Stop;
	Laser:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRD2 H 5 A_SmoothFace(target);
		GRD2 I 0 A_PlaySound("Weapons/LaserFly",CHAN_VOICE,0.5);
		GRD2 IIIII 3 A_GuardLaser;
		GRD2 J 0 A_StopSound(CHAN_VOICE);
		GRD2 JLM 4 A_SmoothFace(target,10);
		Goto See;
	Laser2:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRD2 H 5 A_SmoothFace(target);
		GRD2 I 0 A_PlaySound("Weapons/LaserFly",CHAN_VOICE,0.5);
		GRD2 IIIIIIIIIII 3 A_GuardLaser;
		GRD2 J 0 A_StopSound(CHAN_VOICE);
		GRD2 JLM 4 A_SmoothFace(target,10);
		Goto See;
	}
}
Class LaserGuardBeam : BFG10KBeam
{
	States
	{
	Death:
		TNT1 A 0
		{
			bMissile=0;
			If(Damage>0)
			A_SpawnItem("GreenPuffNoSnd");
		}
		TNT1 AA 1;
		TNT1 AAA 1
		{

			Actor Zap=Spawn("LightningBeamBase",Origin,ALLOW_REPLACE);
			Zap.A_SetRenderStyle(0.5,STYLE_SHADED);
			Zap.SetShade("Red");
			Zap.Tracer=Self;
			Zap.Scale.X=2;
			Zap.ReactionTime=0;
		}
		Stop;
	}
}

/*
Class IronMaidenBC : IronMaiden
{
	Species "IronMaidenBC"
	Obituary "%o almost dodged an \cmIron \c[g4]Maiden's \Lrocket"
	HitObituary "%o was bitch-slapped by an \c[g5]Iron \c[g4]Maiden"
	Tag "\cmIron \c[g4]Maiden (Beta Class)"
	States
	{
	Missile:
		TNT1 A 0 A_PlaySound("IronMaiden/Attack1",CHAN_VOICE)
		BTC3 ABCDEFGHIJKLM 3 A_FaceTarget
		BTC3 N 0 A_CustomMissile(IronMaidenBCRocket,42,-8)
		TNT1 A 0 A_Recoil(5)
		TNT1 A 0 A_PlayWeaponSound("IronMaiden/Attack2")
		BTC3 NOPQRST 3
		BTC3 U 3 A_PlaySound("IronMaiden/Attack5",0)
		BTC3 VWXY 3
		Goto See
	}
}

Class HomingRocketLauncherToken : Inventory { +INVENTORY.UNDROPPABLE }
Class IronMaidenBCRocket : Q2Rocket
{
    Speed 15
    Damage 10
    ExplosionDamage 64
    DontHurtShooter
	+SEEKERMISSILE
	States
	{
	Spawn:
		MIS1 AAAAA 0 A_SpawnItemEx(Q2GrenadeSmoke,Random2(5),0,Random2(5),0,0,FRandom(0.1,0.5),Random(1,360),0,128)
		TNT1 A 0 A_SpawnItemEx(Q2RocketTrail,0,0,0,FRandom(0,0.5),0,FRandom(-0.5,0),Random(1,360),128)
		TNT1 A 0 A_SeekerMissile(2,5,SMF_LOOK|SMF_PRECISE,32,3)
		TNT1 A 0 A_JumpIfTracerCloser(1024,2)
		TNT1 A 0 A_Jump(256,4)
		TNT1 A 0 A_JumpIfInventory(Clip,1,3)
		TNT1 A 0 A_GiveInventory(Clip,1)
		TNT1 A 0 A_PlaySound("Weapons/HomingRocketLock",CHAN_BODY,1,1)
		MIS1 A 1 Light(ROCKET) A_PlaySound("Weapons/RocketFly",CHAN_VOICE,0.66,1)
		Loop
	}
}
Class GladiatorBC : Gladiator
{
DropItem Q2Magslug 192

	States
	{
	Spawn:
        TNT1 A 0 NoDelay A_SpawnItemEx(GladiatorShield,0,0,0,0,0,0,0,SXF_SETMASTER|SXF_NOCHECKPOSITION)
        Goto Super::Spawn
	Idle:
		Goto Super::Spawn
	Missile:
		TNT1 A 0 A_FaceTarget
		//TNT1 A 0 A_PlayWeaponSound("Gladiator/Railgun")
		//TNT1 A 0 A_PlaySound("Weapons/PhalanxShot",CHAN_WEAPON)
		GLD1 R 8
		GLD1 S 5 A_FaceTarget
		GLD1 T 3
		TNT1 A 0 A_PlaySound("Weapons/PhalanxShot",CHAN_WEAPON)
		TNT1 A 0 A_CustomMissile(GladiatorBetaClassPhoton,42,20)
		GLD1 UVW 4 A_FaceTarget
		GLD1 X 4 A_CustomMissile(GladiatorBetaClassPhoton,42,20)
		GLD1 YZ 4
		Goto See
	Raise:
		"----" A 0 A_GiveInventory(ResurrectedToken,1)
		"----" A 25 A_StopSound(CHAN_BODY)
		"----" A 6 A_TakeInventory(ResurrectedToken,1)
		Goto Idle
	}
}
Class GladiatorBetaClassPhoton : PhalanxPhoton
{
	+THRUSPECIES +STRIFEDAMAGE +FORCERADIUSDMG
	Species "Shield"
	Damage 10
	DontHurtShooter
	ExplosionDamage 32
	ExplosionRadius 160
}
Class GladiatorShield
{
	+ISMONSTER
	+NOGRAVITY +NOBLOODDECALS
	+QUICKTORETALIATE
	PainChance 256
	BloodType "GreenPuff"
	Mass 9999
	Height 70
	Radius 28
	Health 1000
	RenderStyle Add
	Species "Shield"
	States
	{
	Spawn:
		TNT1 A 0 NoDelay// A_RearrangePointers(AAPTR_MASTER)
		TNT1 A 0 A_JumpIfInventory(GladiatorShieldProtection,1,"Null",AAPTR_MASTER)
		TNT1 A 0 A_GiveInventory(GladiatorShieldProtection,1,AAPTR_MASTER)
		TNT1 A 0 A_ChangeFlag(ISMONSTER,0)
		TNT1 A 0 A_SetShootable
	Idle:
		TNT1 A 1 A_Warp(AAPTR_MASTER,0,0,-3,0,WARPF_NOCHECKPOSITION)
		Loop
	Pain:
		TNT1 A 3 A_SpawnItemEx(ShieldEffect,0,0,32,0,0,0,0,SXF_TRANSFERPOINTERS)
		//TNT1 A 0 A_RearrangePointers(AAPTR_NULL) A_ClearTarget
		Goto Idle
	Death:
		//TNT1 A 175 A_RearrangePointers(AAPTR_MASTER)
		TNT1 A 0 A_TakeInventory(GladiatorShieldProtection,999,0,AAPTR_MASTER)
		Stop
	}
}
Class GladiatorShieldProtection : PowerProtection { DamageFactor "Normal", 0.1 Powerup.Duration 0x7fffffff }
Class ShieldEffect : EffectBase
{
	//+DONTTRANSLATE
	//Translation "0:255=%[0,0,0]:[0,0.5,1]"
	//XScale 0.75
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_FaceTarget(0,0)
		TNT1 A 0 A_SetPitch(-Pitch)
		TNT1 A 0 A_Warp(AAPTR_MASTER,0,0,32,0,WARPF_NOCHECKPOSITION|WARPF_USECALLERANGLE)
		NULL A 1 Bright A_FadeOut
		Goto Spawn+2
	}
}

Class TankBossBC : TankBoss
{
Health 2400
	States
	{
	Spawn:
        TNT1 A 0 NoDelay A_SpawnItemEx(TankBossShield,0,0,0,0,0,0,0,SXF_SETMASTER|SXF_NOCHECKPOSITION)
        Goto Super::Spawn
	}
}

Class TankBossShield : GladiatorShield
{
Health 1000
}

Class TRGekk
{ Health 125
  Radius 20
  Height 56
  Speed 12
  PainChance 114
  MeleeDamage 2
  Mass 100
  Monster
  SeeSound "Gekk/Sight"
  ActiveSound "Gekk/Idle"
  PainSound "Gekk/Pain"
  AttackSound "Gekk/Attack"
  DeathSound "Gekk/Death"
  Tag "Gekk"
  Species "Gekk"
  +DONTHURTSPECIES // Correct me if I am wrong, but I don't think they can infight between them
  Obituary "%o was caught by a Gekk"
  HitObituary "A Gekk ripped %o apart with its claw"
  States
  {
  Spawn:
    GKST ABCDEFGHIJKLMNOPQRSTUVWXYZ 4 A_Look
	GKS2 ABCDEFGHIJKLM 6 A_Look
	Loop
  Idle:
    GKID ABCDEFGHIJKLMNOPQRSTUVWXYZ 4 A_Look
	GKI2 ABCDEF 7 A_Look
	Loop
  See:
    GKRN ABCDEF 3 A_VileChase
	TNT1 A 0 A_PlaySound("Gekk/Step")
    Loop
  Melee:
    TNT1 A 0 A_Jump(256,"Melee1","Melee2","Melee3")
  Melee1:
    GKCW ABCDEFGH 4 A_FaceTarget
	GKCW I 1 A_MeleeAttack
	Goto See
  Melee2:
    GKCW JKLMNOP 4 A_FaceTarget
	GKCW Q 1 A_MeleeAttack
	Goto See
  Melee3:
    GKCW RSTUVWXY 4 A_FaceTarget
	GKCW Z 1 A_MeleeAttack
	Goto See
  Missile:
    GKAK ABCDE 6 A_FaceTarget
	GKAK FG 3
	Goto See
  LeapAttack:
    GKLP ABCDEFGHIJKLMNOPQRS 2
	Goto See
  Pain:
    TNT1 A 0 A_Jump(256,"Pain1","Pain2")
  Pain1:
    TNT1 A 0 A_Pain
    GKPN ABCDEFGHIJ 5
	Goto See
  Pain2:
    TNT1 A 0 A_Pain
    GKPN LMNOPQRSTUVWX 4
	Goto See
  Death:
    TNT1 A 0 A_Jump(80,"Death4")
    TNT1 A 0 A_Jump(256,"Death1","Death2","Death3")
  Death1:
	TNT1 A 0 A_Scream
	GKDT ABCDEFGHI 4 A_Fall
	GKDT J -1
	Stop
  Death2:
    TNT1 A 0 A_Scream
    GKDT KLMNOPQRST 5 A_Fall
	GKDT U -1
	Stop
  Death3:
    TNT1 A 0 A_Scream
	GKD2 ABCDEF 4 A_Fall
	GKD2 G -1
	Stop
  Death4:
    TNT1 A 0 A_Scream
	GKD3 ABCDEFGHIJKLMNOPQRSTUVWXYZ 3 A_Fall
	GKD_ ABCDEFGHI 3
	TNT1 A 0 A_Fall
	TNT1 A 5 A_SpawnItem(Q2GibSpawner)
	Stop
  XDeath:
    TNT1 A 0 A_Fall
	TNT1 A 5 A_SpawnItem(Q2GibSpawner)
	Stop
}}*/