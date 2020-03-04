Class EnemyFlashSpawner : EffectBase
{
	Default { Scale 0.75; }
	States
	{
	Spawn:
		TNT1 AAAAAAAAAA 0 A_SpawnItemEx("Q2BulletPuffParticle",FRandom(0,4),0,FRandom(-4,4),FRandom(0,0.75),0,FRandom(-1,-0.25),Random(1,360),SXF_TRANSFERSCALE);
		TNT1 A 0 A_SpawnItem("Q2BulletPuffFlash");
		Stop;
	}
}
Class Q2MonsterBase : Zombieman
{
	Default
	{
		SeeSound "";
		ActiveSound "";
		AttackSound "";
		MeleeSound "";
		PainSound "";
		DeathSound "";
		Speed 11;
		DropItem "";
		GibHealth -30;
		+INTERPOLATEANGLES;
	}
	// Smooth chase code by TheCamaleonMaligno (borrowed from from lambda)
	Double SChaseDelta; //dest turn angle
	Int SChaseTics, SChaseCount; // how much tics takes it to turn | the tics it already turned
	Vector3 SChaseMove; // distance to travel
	State SChaseStateCalledFrom; // actor will only interpolate its movement if it is still in 'that' state
	Bool SChaseAllowInterState; // this allows the actor to interpolate its movement even if not in 'that' state
	Virtual Void A_SmoothChase(statelabel melee= 'melee', statelabel missile= 'missile', int flags=0, int smoothtics=0, Double SpeedFactor=1.0)
	{
		Double OldSpeed=Speed;
		Speed*=SpeedFactor;
		If(!q2_nosmoothmonsters)
		{
			SChaseAllowInterState=smoothtics? True:False;
			SChaseStateCalledFrom=CurState;
			State OldState=CurState;
			Double OldAng=Angle;
			Vector3 OldPos=Pos;
			Vector3 OldPrev=Prev;
			A_Chase(melee, missile, flags);
			//If(CurState!=OldState) { A_log("interrupt"); Return; }
			SChaseDelta=deltaangle(OldAng,Angle);
			SChaseTics=smoothtics>0? smoothtics : Tics;
			SChaseCount=0;
			Angle-=SChaseDelta;
			SChaseMove=Level.Vec3Diff(OldPos,Pos);
			If(SChaseMove.Length()>=Speed+1)
			SChaseMove*=0;
			Else
			SetOrigin(OldPos,False);
			Prev=OldPrev;
			If(CurState!=OldState) SChaseMove*=0;
		}
		Else
		A_Chase(melee,missile,flags);
		Speed=OldSpeed;
	}
	Virtual Void A_SmoothFace(actor faceto, double max_turn=0, double max_pitch=270,double ang_offset=0, double pitch_offset=0, double pitch_offset=0, int flags=0, double z_ofs=0, int smoothtics=0)
	{
		If(!faceto) Return;
		SChaseAllowInterState=smoothtics? True:False;
		SChaseStateCalledFrom=CurState;
		Double OldAng=Angle;
		A_Face(FaceTo,max_turn,max_pitch,ang_offset,pitch_offset,flags,z_ofs);
		SChaseDelta=deltaangle(OldAng,Angle);
		SChaseTics=smoothtics>0? smoothtics : Tics;
		SChaseCount=0;
		Angle-=SChaseDelta;
	}
	Override Void Tick()
	{
		If(!GlobalFreeze && !Level.Frozen && !bDormant)
		{
			If(q2_nosmoothmonsters) SChaseMove=(0,0,0);
			If(SChaseTics && SChaseCount<SChaseTics && (CurState==SChaseStateCalledFrom || SChaseAllowInterState))
			{
				SChaseCount++;
				A_SetAngle(Angle+=SChaseDelta/SChaseTics,SPF_INTERPOLATE);
				SetOrigin((Pos+SChaseMove/SChaseTics),1);
			}
		}
		Super.Tick();
	}
	Void A_NoBlocko()
	{
		A_NoBlocking();
		Height=GetDeathHeight();
	}
	Override Void Die(Actor source, Actor inflictor, int dmgflags,Name MeansOfDeath)
	{
		Double h=height;
		Height=Height;
		Super.Die(source,inflictor,dmgflags,meansofdeath);
		height=h;
		bShootable=bNotAutoAimed=True;
	}
	Override Int DamageMobj(actor inflictor, actor source, int damage, name mod, int flags, double angle)
	{
		Double h=height;
		If(Health<1 && !bNoDamage)
		{
			Damage/=2;
			If(damage<1) damage=1;
			If(bSolid)
			ApplyKickback(inflictor,source,damage,angle,mod,flags);
			If(Health<GetGibHealth() && !InStateSequence(Curstate,ResolveState("Crush")))
			{
				//bShootable=False;
				Height=h;
				SetStateLabel("Crush");
			}
			Health-=damage;
			Return damage;
		}
		Return Super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}
	Void A_Raised() { bNotAutoAimed=Default.bNotAutoaimed; A_StopSound(CHAN_BODY); }
	Override Bool CanCollideWith(Actor other, bool passive)
	{
		If(!other.bMissile && Health<1) Return False;
		Return True;
	}
	States
	{
	XDeath:
		TNT1 A 0 A_Fall;
		TNT1 A 5 A_SpawnItem("Q2GibSpawner");
		Stop;
	Raise:/*
		"----" A 0 A_GiveInventory("ResurrectedToken",1);
		"----" A 25 A_StopSound(CHAN_BODY);
		"----" A 6 A_TakeInventory("ResurrectedToken",1);*/

		"----" A 25;
		"----" A 6;
		Goto See;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	Crush:
		TNT1 A 1;
		TNT1 AAAAAAA 0 A_SpawnItemEx("Q2Gib",Random2(Radius),0,FRandom(5,Height),Vel.X+FRandom(-1,1),Vel.Y+FRandom(-1,1),2+Vel.Z,FRandom(1,360),SXF_ABSOLUTEVELOCITY);
		TNT1 A 5 A_XScream;
		Stop;
	}
}
Class Q2GuardBase : Q2MonsterBase
{
    Default
    {
		Health 40;
		Mass 100;
		AttackSound "";
		SeeSound "Q2Soldier/Sight";
		ActiveSound "Q2Soldier/Active";
		PainSound "Q2Soldier/Pain";
		DeathSound "Q2Soldier/Death";
		Obituary "%o fue chancleteado por tu mamasita.";
    }
	Void A_GuardDrop(Class<Actor> Item, Int Chance=256)
	{
		bool drop=Q2StuffLib.RandomChance(q2_dropchance,100);
		If(drop)
		A_DropItem(Item, Chance);
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
		GRR1 A 0 { bNOPAIN=0; }
		TNT1 A 0 A_TakeInventory("Clip");
		GRR1 ABCDEFG 3 A_SmoothChase;
		Loop;
	Missile:
		Goto Pain;
	Pain:
		TNT1 A 0 A_Pain;
		TNT1 A 0 { bNoPain=True; }
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
		TNT1 A 0{ bNoPain=True; }
		GRD4 A 4;
		GRD4 ABCDEFGHIJKLMNOPQ 4;
		Goto See;
	Death:
		"####" "#" 0 A_Scream;
		"####" "#" 0 A_Jump(256,"Death1","Death2","Death3","Death4","Death5","Death6");//,"Death7","Death8","Death9");
	Death1:
		"####" "#" 4;
		GR12 A 0 A_NoBlocko;
		GR12 ABCDEFGHIJKLMN 3;
		GR12 OPQRSTUVWXYZ 4;
		GR13 ABCDEFGHIJKLMNOPQRSTUV 4;
		GR13 WXYZ 4;
		GR14 A -1;
		Stop;
	Death2:
		"####" "#" 4;
		GRD5 A 0 A_NoBlocko;
		GRD5 "LMNOPQRSTUVWXYZ[^]" 4;
		GRD6 ABCD 4;
		GRD6 D 0 { Return FindState("Death2Special"); }
	Death2Special:
		GRD6 D 0 A_JumpIf(Mass==101,"Death2Blaster");
		GRD6 D 0 A_JumpIf(Mass==102,"Death2Shotgun");
		GRD6 D 0 A_JumpIf(Mass==103,"Death2MachineGun");
		GRD6 D 0 A_JumpIf(Mass==104,"Death2IonRipper");
		//GRD6 D 0 A_JumpIf(Mass==105,"Death2HyperBlaster");
		//GRD6 D 0 A_JumpIf(Mass==106,"Death2Laser");
	/*Death2IonRipper:
		GRD6 D 0 A_SpawnProjectile("RipperGuardProjectile",15,3,Random(-5,5),2,Random(-5,5));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem("WeaponFlash",0,32);
		GRD6 DEF 4;
		GRD6 D 0 A_SpawnProjectile("RipperGuardProjectile",15,3,Random(-5,5),2,Random(-5,5));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem("WeaponFlash",0,32);
		Goto Death2Proceed;
    Death2HyperBlaster:
        GRD6 D 0 A_SpawnProjectile("HBGuardProjectile",15,3,0,2);
        TNT1 A 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx("EnemyFlashSpawner",28,10,42);
        TNT1 A 0 A_SpawnItem("WeaponFlash",0,32);
        GRD6 DEF 4;
        GRD6 D 0 A_SpawnProjectile("HBGuardProjectile",15,3,0,2);
        TNT1 A 0 A_PlaySound("Tank/Attack2",CHAN_WEAPON);
        TNT1 A 0 A_SpawnItemEx("EnemyFlashSpawner",28,10,42);
        TNT1 A 0 A_SpawnItem("WeaponFlash",0,32);
        Goto Death2Proceed;*/
	Death2Laser:
		GRD6 D 0 ;
		GRD6 DEF 4;
		Goto Death2Proceed;
	Death2Proceed:
		GRD6 GHIJKLMNOPQ 4;
		GRD6 R -1;
		Stop;
	Death3:
		"####" "#" 4;
		GRD6 S 0 A_NoBlocko;
		GRD6 "STUVWXYZ[^]" 4;
		GRD7 ABCDEFGHIJKLMNOPQ 4;
		GRD7 R -1;
		Stop;
	Death4:
		"####" "#" 4;
		GRD8 A 0 A_NoBlocko;
		GRD8 ABCD 4;
		GRD8 EFGHIJKLMNOPQRSTUVWXYZ 3;
		GR10 A 3;
		GR10 BCDEFGHIJKLMNOPQR 4;
		GR10 S -1;
		Stop;
	Death5:
		"####" "#" 4;
		GRDC A 0 A_NoBlocko;
		GRDC ABCDEFGHIJKL 6;
		GRDC M -1;
		Stop;
	Death6:
		"####" "#" 4;
		GRDC N 0 A_NoBlocko;
		GRDC NOPQRSTUV 4;
		GRDC W -1;
		Stop;
	Death7:
		"####" "#" 4;
		GSD1 A 0 A_NoBlocko;
		GSD1 ABCDEFGHIJKLMNOPQ 4;
		GSD1 Q -1;
		Stop;
	Death8:
		"####" "#" 4;
		GSD2 A 0 A_NoBlocko;
		GSD2 ABCDEF 4;
		GSD2 F -1;
		Stop;
	Death9:
		"####" "#" 4;
		GSD3 A 0 A_NoBlocko;
		GSD3 ABCDEFGHIJ 4;
		GSD3 J -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
	Void A_GuardMuzzleFlash(Int Position)
	{
		Vector3 P;
		Switch(Position)
		{
			Case 0: P=(32,12,38); Break; // with extended arm
			Case 1: P=(14,11,29); Break; // down
			Case 2: P=(39,5,18); Break; // dead
		}
		A_SpawnItemEx("EnemyFlashSpawner",P.X,P.Y,P.Z);
		A_SpawnItem("WeaponFlash",0,32);
	}
}
Class Q2LightGuard : Q2GuardBase
{
	Default {
    Health 20;
	AttackSound "Q2Soldier/Blaster";
	MissileType "LightGuardBlaster";
    Obituary "%o was Blasted by a Light Guard";
    Species "LTGuard";
    DropItem "Q2Cell", 16; }
	Void A_GuardBlaster(Vector2 XYOffs)
	{
		If(Health>0)
		{
			A_SmoothFace(target);
			A_SpawnProjectile(MissileName,XYOffs.X,XYOffs.Y,Random(-3,3),CMF_OFFSETPITCH,Random(-3,3));
		}
		Else
		A_SpawnProjectile(MissileName,XYOffs.X,XYOffs.Y,Random(-5,5),2,Random(-5,5));
		A_PlaySound(AttackSound,CHAN_WEAPON);
		A_SpawnItem("WeaponFlash",0,32);
	}
	States
	{
	Missile:
		"----" A 0 A_Jump(256,"Blaster", "Blaster2","BlasterRun");
		Stop;
	Blaster:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRDA ABCD 5 A_SmoothFace(target);
		GRDA E 4 A_GuardBlaster((38,12));
		GRDA FGHPQR 4 A_SmoothFace(target,10);
		Goto See;
	Blaster2:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRD2 HI 5 A_SmoothFace(target);
		GRD2 J 4 A_GuardBlaster((32,10));
		GRD2 KLMPQRS 4 A_SmoothFace(target,10);
		Goto See;
	BlasterRun:
		"----" A 5 A_SmoothChase(null,null);
		//GR15 AB 4 A_SmoothChase(null,null);
		GR15 C 4 { A_SmoothChase(null,null); A_GuardBlaster((38,12)); }
		GR15 DEFGHI 4 A_SmoothChase(null,null);
		GR15 J 4 { A_SmoothChase(null,null); A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.66); }
		GR15 KLMN 4 A_SmoothChase(null,null);
		Goto See;
	Death2Special:
		GRD6 D 4 A_GuardBlaster((15,3));
		GRD6 EF 4;
		GRD6 D 0 A_SpawnProjectile("LightGuardBlaster",15,3,Random(-5,5),2,Random(-5,5));
		TNT1 A 0 A_PlaySound("Q2Soldier/Blaster",CHAN_WEAPON);
		TNT1 A 0 A_SpawnItem("WeaponFlash",0,32);
		Goto Death2Proceed;
	}
}

Class LightGuardBlaster : BlasterProjectile
{
	Default {
    Damage 3;
    +STRIFEDAMAGE
    Speed 28; }
}


Class Q2ShotgunGuard : Q2GuardBase
{
	Default {
	Health 30;
	Mass 102;
	AttackSound "Q2Soldier/Shotgun";
	Obituary "%o was Gunned Down by a Shotgun Guard";
	Species "Guard";
	+NOINFIGHTSPECIES
	DropItem "Q2Shell", 64; }
	//DropItem "Q2ShotGun", 64; }
	Void A_GuardShotgun(int p=0)
	{
		If(health>0)
		{
			A_SmoothFace(target);
			Double a=angle;
			A_CustomBulletAttack(8,8,5,2);
			angle=a;
			A_GuardMuzzleFlash(p);
		}
		Else
		{
			A_CustomBulletAttack(8,8,5,2,flags:CBAF_AIMFACING);
			A_GuardMuzzleFlash(2);
		}
	}
	States
	{
	Missile:
		"----" A 0 A_Jump(256,"Shotgun", "Shotgun2","ShotRun");
		Stop;
	Shotgun:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRDA ABCD 5 A_SmoothFace(target);
		GRDA E 4 A_GuardShotgun(0);
		GRDA FGHIJK 4 A_SmoothFace(target,10);
		GRDA L 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRDA LMNOPQR 4 A_SmoothFace(target,10);
		Goto See;
	Shotgun2:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		GRD2 HI 5 A_FaceTarget;
		GRD2 J 4 A_GuardShotgun(1);
		GRD2 KLM 4 A_SmoothFace(target,10);
		GRD2 N 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		GRD2 NOPQRS 4 A_SmoothFace(target,10);
		Goto See;
	ShotRun:
		"----" A 5 A_SmoothChase(null,null);
		GR15 C 4 { A_SmoothChase(null,null); A_GuardShotgun(0); }
		GR15 DEFGHI 4 A_SmoothChase(null,null);
		GR15 J 4 { A_SmoothChase(null,null); A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.66); }
		GR15 KLMN 4 A_SmoothChase(null,null);
		Goto See;
	Death:
		"----" A 0 A_GuardDrop("Q2Shotgun");
		Goto Super::Death;
	Death2Special:
		GRD6 D 4 A_GuardShotgun;
		GRD6 EF 4;
		GRD6 G 0 A_GuardShotgun;
		Goto Death2Proceed;
	}
}

Class Q2MachinegunGuard : Q2GuardBase
{
	Default {
    Mass 103;
    Health 40;
    AttackSound "Q2Soldier/Machinegun";
    Obituary "%o was Machinegunned by a Machinegun Guard";
    Species "SSGuard";
	+NOINFIGHTSPECIES
    DropItem "Q2Bullets", 128 ; }
    //DropItem "Q2MachineGun", 64; }
	Void A_GuardMachinegun()
	{
		If(Health>0)
		{
			A_SmoothFace(target);
			A_CustomBulletAttack(15,8,1,2*random(1,3),"BulletPuff",0,CBAF_AIMFACING|CBAF_NORANDOM);
			A_GuardMuzzleFlash(1);
		}
		Else
		{
			A_CustomBulletAttack(8,8,1,3,"BulletPuff",1024,CBAF_AIMFACING|CBAF_NORANDOM);
			A_GuardMuzzleFlash(2);
		}
	}
	States
	{
	Missile:
        "----" A 0 A_Jump(256,"MachineGun", "MachineGun2");
		Stop;
    MachineGun:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
        GRD2 H 10 A_FaceTarget;
        GRD2 IIII 4 A_GuardMachinegun;
        GRD2 JLM 4 A_SmoothFace(target,10);
        Goto See;
	MachineGun2:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
        GRD2 H 10 A_FaceTarget;
        GRD2 IIIIIIIIIII 4 A_GuardMachinegun;
        GRD2 JLM 4 A_SmoothFace(target,10);
        Goto See;
	Death:
		"----" A 0 A_GuardDrop("Q2Machinegun");
		Goto Super::Death;
	Death2Special:
        GRD6 DDDDDDDDDDD 4 A_GuardMachinegun;
		GRD6 EF 4;
        GRD6 GGGG 4 A_GuardMachinegun;
		Goto Death2Proceed;
	}
}

Class Q2Infantry : Q2MonsterBase
{
	Default {
	SeeSound "Infantry/Sight";
	ActiveSound "Infantry/Active";
	PainSound "Infantry/Pain";
	DeathSound "Infantry/Death";
	MeleeSound "Infantry/Melee";
	MeleeDamage 4;
	PainChance 60;
	Health 100;
	Speed 11;
	Mass 200;
	Obituary "%o was pumped full of lead by an \c[o6]Enforcer.";
	+NOINFIGHTSPECIES;
	GibHealth 60;
	DropItem "Q2Bullets", 120;
	Species "Enforcer";
	Tag "\c[o6]Enforcer"; }
	Void A_InfantryAttack(double spread_xy, double spread_z, int numbullets, int damageperbullets, class<Actor> pufftype="BulletPuff", double range=0, int flags=0, vector3 Offs=(0,0,32))
	{
		double a=angle;
		A_CustomBulletAttack(spread_xy,spread_z,numbullets,damageperbullets,pufftype,range, flags);
		A_PlaySound("Infantry/Attack1",CHAN_WEAPON);
		A_SpawnItemEx("EnemyFlashSpawner",Offs.X,Offs.Y,Offs.Z);
		A_SpawnItem("WeaponFlash",0,32);
		If(!(flags & CBAF_EXPLICITANGLE))
		{
			angle=a;
			A_SmoothFace(target);
		}
	}
	States
	{
	Spawn:
		INF0 A 1 A_Jump(256,"Idle1","Idle2");
		Loop;
	Idle1:
		INF0 ABCDEFGHIJIHGFEDCBA 6 A_Look;
		TNT1 A 0 A_Jump (45, "Idle2");
		Loop;
	Idle2:
	    INS0 ABCD 4 A_Look;
		TNT1 A 0 A_PlaySound("Infantry/Idle",CHAN_VOICE);
		INS0 EFGHIJKLMNOPQRSTUVWXYZ 4 A_Look;
		INS1 ABCDEFGHIJKLMNOPQRSTUVW 4 A_Look;
		Goto Idle1;
	See:
		INF0 KLMNOPQR 3 A_SmoothChase;
		Loop;
	Melee:
		"----" A 1;
		"----" A 5 { double a=angle; A_FaceTarget(); A_Recoil(-5); angle=a; A_SmoothFace(target); }
		INF1 PQR 4 A_SmoothFace(target);
		INF1 S 0 A_PlaySound("Infantry/Attack2",CHAN_WEAPON);
		INF1 ST 4 A_SmoothFace(target);
		INF1 U 3 A_MeleeAttack;
		INF1 VW 3;
		Goto See;
	Missile:
		"----" A 0 A_Jump(128,"Missile2");
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		INF1 ABCD 3 A_SmoothFace(target);
		INF1 E 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		INF1 EFGHIJ 3 A_SmoothFace(target);
		INF1 KKKKKKKK 4 A_InfantryAttack(15,8,1,3*random(1,3),"BulletPuff",0, CBAF_NORANDOM,(30,8,35));
		INF1 LMNO 4;
		INF0 K 3;
		Goto See;
	Missile2:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		INF1 ABCD 3 A_SmoothFace(target);
		INF1 E 0 A_PlaySound("Infantry/Attack3",CHAN_WEAPON,0.6);
		INF1 EFGHIJ 3 A_SmoothFace(target);
		INF1 KKKKKKKKKKKKK 4 A_InfantryAttack(15,8,1,3*random(1,3),"BulletPuff",0, CBAF_NORANDOM,(30,8,35));
		INF1 LMNO 4;
		INF0 K 3;
		Goto See;
	Pain:
		"----" A 0 { A_Pain(); bNOPAIN=1; }
		"----" A 0 A_Jump(256,"Pain1","Pain2");
	Pain1:
		"----" A 6;
		INF2 ABCDEF 6;
		Goto See;
	Pain2:
		"----" A 6;
		INF2 GHIJKL 6;
		Goto See;
	Death:
		"----" A 0;
		"----" A 0 A_Jump(256,"Death1","Death2","Death3");
	Death1:
		"----" A 4 A_PlaySound("Infantry/Death2",CHAN_VOICE);
		INF3 A 0 A_NoBlocko;
		INF3 ABCDEFGHIJKLMNOPQRS 4;
		INF3 T -1;
		Stop;
	Death2:
		"----" A 4 A_PlaySound("Infantry/Death1",CHAN_VOICE);
		INF4 ABCDEFGHI 4;
		INF4 J 4 A_InfantryAttack(0,0,1,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(28,9,40));
		INF4 K 4 A_InfantryAttack(-3,-1,1,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(28,10,40));
		INF4 L 4 A_InfantryAttack(-8,-2,2,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(24,13,40));
		INF4 M 4 A_InfantryAttack(-4,-4,1,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(24,16,40));
		INF4 N 4 A_InfantryAttack(-6,-8,4,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(25,20,40));
		INF4 O 4 A_InfantryAttack(-10,-10,1,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(24,22,40));
		INF4 P 4 A_InfantryAttack(-15,-15,1,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(24,23,42));
		INF4 Q 4 A_InfantryAttack(-20,-20,1,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(24,25,44));
		INF4 R 4 A_InfantryAttack(-30,-25,1,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(22,27,46));
		INF4 S 4 A_InfantryAttack(-45,-30,1,3*random(1,3),"BulletPuff",1024,CBAF_AIMFACING|CBAF_EXPLICITANGLE|CBAF_NORANDOM,(20,28,48));
		INF4 U 4 A_NoBlocko;
		INF4 VWXY 4;
		INF4 Z -1;
		Stop;
	Death3:
		"----" A 5 A_PlaySound("Infantry/Death2",CHAN_VOICE);
		INF5 A 0 A_NoBlocko;
		INF5 ABCDEFG 5;
		INF5 H -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}

Class Q2Berserker : Q2MonsterBase
{
	Default {
	SeeSound "Berserker/Sight";
	ActiveSound "Berserker/Active";
	PainSound "Berserker/Pain";
	DeathSound "Berserker/Death";
	Health 240;
	Speed 20;
	MeleeDamage 5;
	PainChance 60;
	Mass 200;
	Obituary "%o was hit by a \c[d5]Berserker.";
	Species "Berserker";
	Tag "\c[d5]Berserker"; }
	Void A_BerkserkerAttack(bool up=true)
		{
			double a=angle;
			MeleeRange+=20;
			If(CheckMeleeRange())
			{
				A_CustomMeleeAttack(MeleeDamage*Random(1,5),"","","Melee",false);
				If(up)
				target.vel=(0,0,11);
				else
				target.Vel3DFromAngle(11,angle-90,-35);
				angle=a;
			}
			A_SmoothFace(target);
			MeleeRange-=20;
		}
	States
	{
	Spawn:
		BRS0 ABCDE 6 A_Look;
		BRS0 A 0 A_Jump(64,1);
		Loop;
		BRS0 F 0 A_PlaySound("Berserker/Idle",CHAN_WEAPON);
		BRS0 FGHJIJKLMNOPQRSTUVWXY 6 A_Look;
		Goto Spawn+1;
	See:
		BRS1 A 0 { bNOPAIN=0; }
		BRS1 ABCDEF 3 A_SmoothChase;
		Loop;
	Melee:
		TNT1 A 0 A_PlaySound("Berserker/Attack",CHAN_WEAPON);
		TNT1 A 0 A_Jump(128,"Melee2");
		BRS1 GH 4 A_SmoothFace(target);
		BRS1 I 4 A_BerkserkerAttack;
		BRS1 JKLMNO 4 A_SmoothFace(target);
		Goto See;
	Melee2:
		BRS1 PQRS 3 A_SmoothFace(target);
		BRS1 T 4 A_BerkserkerAttack(false);
		BRS1 UVWXYZ 4 A_SmoothFace(target);
		Goto See;
	Missile:
		Stop;
	Pain:
		"----" A 3 { bNOPAIN=1; A_Pain(); }
		BRS2 ABCD 5;
		Goto See;
	Death:
		"----" A 0 A_Scream;
		"----" A 0 A_Jump(256,"Death1","Death2");
	Death1:
		"----" A 4;
		BRS2 E 0 A_NoBlocko;
		BRS2 EFGHIJKLMNOP 4;
		BRS2 Q -1;
		Stop;
	Death2:
		"----" A 4;
		BRS2 R 0 A_NoBlocko;
		BRS2 RSTUVWX 4;
		BRS2 Y -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}

Class Q2Gunner : Q2Infantry
{
	Default {
	Health 175;
	PainChance 80;
	SeeSound "Gunner/Sight";
	ActiveSound "Gunner/Active2";
	PainSound "Gunner/Pain";
	DeathSound "Gunner/Death";
	AttackSound "Gunner/Attack2";
	Obituary "%o was killed by a \cmGunner.";
	+NOINFIGHTSPECIES
	Mass 250;
	GibHealth 60;
	//DamageType "Rocket";
	PainChance "Railgun", 250;
	DropItem "Q2Bullets", 192;
	DropItem "Q2GrenadeAmmoItem", 128;
	Species "Gunner";
	Tag "\cmGunner"; }
	Void A_GunnerGrenade()
	{
		A_SpawnProjectile("GunnerGrenade",32,-15,0,CMF_OFFSETPITCH,-10);
		A_PlaySound("Gunner/Attack3",CHAN_WEAPON);
		A_SmoothFace(target);
	}
	States
	{
	Spawn:
		GNR0 ABCDEFGHIJKLMNONMLKJIHGFEDCB 6 A_Look;
		GNR0 A 0 A_Jump(128,1);
		Loop;
		GNR0 PQRSTUV 5 A_Look;
		GNR0 W 0 A_PlaySound("Gunner/Active",CHAN_WEAPON,0.75);
		GNR0 W 6 A_Look;
		GNR0 "XYZ[^]" 5 A_Look;
		GNR1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[" 5 A_Look;
		Loop;
	See:
		GNR2 A 0 { bNOPAIN=0; }
		GNR2 ABCDEFGH 3 A_SmoothChase();
		Loop;
	Melee: Stop;
	Missile:
		"----" A 0 A_Jump(192,"Machinegun","Machinegun2");
		"----" A 0 A_JumpIfCloser(260,"Grenades");
    Machinegun:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		GNR3 HI 3 A_SmoothFace(target);
		GNR3 J 3 A_PlaySound("Gunner/Attack1",CHAN_WEAPON);
		GNR3 KLM 4 A_SmoothFace(target);
		GNR3 N 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 O 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 P 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 Q 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 R 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 S 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 T 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 U 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 V 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 W 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 N 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 O 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 P 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 Q 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 R 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 S 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 T 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 U 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 V 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 W 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 N 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 O 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 P 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 Q 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 R 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 S 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 T 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 U 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 V 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 W 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 N 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 O 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 P 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 Q 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 R 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 S 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 T 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 U 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 V 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 "XYZ[^]" 3;
		Goto See;
	Machinegun2:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		GNR3 HI 3 A_SmoothFace(target);
		GNR3 J 3 A_PlaySound("Gunner/Attack1",CHAN_WEAPON);
		GNR3 KLM 4 A_SmoothFace(target);
		GNR3 N 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 O 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 P 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 Q 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 R 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 S 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 T 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 U 4 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 V 3 A_InfantryAttack(8,8,1,2,offs:(34,5+FRandom(-1,1),45+FRandom(-1,1)));
		GNR3 "XYZ[^]" 3;
		Goto See;
	Grenades:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		GNR2 IJ 3 A_SmoothFace(target);
		GNR2 K 3 A_GunnerGrenade;
		GNR2 LMJ 3 A_SmoothFace(target);
		GNR2 K 3 A_GunnerGrenade;
		GNR2 LMJ 3 A_SmoothFace(target);
		GNR2 K 3 A_GunnerGrenade;
		GNR2 LMJ 3 A_SmoothFace(target);
		GNR2 K 3 A_GunnerGrenade;
		GNR2 LMJI 3 A_SmoothFace(target);
		GNR2 NOPQRST 4;
		Goto See;
	Pain:
		"----" A 0 { bNOPAIN=1; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2");
	Pain.Railgun:
		"----" A 6 { bNOPAIN=1; A_Pain(); }
		GNR4 ABCDEFHI 6;
		Goto See;
	Pain.Explosion:
		"----" A 6 { bNOPAIN=1; A_Pain(); }
		GNR4 ABCDEFHI 6;
		Goto See;
	Pain1:
		"----" A 5;
		GNR4 JKLMNOPQ 5;
		Goto See;
	Pain2:
		"----" A 6;
		GNR4 RSTUV 6;
		Goto See;
	Death:
		"----" A 5 A_Scream;
		GNR5 A 5 A_NoBlocko;
		GNR5 BCDEFGHI 5;
		GNR5 J -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}
Class GunnerGrenade : Q2Grenade
{
	Default
	{
		Speed 16;
		Scale 0.8;
		DontHurtShooter;
		Damage 0;
		ExplosionDamage 25;
	}
}

Class Q2Flyer : Q2MonsterBase
{
	Default {
	SeeSound "Flyer/Sight";
	ActiveSound "Flyer/Active";
	PainSound "Flyer/Pain";
	DeathSound "Flyer/Death";
	AttackSound "";
	Obituary "%o was shoot down by a \c[d5]Flyer.";
	MeleeDamage 3;
	Speed 8;
	+NOGRAVITY +FLOAT +FLOATBOB +DONTFALL +DONTGIB
	+NOINFIGHTSPECIES
	Health 60;
	PainChance 30;
	DropItem "Q2Cell", 100;
	Species "Flyer";
    Tag "\c[d5]Flyer"; }
	Void A_FlyerAttack(Vector2 Offs)
	{
		A_SpawnProjectile("FlyerProjectile",Offs.X,Offs.Y);
		A_PlaySound("Flyer/Attack",CHAN_WEAPON);
		A_SmoothFace(target);
	}
	States
	{
	Spawn:
		FLR1 A 0 NoDelay A_PlaySound("Flyer/Fly",CHAN_BODY,0.5,1);
		FLR1 ABCDEFGHIJKLMNOPQRSTUV 3 A_Look;
		Goto Spawn+1;
	See:
		FLR1 A 0 { bNoPain=False; }
		FLR1 ABCDEFGHIJKLMNOPQRSTUV 3 A_SmoothChase;
		Loop;
	Melee:
		"----" A 0 A_PlaySound("Flyer/Melee1",CHAN_WEAPON);
		"----" A 5;
		FLR3 ABCDEFGHI 4 A_SmoothFace(target);
		FLR3 J 0 A_PlaySound("Flyer/Melee2",CHAN_WEAPON);
		FLR3 J 3 A_MeleeAttack;
		FLR3 KLM 4 A_SmoothFace(target);
		FLR3 N 0 A_PlaySound("Flyer/Melee2",CHAN_WEAPON);
		FLR3 N 3 A_MeleeAttack;
		FLR3 OPQRSTU 4 A_SmoothFace(target);
		Goto See;
	Missile:
		FLR1 A 8 A_SmoothFace(target);
		FLR2 ABCD 3 A_SmoothFace(target);
		FLR2 E 3 A_FlyerAttack((15,-15));
		FLR2 F 4 A_FlyerAttack((15,17));
		FLR2 G 3 A_FlyerAttack((15,-15));
		FLR2 H 4 A_FlyerAttack((15,17));
		FLR2 I 3 A_FlyerAttack((15,-15));
		FLR2 J 4 A_FlyerAttack((15,17));
		FLR2 K 3 A_FlyerAttack((15,-15));
		FLR2 L 4 A_FlyerAttack((15,17));
		FLR2 MNOPQ 3;
		Goto See;
	Pain:
		TNT1 A 0 { bNoPain=True; A_Pain(); }
		TNT1 A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
		FLR4 ABCDEFGH 5;
		Goto See;
	Pain2:
		FLR4 IJKL 5;
		Goto See;
	Pain3:
		FLR4 MNOP 5;
		Goto See;
	Death:
		FLR1 A 10 { A_Scream(); bShootable=False; }
		TNT1 A 0 A_NoBlocko;
		TNT1 A 0 A_PlaySound("Weapons/RocketExplosion");
		TNT1 A 5 A_SpawnItem("Q2Explosion");
		Stop;
	XDeath:
		Stop;
	}
}
Class FlyerProjectile : HyperBlasterProjectile { Default { DamageFunction (Random(2,4)); } }

Class Q2Parasite : Q2MonsterBase
{
	Default {
	SeeSound "Parasite/Sight";
	ActiveSound "Parasite/Active";
	PainSound "Parasite/Pain";
	DeathSound "Parasite/Death";
	Health 200;
	Speed 18;
	MeleeRange 192;
	PainChance 40;
	Mass 200;
	Obituary "%o was exsanguinated by a \c[q3]Parasite.";
	+NOINFIGHTSPECIES;
	Species "Parasite";
	MissileHeight 30;
	MissileType "ParasiteProjectile";
	Tag "\c[q3]Parasite"; }
	Void A_ParasiteAttack()
	{
		A_SpawnProjectile(MissileName,MissileHeight);
		A_SmoothFace(target);
	}
	States
	{
	Spawn:
		PRT0 ABCDEFGHGFEDCB 6 A_Look;
		PRT0 A 0 A_Jump(96,1);
		Loop;
		PRT0 I 16 A_Look;
		PRT0 JKLMNOPQRSTUVWXYZ 6 A_Look;
		Loop;
	See:
		PRT1 A 0 { bNoPain=False; }
		PRT1 ABCDEFGHIJKL 3 A_SmoothChase;
		PRT1 MNO 3 A_SmoothChase("Melee",null,CHF_DONTMOVE);
		Loop;
	Melee:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		PRT2 AB 4 A_SmoothFace(target);
		PRT2 C 0 A_PlaySound("Parasite/Attack1");
		PRT2 C 4 A_ParasiteAttack();
		PRT2 D 0 A_SpawnProjectile("ParasiteProjectileB",30);
		PRT2 DE 4 A_ParasiteAttack();
		PRT2 F 0 A_PlaySound("Parasite/Attack3",0);
		PRT2 FGHIJKLM 4 A_ParasiteAttack();
		PRT2 F 0 A_PlaySound("Parasite/Attack4");
		PRT2 NOPQR 3 A_SmoothFace(target);
		Goto See;
	Missile:
		Stop;
	Pain:
		"----" A 3 { bNoPain=True; A_Pain(); }
		PRT3 ABCDEFGHIJK 3;
		Goto See;
	Death:
		"----" A 3 A_Scream;
		PRT3 L 0 A_NoBlocko;
		PRT3 LMNOPQ 4;
		PRT3 R -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}
Class ParasiteProjectile : FastProjectile
{
	Default {
	Speed 20;
	Damage 1;
	+STRIFEDAMAGE +NOTIMEFREEZE +BLOODSPLATTER
	Height 5;
	Radius 3; }
	States
	{
	Spawn:
		TNT1 A 0 NoDelay { bPAINLESS=Random(0,128); }
	Moving:
		TNT1 A 0 A_JumpIfCloser(5000,1);
		Stop;
		TNT1 A 0 A_SpawnItemEx("ParasiteProjectileSegment",0,0,0,(MomX*0.01), (MomY*0.01), (MomZ*0.01), Angle, 128 | SXF_ABSOLUTEPOSITION | SXF_ABSOLUTEMOMENTUM | SXF_SETMASTER | SXF_ABSOLUTEANGLE);

		TNT1 A 0 A_Warp(AAPTR_DEFAULT,MomX/5,MomY/5,MomZ/5,0,WARPF_ABSOLUTEOFFSET,1); Stop;
		TNT1 A 0 A_Warp(AAPTR_DEFAULT,MomX/5,MomY/5,MomZ/5,0,WARPF_ABSOLUTEOFFSET,1); Stop;
		TNT1 A 0 A_Warp(AAPTR_DEFAULT,MomX/5,MomY/5,MomZ/5,0,WARPF_ABSOLUTEOFFSET,1); Stop;
		TNT1 A 0 A_Warp(AAPTR_DEFAULT,MomX/5,MomY/5,MomZ/5,0,WARPF_ABSOLUTEOFFSET,1); Stop;
		TNT1 A 0 A_Warp(AAPTR_DEFAULT,MomX/5,MomY/5,MomZ/5,0,WARPF_ABSOLUTEOFFSET,"Moving");
		Stop;
	}
}
Class ParasiteProjectileB : FastProjectile
{
	Default {
	Speed 256;
	Height 5;
	Radius 3; }
	States
	{
	Spawn:
		TNT1 A 2;
		Stop;
	XDeath:
		TNT1 A 1 A_PlaySound("Parasite/Attack2");
		Stop;
	}
}
Class ParasiteProjectileSegment : EffectBase
{
	Default {
	+NOTIMEFREEZE
	RenderStyle "Normal"; }
	States
	{
	Spawn:
		NULL ABCD 0 A_Jump(64,"Fade");
		Loop;
	Fade:
		"####" "#" 4;
		Stop;
	}
}

Class Q2Brain : Q2MonsterBase
{
	Default {
	SeeSound "Q2Brain/Sight";
	ActiveSound "Q2Brain/Active";
	PainSound "Q2Brain/Pain";
	DeathSound "Q2Brain/Death";
	MeleeSound "Infantry/Melee";
	Health 300;
	Speed 5;
	MeleeDamage 4;
	//MeleeRange 80;
	PainChance 60;
	Mass 200;
	Obituary "%o was clawed by a \c[q3]Brain.";
	+NOINFIGHTSPECIES
	Species "Brain";
    Tag "\c[q3]Brain"; }
	Void A_BrainAttack(bool pull=false)
	{
		double a=angle;
		A_SmoothFace(target);
		double extra=40;
		meleerange+=extra;
		If(CheckMeleeRange())
		{
			if(!pull)
			A_CustomMeleeAttack(MeleeDamage*Random(1,6),meleesound,"","melee",false);
			else
			{
				A_CustomMeleeAttack(MeleeDamage*Random(5,8),meleesound,"","melee",false);
				Vector2 Dir=Q2StuffLib.FaceVector(pos,target.pos);
				target.VelFromAngle(20,dir.X);
			}
		}
		meleerange-=extra;
		angle=a;
	}
	States
	{
	Spawn:
		BRN0 ABCDEFGHIJKLMNOPONMLKJIHGFEDCB 6 A_Look;
		Goto Spawn+1;
	See:
		BRN0 Q 0 { bNoPain=False; }
		BRN0 QRSTUVWXY 3 A_SmoothChase;
		BRN0 "Z^[]" 3 A_SmoothChase("Melee",null,CHF_DONTMOVE);
		Loop;
	Melee:
		"----" A 0 A_Jump(80,"Melee2");
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		BRN1 ABCD 3 A_SmoothFace(target);
		BRN1 E 0 A_PlaySound("Q2Brain/Attack",CHAN_BODY);
		BRN1 EF 2 A_SmoothFace(target);
		BRN1 G 2 A_BrainAttack;
		BRN1 HIJKL 3 A_SmoothFace(target);
		BRN1 M 3 A_BrainAttack;
		BRN1 NOPQR 3;// A_SmoothFace(target);
		Goto See;
	Melee2:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		BRN2 ABC 4 A_SmoothFace(target);
		BRN2 D 0 A_PlaySound("Q2Brain/OpenChest",0,0.5);
		BRN2 DE 4 A_SmoothFace(target);
		BRN2 F 0 A_PlaySound("Q2Brain/Attack2",CHAN_BODY);
		TNT1 A 0 A_BrainAttack(true);
		BRN2 FGHIJKLMNOPQ 3;// A_SmoothFace(target);
		Goto See;
	Missile:
		Stop;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
		"----" A 3;
		BRN3 ABCDEFGHIJKLMNOPQRSTUVW 3;
		Goto See;
	Pain2:
		"----" A 3;
		BRN4 ABCDEFGH 3;
		Goto See;
	Pain3:
		"----" A 3;
		BRN4 IJKLMN 4;
		Goto See;
	Death:
		"----" A 0 A_Scream;
		"----" A 0 A_Jump(256,"Death1","Death2");
	Death1:
		"----" A 10;
		BRN5 A 0 A_NoBlocko;
		BRN5 ABCD 7;
		BRN5 EFGHIJKLMNOPQ 5;
		BRN5 R -1;
		Stop;
	Death2:
		"----" A 10;
		BRN5 A 0 A_NoBlocko;
		BRN5 STUV 8;
		BRN5 W -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
	Actor Shield;
	Override Void Tick()
	{
		bool ass;
		Super.Tick();
		If(Health<1 || bDormant || level.frozen || globalfreeze) return;
		if(level.time%35==0 && !Shield)
		[ass,Shield]=A_SpawnItemEx("BrainShield",flags:SXF_SETMASTER);
	}
}
Class BrainShield : Actor
{
	Default {
	Translation "0:255=115:115";
	+BRIGHT +NOBLOODDECALS +SHOOTABLE +SOLID
	+NOTAUTOAIMED
	+NOGRAVITY +GHOST +INTERPOLATEANGLES +NODAMAGE
	BloodType "GreenPuff";
	//Health 50;
	Scale 1.5;
	PainChance 256;
	Radius 25;
	Height 55;
	RenderStyle "Add";
	Alpha 0.66;
	Mass 0x7fffffff; }
	Override Void Tick()
	{
		Super.Tick();
		If(!master || master && master.health<1) { Destroy(); return; }
		if(!special1) special1=25;
		SetOrigin(master.pos+((RotateVector((special1,0),master.angle)),0),true);
		angle=master.angle;
	}
	Override Bool CanCollideWith(Actor other, bool passive)
	{
		if(other.bMissile && other.target!=master) return true;
		If(other.bMissile && other.target==master) return false;
		return false;
	}
	States
	{
/*	Spawn:
		TNT1 A 6;
		Stop;*/
	Pain:
		BAR1 A 5;// { bNoPain=True; }
		Goto Spawn;
	}
}

Class Q2Medic : Q2MonsterBase
{
	Default {
	SeeSound "Medic/Sight";
	ActiveSound "Medic/Active";
	PainSound "Medic/Pain";
	DeathSound "Medic/Death";

	Speed 16;
	Health 300;
	PainChance 60;
	GibHealth 100;
	Mass 600;
	Obituary "%o was blasted by a \c[l6]Medic.";
	+NOINFIGHTSPECIES
	DropItem "Q2Cell", 128;
	Species "Medic";
	Tag "\c[l6]Medic"; }
	Actor Patient;
	Void A_MedicChase()
	{
		A_SmoothChase();
		If(Random(0,20)) Return;
		Array<Actor> Bodies;
		BlockThingsIterator It=BlockThingsIterator.Create(Self,256);
		While(It.Next())
		{
			If(It.Thing!=Self && CheckSight(It.Thing) && It.Thing.CanRaise())
			{
				//Bodies.Push(It.Thing)
				//RaiseActor(It.Thing,RF_TRANSFERFRIENDLINESS);
				Patient=It.Thing;
				SetStateLabel("Heal");
				SChaseMove*=SChaseTics=0;
				//SChaseCount=9999999999;
				Break;
				Return;
			}
		}
	}
	Void A_MedicAttack(Double SX=32, Double SY=0)
	{
		A_SpawnProjectile("HoverProjectile",SX,SY);
		A_PlaySound("Medic/Attack",CHAN_WEAPON);
		A_SmoothFace(target);
	}
	States
	{
	Spawn:
		MED5 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 5 A_Look;
		MED6 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 5 A_Look;
		MED7 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 5 A_Look;
		MED8 ABC 5 A_Look;
		MED5 A 0 A_PlaySound("Medic/Idle",CHAN_VOICE);
		Loop;
	See:
		MED0 A 0 { bNoPain=False; }
		MED0 ABCDEF 3 A_MedicChase();
		Loop;
	Missile:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		MED1 ABCDEFGHI 3 A_SmoothFace(target);
		MED1 J 0 A_PlaySound("Medic/Attack",CHAN_WEAPON);
		MED1 J 3 A_SpawnProjectile("BlasterProjectile",38,12);
		MED1 KL 3 A_SmoothFace(target);
		MED1 M 0 A_PlaySound("Medic/Attack",CHAN_WEAPON);
		MED1 M 3 A_SpawnProjectile("BlasterProjectile",38,12);
		MED1 NOPQRS 3 A_SmoothFace(target);
		MED1 T 3 A_MedicAttack(38,18);
		MED1 U 4 A_MedicAttack(38,14);
		MED1 V 3 A_MedicAttack(38,8);
		MED1 W 4 A_MedicAttack(38,4);
		MED1 X 3 A_MedicAttack(38,0);
		MED1 Y 4 A_MedicAttack(38,4);
		MED1 Z 3 A_MedicAttack(38,8);
		MED1 "^" 4 A_MedicAttack(38,10);
		MED1 "[" 3 A_MedicAttack(38,13);
		MED1 "]" 4 A_MedicAttack(38,15);
		MED2 A 3 A_MedicAttack(38,14);
		MED2 BCDEFGH 2 A_SmoothFace(target);
		Goto See;
	Heal:
		"----" A 1 A_PlaySound("Medic/Heal",CHAN_WEAPON);
		"----" A 3 A_SmoothFace(Patient);
		MED2 IJKLMNOPQRSTUV 2 {
		A_SmoothFace(Patient);
		If(!Patient) Return;
		Vector3 Offs=(RotateVector((52,15),Angle),32);
		Actor Beam=Spawn("LightningBeamBase",Pos+Offs);
		beam.special1=2;
		beam.special2=tics+1;
		beam.A_SetRenderStyle(1.0,STYLE_NORMAL);
		beam.reactiontime=0;
		beam.tracer=Patient;
		}
		"----" A 3 { If(Patient && Patient.CanRaise()) RaiseActor(Patient,RF_TRANSFERFRIENDLINESS); }
		MED2 "WXYZ^[]" 3 A_SmoothFace(Patient);
		MED0 YZ 3;
		Goto See;
	Pain:
		"----" A 0 { bNoPain=True; }
		"----" A 0 A_Pain;
		"----" A 0 A_Jump(256,"Pain1","Pain2");
		Goto See;
	Pain1:
		"----" A 3;
		MED3 ABCDEFGH 3;
		Goto See;
	Pain2:
		"----" A 3;
		MED3 IJKLMNOPQRSTUVW 3;
		Goto See;
	Death:
		"----" A 3 A_Scream();
		MED4 ABCDEFGHI 3;
		MED4 J 3 A_NoBlocko;
		MED4 "KLMNOPQRSTUVWXYZ^[" 3;
		MED4 "]" -1;
		Stop;
	Raise:
		Stop;
	}
}

Class Q2Hover : Q2MonsterBase
{
	Default
	{
		SeeSound "Hover/Sight";
		ActiveSound "Hover/Active";
		PainSound "Hover/Pain";
		DeathSound "Hover/Death";
		Speed 8;
		+NOGRAVITY +FLOAT +FLOATBOB
		+NOINFIGHTSPECIES
		Health 240;
		PainChance 60;
		GibHealth 100;
		Mass 600;
		Obituary "%o was blasted by an \c[l6]Icarus.";
		DropItem "Q2Cell", 120;
		Species "Icarus";
		Tag "\c[l6]Icarus";
	}
	Void A_HooverAttack(bool side=false)
	{
		A_SmoothFace(target);
		A_PlaySound("Hover/Attack",CHAN_WEAPON);
		A_SpawnProjectile("HoverProjectile",34,side? -9:9);
	}
	States
	{
	Spawn:
		HVR0 A 0 NoDelay A_PlaySound("Hover/Fly",CHAN_BODY,0.5,1);
		HVR0 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[^]" 6 A_Look;
		Goto Spawn+1;
	See:
		HVR1 A 0 { bNoPain=False; }
		HVR1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[^]" 3 A_SmoothChase;
		Loop;
	Missile:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		HVR3 LMN 3 A_SmoothFace(target);
		HVR3 O 3 A_HooverAttack;
		HVR3 P 3 A_HooverAttack(1);
		HVR3 QRS 3 A_SmoothFace(target);
		HVR3 N 0 A_Jump(64,"See");
		HVR3 N 0 A_CPosRefire;
		Goto Missile+5;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2");
	Pain1:
		"----" A 3;
		HVR2 ABCDEFGHIJKL 3;
		Goto See;
	Pain2:
		"----" A 3;
		HVR2 MNOPQRSTU 3;
		Goto See;
	Death:
		"----" A 3 { bFLOATBOB=0; A_StopSound(CHAN_BODY); A_Scream(); }
		HVR3 ABCDEF 4;
		HVR3 G 4 A_NoBlocko();
		HVR3 HIJ 4;
		HVR3 K 1 A_JumpIf(!Vel.Z,1);
		Wait;
		HVR3 K -1 A_Jump(160,1); // Yes
		HVR3 K 20;
		TNT1 A 0 A_SpawnItem("Q2Explosion");
		TNT1 A 0 A_PlaySound("Weapons/RocketExplosion");
		Goto Super::XDeath+1;
	XDeath:
		TNT1 A 0 A_PlaySound("Weapons/RocketExplosion");
		TNT1 A 0 A_SpawnItem("Q2Explosion",0,32);
		Goto Super::XDeath;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}
Class HoverProjectile : BlasterProjectile { Default { MissileType ""; DamageFunction (Random(4,6)); } }

Class Q2Technician : Q2MonsterBase
{
	Default {
	SeeSound "Technician/Sight";
	ActiveSound "Technician/Active";
	PainSound "Technician/Pain";
	DeathSound "Technician/Death";
	Speed 8;
	+NOINFIGHTSPECIES
	+NOGRAVITY +FLOAT +FLOATBOB
	Health 200;
	PainChance 60;
	GibHealth 100;
	MeleeDamage 5;
	Mass 600;
	DeathHeight 20;
	HitObituary "%o was electrified by a \c[q2]Technician.";
	Obituary "%o couldn't be repaired by a \c[q2]Technician.";
	DropItem "Q2Cell", 100;
	Species "Technician";
	Tag "\c[q2]Technician"; }
	Void A_TechnicianAttack()
	{
		SpawnMissileXYZ(Pos+(RotateVector((25,0),Angle),32+GetBobOffset()),target,"HoverProjectile",true,self);
		//A_SpawnProjectile("HoverProjectile",25);
		A_SmoothFace(target);
		A_PlaySound("Technician/Blaster",CHAN_WEAPON);
	}
	States
	{
	Spawn:
		TEK1 A 0 NoDelay A_PlaySound("Hover/Fly",CHAN_BODY,0.5,1);
		TEK1 A 6 A_Look;//Ex(0,0,0,0,0,1);
		Loop;
	See:
		TEK1 A 0 { bNoPain=False; }
		TEK1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 3 A_SmoothChase;
		TEK2 ABCDEFGHIJKLMNOPQRSTUVW 3 A_SmoothChase;
		Loop;
	Melee:
	    "----" A 0 A_Jump(128,"Melee2");
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		TEK4 ABCDEFGHIJKL 3 A_SmoothFace(target);
		TEK4 M 0 A_PlaySound("Technician/Melee2",CHAN_WEAPON);
		TNT1 A 0 A_MeleeAttack;
		TEK4 MNOPQRSTUVWXY 3;
		Goto See;
	Melee2:
	    "----" A 0 A_Jump(128,"Melee2");
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		TEK5 ABCDEFGH 3 A_SmoothFace(target);
		TEK5 I 0 A_PlaySound("Technician/Melee1",CHAN_WEAPON);
		TNT1 A 0 A_MeleeAttack;
		TEK5 IJKLMNOPQRSTUVWXYZ 3;
		TEK6 ABCDEFGH 3;
		Goto See;
	Missile:
		"----" A 1;
		"----" A 4 A_SmoothFace(target);
		TEK3 ABC 4 A_SmoothFace(target);
		TEK3 D 3 A_TechnicianAttack;
		TEK3 E 4 A_TechnicianAttack;
		TEK3 F 3 A_TechnicianAttack;
		TEK3 G 4 A_TechnicianAttack;
		TEK3 H 3 A_TechnicianAttack;
		TEK3 I 4 A_TechnicianAttack;
		TEK3 J 3 A_TechnicianAttack;
		TEK3 K 4 A_TechnicianAttack;
		TEK3 LMN 4;
		Goto See;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
		"----" A 3;
		TEK6 HIJKLMN 3;
		Goto See;
	Pain2:
		"----" A 3;
		TEK6 OPQRSTUV 3;
		Goto See;
	Pain3:
		"----" A 3;
		TEK7 ABCDEFGHIJKL 3;
		Goto See;
	Death:
		"----" A 3 A_Scream;
		TEK7 M 0 { bFLOATBOB=0; }
		TEK7 MNOPQRS 4;
		Goto Death+2;
	Crash:
		"----" A 4 A_NoBlocko;
		TEK7 TUVWX 4;
		TEK7 Y 35;
	XDeath:
		TNT1 A 0 A_PlaySound("Weapons/RocketExplosion");
		TNT1 A 0 A_SpawnItem("Q2Explosion",0,32);
		Goto Super::XDeath;
	}
}
/*
Actor TechnicianProjectile : HyperBlasterProjectile
{
Damage 1
}

Actor Mutant // Special thanks to DBThanatos for the main base of the Mutant from QC:DE
{
	Health 300
	Radius 20
	Height 56
	Mass 400
	Speed 24
	MeleeDamage 5
	MeleeRange 75
	Damage 5
	PainChance 109
	Monster
	Tag "\c[u6]Mutant"
	SeeSound "Mutant/Sight"
	PainSound "Mutant/Pain"
	DeathSound "Mutant/Death"
	ActiveSound "Mutant/Active"
	AttackSound ""
	+NOINFIGHTSPECIES
	+FLOORCLIP
	-MISSILEMORE
	Obituary "%o was disemboweled by a \c[u6]Mutant."
	States
	{
	Spawn:
		MTS1 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_Look
		MTS2 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 A_Look
		MTS3 ABCDEFGHIJKL 3 A_Look
		Loop
	See:
	    TNT1 A 0 A_ChangeFlag("NOPAIN",0)
	    MTW1 ABCDEF 3
	SeeLoop:
	    MTR0 CDEFGH 3 A_VileChase
		TNT1 A 0 A_PlaySound ("Mutant/Step")
		Loop
	Something: // Unused
	    MTW1 RSTUVW 0
		Stop
	SeeNoMissile:
		MTW1 ABCDE 3
	SeeNoMissileHold:
	    TNT1 A 0 A_PlaySound ("Mutant/Step")
		MTW1 FGHIJK 3 A_Chase
		TNT1 A 0 A_PlaySound ("Mutant/Step")
		MTW1 LMNOPQ 3 A_Chase
		Goto SeeNoMissileHold
	Melee:
		MTA2 ABCD 3 A_FaceTarget
		TNT1 A 0 A_PlaySound("Mutant/Attack")
		MTA2 E 4 A_MeleeAttack
		MTA2 FG 3 A_FaceTarget
		TNT1 Z 0 A_PlaySound("Mutant/Attack")
		MTA2 H 3 A_MeleeAttack
		MTA2 IJ 3 A_FaceTarget
		Goto See
	Missile:
		TNT1 A 0 A_GiveInventory("JumpCheck",1)
		MTA1 A 0 A_PlaySound("Mutant/Sight")
		MTA1 BC 3 A_Facetarget
		TNT1 A 0 A_SkullAttack
		MTA1 D 1 ThrustThingZ(0,25,0,0)
		MTA1 D 1 A_CheckFloor("Landed")
		Wait
	Landed:
		MTA1 E 3
		TNT1 A 0 A_Stop
		TNT1 A 0 A_PlaySound("Mutant/Land")
		MTA1 E 3
		Goto SeeNoMissileHold
	Pain:
	    TNT1 A 0 A_ChangeFlag("NOPAIN",1)
	    TNT1 A 0 A_Jump(256,"Pain1","Pain2","Pain3")
	Pain1:
	    TNT1 A 0 A_Pain
		MTP1 ABCDE 4
		Goto See
	Pain2:
	    TNT1 A 0 A_Pain
		MTP2 ABCDEF 3
		Goto See
	Pain3:
	    TNT1 A 0 A_Pain
		MTP3 ABCDEFGHIJK 2
		Goto See
	Death:
	    TNT1 A 0 A_SpawnItemEx(DestroyableBodyThing,0,0,0,0,0,0,0,SXF_NOCHECKPOSITION|SXF_SETMASTER)
	    TNT1 A 0 A_ScreamAndUnblock
	    TNT1 A 0 A_Jump(256,"Death1","Death2")
	Death1:
		MTD1 ABCDEFGH 5
	    MTD1 I 5
		MTD1 I -1
		Stop
	Death2:
	    MTD2 ABCDEFGHIJ 5
		MTD2 J -1
		Stop
	XDeathChecksDone:
		TNT1 A 0 A_Fall
		TNT1 A 5 A_SpawnItem(Q2GibSpawner)
		TNT1 A 0
		Stop
	Raise:
		"----" A 0 A_GiveInventory(ResurrectedToken,1)
		"----" A 25 A_StopSound(CHAN_BODY)
		"----" A 6 A_TakeInventory(ResurrectedToken,1)
		Goto SeeNoMissileHold
	Crush:
		TNT1 AAAAAAA 0 A_SpawnItemEx(Q2Gib,Random2(40),0,5,Random(0,1),0,2,Random(1,360))
		TNT1 A 5 A_XScream
		Stop
	}
}

Actor JumpCheck : Inventory { Inventory.MaxAmount 1 Inventory.Amount 1 }
*/
Class Q2Gladiator : Q2MonsterBase
{
	Default {
	Health 400;
	PainChance 30;
	SeeSound "Gladiator/Sight";
	ActiveSound "Gladiator/Active";
	PainSound "Gladiator/Pain";
	DeathSound "Gladiator/Death";
	AttackSound "";
	MeleeRange 75;
	Mass 500;
	GibHealth 175;
	+NOINFIGHTSPECIES
	+MISSILEMORE +BOSSDEATH
	HitObituary "%o was hit by a \c[l5]Gladiator.";
	Obituary "%o was railed by a \c[l5]Gladiator.";
	DropItem "Q2SlugPickupSmall", 60;
	Species "Gladiator";
	Tag "\c[l5]Gladiator"; }
	Void A_GladiatorTarget()
	{
		if(!target) return;
		A_SmoothFace(target);
		tracer=spawn("actor",target.pos+(0,0,target.height/2));
		if(!tracer) return;
		tracer.tics=35;
		tracer.bNoGravity=True;
		tracer.height=0;
	}
	Void A_GladiatorAttack()
	{
		Actor st=target;
		if(tracer)
		target=tracer;
		Vector3 Offset=(RotateVector((28,-19),Angle),46-32);
		SetOrigin(Pos+Offset,1);
		A_CustomRailgun(50,0,"2F 67 7F","White",RGF_FULLBRIGHT|RGF_SILENT,1,0,"Q2RailgunPuff");//,0,0,8129,35,1,1,null,0);
		SetOrigin(Pos-Offset,1);
		target=st;
		if(tracer) tracer.destroy();
	}
	States
	{
	Spawn:
		GLD0 ABCDEFG 6 A_Look;
		Loop;
	See:
		GLD0 H 0 { bNoPain=False; }
		GLD0 HIJKLM 4 A_SmoothChase;
		Loop;
	Melee:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		GLD1 A 0 A_PlaySound("Gladiator/Melee1",CHAN_BODY);
		GLD1 ABCDEF 3 A_FaceTarget;
		GLD1 G 3 A_CustomMeleeAttack(Random(10,25),"Infantry/Melee","Gladiator/Melee2");
		TNT1 A 0 A_PlaySound("Gladiator/Melee1",CHAN_BODY);
		GLD1 HIJKLM 3 A_FaceTarget;
		GLD1 N 3 A_CustomMeleeAttack(Random(10,25),"Infantry/Melee","Gladiator/Melee2");
		GLD1 OPQ 3 A_FaceTarget;
		Goto See;
	Missile:
		"----" A 1 A_GladiatorTarget;
		"----" A 3 A_SmoothFace(target);
		GLD1 R 7 { A_PlaySound("Gladiator/Railgun",CHAN_WEAPON); A_SmoothFace(target); }
		GLD1 S 4 A_SmoothFace(target);
		GLD1 T 5 A_GladiatorTarget;
		GLD1 U 4 A_GladiatorAttack;
		GLD1 VWXYZ 4;
		Goto See;
	Pain:
		"----" A 4 { bNoPain=True; A_Pain(); }
		GLD2 ABCDEF 4;
		Goto See;
	Death:
		"----" A 3 { A_Scream(); A_PlaySound("Gladiator/Deathb",0); }
		GLD2 GHIJK 4;
		GLD2 L 4 A_NoBlocko;
		GLD2 MNOPQRSTUVWXY 4;
		GLD2 Z -1 A_BossDeath;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}

Class Q2IronMaiden : Q2MonsterBase
{
	Default {
	SeeSound "IronMaiden/Sight";
	ActiveSound "IronMaiden/Active";
	PainSound "IronMaiden/Pain";
	DeathSound "IronMaiden/Death";
	MeleeSound "IronMaiden/Attack4";
	+NOINFIGHTSPECIES
	Health 175;
	Speed 8;
	MeleeDamage 15;
	PainChance 60;
	PainChance "Railgun", 250;
	Mass 200;
	Obituary "%o almost dodged an \c[g5]Iron \c[q3]Maiden's \c[g5]rocket";
	HitObituary "%o was bitch-slapped by an \c[g5]Iron \c[q3]Maiden";
	DropItem "Q2Rockets", 128;
	Species "IronMaiden";
	Tag "\c[g5]Iron \c[q3]Maiden"; }
	States
	{
	Spawn:
		BTC0 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 6 A_Look;
		BTC0 A 0 A_Jump(64,1);
		Loop;
		BTC1 ABCDEFGHIJKLMNO 6;
		BTC1 P 0 A_PlaySound("IronMaiden/Idle");
		BTC1 "PQRSTUVWXYZ^[]" 6 A_Look;
		Goto Spawn+1;
	See:
		BTC2 A 0 { bNoPain=False; }
		BTC2 ABCDEFGHIJ 3 A_SmoothChase;
		Loop;
	Melee:
		TNT1 A 0 A_PlaySound("IronMaiden/Attack3",CHAN_VOICE);
		BTC2 KLMN 3 A_SmoothFace(target);
		BTC2 O 0 A_MeleeAttack;
		BTC2 OPQRSTUVWXYZ Random(2,3) A_SmoothFace(target);
		Goto See;
	Missile:
		TNT1 A 0 A_PlaySound("IronMaiden/Attack1",CHAN_VOICE);
		BTC3 ABCDEFGHIJKLM 3 A_SmoothFace(target);
		BTC3 N 0 A_SpawnProjectile("IronMaidenRocket",42,-8);
		TNT1 A 0 A_Recoil(5);
		TNT1 A 0 A_PlaySound("IronMaiden/Attack2",CHAN_WEAPON);
		BTC3 NOPQRST 3;
		BTC3 U 3 A_PlaySound("IronMaiden/Attack5",0);
		BTC3 VWXY 3;
		Goto See;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2");
	Pain1:
		"----" A 3;
		BTC4 ABCDE 3;
		Goto See;
	Pain2:
		"----" A 3;
		BTC4 FGHIJ 3;
		Goto See;
	Pain.Railgun:
		"----" A 3 A_Pain;
		BTC4 K 3;
		BTC4 "KLMNOPQRSTUVWXYZ^[]" 4;
		BTC3 "Z^" 3;
		Goto See;
	Pain.Explosion:
		"----" A 3 A_Pain;
		BTC4 K 3;
		BTC4 "KLMNOPQRSTUVWXYZ^[]" 4;
		BTC3 "Z^" 3;
		Goto See;
	Death:
		"----" A 0 { A_Scream(); Return A_Jump(256,"Death1","Death2"); }
	Death1:
		"----" A 5;
		BTC5 ABC 4;
		BTC5 D 4 A_NoBlocko;
		BTC5 EFGHIJK 4;
		BTC5 L -1;
		Stop;
	Death2:
		"----" A 4;
		BTC6 ABC 4;
		BTC6 D 4 A_NoBlocko;
		BTC6 EFGHIJKLMNOPQRSTUV 4;
		BTC6 W -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}
Class IronMaidenRocket : Q2Rocket
{
	Default {
    Speed 15;
    Damage 10;
    ExplosionDamage 64;
    DontHurtShooter; }
}

Class Q2Tank : Q2MonsterBase
{
	Default {
	SeeSound "Tank/Sight";
	ActiveSound "Tank/Active";
	PainSound "Tank/Pain";
	DeathSound "Tank/Death";
	AttackSound "Tank/Attack2";
	Health 750;
	Speed 5;
	PainChance 5;
	Height 64;
	Radius 24;
	Mass 1000;
	+NOINFIGHTSPECIES
	+BOSSDEATH
	Obituary "%o was pumped full of lead by a \c[u6]Tank";
	DropItem "Q2TankRandomSpawner", 100;
	GibHealth 200;
	Species "Tank";
	Tag "\c[u6]Tank"; }
	States
	{
	Spawn:
		TNK0 ABCDEFGHIJIHGFEDCB 6 A_Look;
		Goto Spawn+1;
	See:
		TNK0 K 0 { bNoPain=False; }
		TNK0 KLMNO 3 A_SmoothChase;
		TNK0 P 0 A_PlaySound("Tank/Step",CHAN_BODY);
		TNK0 PQR 3 A_SmoothChase;
		TNK0 STUVW 3 A_SmoothChase;
		TNK0 X 0 A_PlaySound("Tank/Step",CHAN_BODY);
		TNK0 XYZ 3 A_SmoothChase;
		Loop;
	Missile:
		"----" A 0 A_Jump(128,"Missile2","Missile3");
		"----" A 1;
		"----" A 8 A_SmoothFace(target);
		TNK1 ABCDEFGHI 3 A_SmoothFace(target,20);
		TNK1 J 0 A_PlaySound("Tank/Attack3",CHAN_WEAPON);
		TNT1 A 0 A_SpawnProjectile("BlasterProjectile",40*Scale.X,-18*Scale.X,-3);
		TNK1 JKL 3 A_SmoothFace(target);
		TNK1 M 0 A_PlaySound("Tank/Attack3",CHAN_WEAPON);
		TNT1 A 0 A_SpawnProjectile("BlasterProjectile",38*Scale.X,-20*Scale.X,0);
		TNK1 MNO 3 A_SmoothFace(target);
		TNK1 P 0 A_PlaySound("Tank/Attack3",CHAN_WEAPON);
		TNT1 A 0 A_SpawnProjectile("BlasterProjectile",36*Scale.X,-23*Scale.X,3);
		TNK1 PQRSTU 3 A_SmoothFace(target,20);
		TNK1 V 10;
		Goto See;
	Missile2:
		"----" A 1;
		"----" A 8 A_SmoothFace(target);
		TNK2 A 0 A_PlaySound("Tank/Attack4",CHAN_WEAPON);
		TNK2 ABCDEFGHIJKLMNOPQRSTUVW 3 A_SmoothFace(target,20);
		TNK2 X 0 A_PlaySound("Tank/Attack1",CHAN_WEAPON);
		TNT1 A 0 A_SpawnProjectile("IronMaidenRocket",60*Scale.X,26*Scale.X,0);
		TNK2 XYZ 3 A_SmoothFace(target);
		TNK2 "^" 0 A_PlaySound("Tank/Attack1",CHAN_WEAPON);
		TNT1 A 0 A_SpawnProjectile("IronMaidenRocket",60*Scale.X,22*Scale.X,0);
		TNK2 "^[]" 3 A_SmoothFace(target);
		TNK3 A 0 A_PlaySound("Tank/Attack1",CHAN_WEAPON);
		TNT1 A 0 A_SpawnProjectile("IronMaidenRocket",60*Scale.X,18*Scale.X,0);
		TNK3 ABC 3 A_SmoothFace(target);
		TNK2 X 0 A_PlaySound("Tank/Attack4",0,CHAN_WEAPON);
		TNK3 DEFGHIJKLMNOPQRSTUVW 4;
		TNK3 X 10;
		Goto See;
	Missile3:
		"----" A 1;
		"----" A 8 A_SmoothFace(target);
		TNK4 ABCDE 3 A_SmoothFace(target,15,0);
		TNK4 F 0 A_SpawnItemEx("EnemyFlashSpawner",23*Scale.X,0,36*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 F 3 A_CustomBulletAttack(20+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 G 0 A_SpawnItemEx("EnemyFlashSpawner",22*Scale.X,6*Scale.X,33*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 G 4 A_CustomBulletAttack(10+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 H 0 A_SpawnItemEx("EnemyFlashSpawner",20*Scale.X,14*Scale.X,30*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 H 3 A_CustomBulletAttack(Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 I 0 A_SpawnItemEx("EnemyFlashSpawner",20*Scale.X,20*Scale.X,30*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 I 4 A_CustomBulletAttack(-5+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 J 0 A_SpawnItemEx("EnemyFlashSpawner",17*Scale.X,25*Scale.X,32*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 J 3 A_CustomBulletAttack(-10+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 K 0 A_SpawnItemEx("EnemyFlashSpawner",14*Scale.X,30*Scale.X,32*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 K 4 A_CustomBulletAttack(-20+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 L 0 A_SpawnItemEx("EnemyFlashSpawner",8*Scale.X,35*Scale.X,32*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 L 3 A_CustomBulletAttack(-30+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 M 0 A_SpawnItemEx("EnemyFlashSpawner",4*Scale.X,38*Scale.X,33*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 M 4 A_CustomBulletAttack(-50+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 N 0 A_SpawnItemEx("EnemyFlashSpawner",-1*Scale.X,41*Scale.X,35*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 N 3 A_CustomBulletAttack(-60+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 O 0 A_SpawnItemEx("EnemyFlashSpawner",-7*Scale.X,42*Scale.X,35*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 O 4 A_CustomBulletAttack(-80+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 P 0 A_SpawnItemEx("EnemyFlashSpawner",3*Scale.X,42*Scale.X,36*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 P 3 A_CustomBulletAttack(-70+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 Q 0 A_SpawnItemEx("EnemyFlashSpawner",12*Scale.X,38*Scale.X,36*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 Q 4 A_CustomBulletAttack(-60+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 R 0 A_SpawnItemEx("EnemyFlashSpawner",19*Scale.X,32*Scale.X,36*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 R 3 A_CustomBulletAttack(-50+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 S 0 A_SpawnItemEx("EnemyFlashSpawner",24*Scale.X,25*Scale.X,36*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 S 4 A_CustomBulletAttack(-30+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 T 0 A_SpawnItemEx("EnemyFlashSpawner",28*Scale.X,18*Scale.X,37*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 T 3 A_CustomBulletAttack(-20+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 U 0 A_SpawnItemEx("EnemyFlashSpawner",28*Scale.X,10*Scale.X,37*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 U 4 A_CustomBulletAttack(-10+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 V 0 A_SpawnItemEx("EnemyFlashSpawner",28*Scale.X,3*Scale.X,37*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 V 3 A_CustomBulletAttack(0+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 W 0 A_SpawnItemEx("EnemyFlashSpawner",26*Scale.X,-3*Scale.X,38*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 W 4 A_CustomBulletAttack(10+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 X 0 A_SpawnItemEx("EnemyFlashSpawner",23*Scale.X,-7*Scale.X,39*Scale.X); TNT1 A 0 A_SpawnItem("WeaponFlash"); TNK4 X 3 A_CustomBulletAttack(20+Random2(5),Random2(5),1,6,"BulletPuff",2048,CBAF_EXPLICITANGLE|CBAF_AIMFACING);
		TNK4 "YZ^[" 3;
		TNK4 "]" 10;
		Goto See;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
		"----" A 6;
		TNK5 ABCD 6;
		Goto See;
	Pain2:
		"----" A 6;
		TNK5 EFGHI 6;
		Goto See;
	Pain3:
		"----" A 6;
		TNK5 JKLMNOPQRSTUVWXY 4;
		Goto See;
	Death:
		"----" A 4 A_Scream;
		TNK6 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^" 4;
		TNK6 "[" 3 { A_NoBlocko(); A_PlaySound("Tank/Death2",CHAN_BODY); }
		TNK6 "]" 3;
		TNK1 X -1 A_BossDeath;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}

Class Q2TankRandomSpawner : RandomSpawner { Default
{ DropItem "Q2Rockets", 125;
  DropItem "Q2Cell", 100;
  DropItem "Q2Bullets", 150; } }

Class Q2TankCommander : Q2Tank
{
	Default {
	Health 1000;
	Radius 24;
	Scale 1.1;
	Obituary "%o was pumped full of lead by a \c[g3]Tank \c[q3]Commander.";
	+NOINFIGHTSPECIES
	Species "TankC";
	Tag "\c[g3]Tank \c[q3]Commander"; }
}

Class Q2TankBoss : Q2MonsterBase
{
	Default {
	SeeSound "TankBoss/Sight";
	ActiveSound "TankBoss/Active";
	PainSound "TankBoss/Pain";
	AttackSound "Infantry/Attack1";
	DeathSound "TankBoss/Death";
	+NOFEAR +NORADIUSDMG;
	+BOSS +BOSSDEATH +DONTMORPH
	+NOINFIGHTSPECIES
	Health 1500;
	Speed 12;
	PainChance 30;
	PainChance "BFG", 20;
	PainChance "BFGSplash", 5;
	DamageFactor "BFGSplash", 0.5;
	DamageFactor "BFGSplash", 0.33;
	Mass 6000;
	Radius 100;
	Height 100;
	Obituary "%o was killed by a \c[o6]Super Tank.";
	DropItem "Q2TankRandomSpawner", 100;
	Species "Supertank";
	Tag "\c[o6]Super Tank"; }
	Void A_TankAttack()
	{
		Double a=Angle;
		A_SpawnItemEx("EnemyFlashSpawner",24,47,82);
		A_SpawnItemEx("WeaponFlash",24,47,82);
		A_CustomBulletAttack(8,8,2,3);
		Angle=a;
		A_SmoothFace(target,10);
		//A_FaceTarget(10);
	}
	States
	{
	Spawn:
		TNK0 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 6 A_Look;
		TNK6 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 6 A_Look;
		TNK1 AB 6 A_Look;
		Loop;
	See:
		TNK1 C 0 A_PlaySound("TankBoss/Engine",CHAN_BODY,0.5,1);
		TNT1 A 0 { bNoPain=False; }
		TNT1 A 0 A_TakeInventory("Clip");
		TNK1 CDEFGHIJKLMNOPQRST 3 A_SmoothChase;
		Loop;
	Missile:
		"----" A 0 A_Jump(96,"Rockets");
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		TNK2 A 3 A_TankAttack;
		TNK2 B 4 A_TankAttack;
		TNK2 C 3 A_TankAttack;
		TNK2 D 4 A_TankAttack;
		TNK2 E 3 A_TankAttack;
		TNK2 F 4 A_TankAttack;
		TNK2 A 0 A_JumpIfInventory("Clip",6,4);
		TNT1 A 0 A_GiveInventory("Clip",1);
		TNT1 A 0 A_Jump(32,2);
		TNT1 A 0 { double a=angle; A_MonsterReFire(96,1); angle=a; }
		Goto Missile+4;
		TNK2 GHIJKLMNOPQRST 3;
		Goto See;
	Rockets:
		"----" A 1;
		"----" A 5 A_SmoothFace(target);
		TNK3 A 0 A_PlaySound("Tank/Attack4",0);
		TNK3 ABCDEFG 4 A_SmoothFace(target);
		TNK3 H 0 A_PlaySound("Tank/Attack1",CHAN_WEAPON);
		TNK3 H 3 A_SpawnProjectile("Rocket",102,-30);
		TNK3 IJ 3;// A_SmoothFace(target);
		TNK3 K 0 A_PlaySound("Tank/Attack1",CHAN_WEAPON);
		TNK3 K 3 A_SpawnProjectile("Rocket",98,-40);
		TNK3 LM 3;// A_SmoothFace(target);
		TNK3 N 0 A_PlaySound("Tank/Attack1",CHAN_WEAPON);
		TNK3 N 3 A_SpawnProjectile("Rocket",95,-51);
		TNK3 "OPQRSTUVWXYZ^" 4;
		Goto See;
	Pain:
		"----" A 0 { bNoPain=True; }
		"----" A 0 A_Pain;
		"----" A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
		"----" A 3;
		TNK4 ABCD 4;
		Goto See;
	Pain2:
		"----" A 3;
		TNK4 EFGH 4;
		Goto See;
	Pain3:
		"----" A 3;
		TNK4 IJKL 4;
		Goto See;
	Death:
		"----" A 3 { A_StopSound(CHAN_BODY); A_Scream(); bNoDamage=True; }
		TNK5 ABCDEFGHIJKLMNOPQR 5;
		TNK5 S 2;
		TNK5 U 0 A_BossDeath;
		TNK5 SSSS 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,80),0,0,0,0,SXF_TRANSFERPOINTERS);
		TNK5 SSSS 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,80),0,0,0,0,SXF_TRANSFERPOINTERS);
		TNK5 SSSS 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,80),0,0,0,0,SXF_TRANSFERPOINTERS); // comento makronexplosion
		TNK5 SSSS 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,80),0,0,0,0,SXF_TRANSFERPOINTERS);
		TNK5 SSSS 0 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,80),0,0,0,0,SXF_TRANSFERPOINTERS);
		TNT1 A 0 A_Fall;
		TNT1 AAAAAAAAAAAAAAAA 0 A_SpawnItemEx("Q2Gib",Random2(Radius),0,Random(0,80),2,0,Random(0,10),Random(1,360));
		TNT1 A 5 A_XScream;
		Stop;
	Raise:
	XDeath:
		Stop;
	}
}
Class Q2Hornet : Q2MonsterBase
{
	Default {
	SeeSound "Hornet/Sight";
	ActiveSound "";
	PainSound "Hornet/Pain";
	AttackSound "Infantry/Attack1";
	DeathSound "Hornet/Death";
	+NOFEAR +NORADIUSDMG
	+BOSS +BOSSDEATH +DONTMORPH +FLOAT +NOGRAVITY +FLOATBOB
	+NOINFIGHTSPECIES
	Health 3000;
	Speed 8;
	PainChance 6;
	PainChance "BFG", 20;
	PainChance "BFGSplash", 5;
	DamageFactor "BFGSplash", 0.5;
	DamageFactor "BFGSplash", 0.33;
	Mass 2000;
	Radius 64;
	Height 100;
	Obituary "%o was chaingunned by a \c[d5]Flying Boss";
	DropItem "Q2Bullets", 128;
	DropItem "Q2Bullets", 128;
	DropItem "Q2Rockets", 128;
	DropItem "Q2Rockets", 128;
	Species "Hornet";
	Tag "\c[d5]Hornet"; }
	Void A_HornetAttack()
	{
		double a=angle;
		A_SpawnItemEx("EnemyFlashSpawner",40,55,72);
		A_SpawnItemEx("EnemyFlashSpawner",43,-50,73);
		A_SpawnItemEx("WeaponFlash",40,55,72);
		A_SpawnItemEx("WeaponFlash",43,-50,73);
		A_CustomBulletAttack(10,10,2,3);
		angle=a;
		A_SmoothFace(target,20);
	}
	States
	{
	Spawn:
		HNT0 A 0 NoDelay A_PlaySound("Hornet/Engine",CHAN_BODY,0.66,1);
		HNT0 ABCDEFGHIJKLMNOPQRST 3 A_Look;
		Loop;
	See:
		HNT0 A 0 { bNoPain=False; }
		TNT1 A 0 A_TakeInventory("Clip");
		HNT0 ABCDEFGHIJKLMNOPQRST 3 A_SmoothChase;
		Loop;
	Missile:
		"----" A 0 A_Jump(97,"Rockets");
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		HNT1 ABCDEFGHIJ 3 A_SmoothFace(target);
		HNT1 K 3 A_HornetAttack();
		HNT1 J 4 A_HornetAttack();
		HNT1 K 3 A_HornetAttack();
		HNT1 J 4 A_HornetAttack();
		HNT1 K 3 A_HornetAttack();
		HNT1 KK 3 A_SmoothFace(target,20);
		TNT1 A 0 { double a=angle; A_SpidRefire(); angle=a; }
		HNT1 K 0 A_GiveInventory("Clip",1);
		TNT1 A 0 A_JumpIfInventory("Clip",Random(3,5),1);
		Goto Missile+13;
		HNT1 JIHGFEDCBA 3;
		Goto See;
	Rockets:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		HNT1 LMNOPQRSSS 3 A_SmoothFace(target);
		TNT1 A 0 A_PlaySound("Hornet/Rocket",CHAN_WEAPON);
		TNT1 A 0 A_SpawnProjectile("HornetRocket",26,-12);
		TNT1 A 0 A_SpawnProjectile("HornetRocket",26,-4);
		TNT1 A 0 A_SpawnProjectile("HornetRocket",26,10);
		TNT1 A 0 A_SpawnProjectile("HornetRocket",26,16);
		HNT1 SS 5 A_SmoothFace(target);
		HNT1 RQPONML 3 A_SmoothFace(target);
		Goto See;
	Pain:
		"----" A 3 { bNoPain=True; }
		HNT2 A 3 A_Pain;
		HNT2 BCDEFGHIJKLMNOPQRSTUV 3;
		Goto See;
	Death:
		"----" A 3 { A_Scream(); bFLOATBOB=0; A_Gravity(); A_StopSound(CHAN_BODY); bNoDamage=True; }
		HNT3 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 3;
		HNT4 ABCDEFGHIJKLMNOPQRS 3;
		HNT4 T 2;
		TNT1 A 0 A_BossDeath;
		HNT4 TTTT 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,40),0,0,0,0,SXF_TRANSFERPOINTERS);
		HNT4 TTTT 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,40),0,0,0,0,SXF_TRANSFERPOINTERS); //comento makronexplosion
		HNT4 TTTT 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,40),0,0,0,0,SXF_TRANSFERPOINTERS);
		HNT4 TTTT 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,40),0,0,0,0,SXF_TRANSFERPOINTERS);
		HNT4 TTTT 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,40),0,0,0,0,SXF_TRANSFERPOINTERS);
		HNT4 TTTT 3 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,40),0,0,0,0,SXF_TRANSFERPOINTERS);
		HNT4 TTTT 0 A_SpawnItemEx("Q2Explosion",Random2(Radius),Random2(Radius),Random(0,40),0,0,0,0,SXF_TRANSFERPOINTERS);
		TNT4 A 0 A_Fall;
		TNT1 AAAAAAAAAAAAAAAA 0 A_SpawnItemEx("Q2Gib",Random2(Radius),0,Random(0,80),2,0,Random(0,10),Random(1,360));
		TNT1 A 5 A_XScream;
		Stop;
	XDeath:
		Stop;
	}
}

Class HornetRocket : Q2Rocket
{
	Default {
    Speed 15;
    Damage 10;
    ExplosionDamage 64;
	Obituary "%o almost dodged a \c[d5]Flying Boss's rocket";
    DontHurtShooter; }
}
Class Q2Jorg : Q2MonsterBase
{
	Default {
	SeeSound "Jorg/Sight";
	ActiveSound "Jorg/Active";
	PainSound "Makron/Pain";
	AttackSound "Makron/Attack4";
	DeathSound "Makron/Death";
	+NOINFIGHTSPECIES
	+NOFEAR
	+NORADIUSDMG
	+BOSS
	+BOSSDEATH
	+DONTMORPH
	+FULLVOLACTIVE
	Health 3000;
	Speed 18;
	PainChance 10;
	PainChance "BFG", 20;
	PainChance "BFGSplash", 5;
	DamageFactor "BFGSplash", 0.5;
	DamageFactor "BFGSplash", 0.33;
	Mass 3000;
	Radius 40;
	Height 110;
	DeathHeight 110;
	Obituary "%o was killed by the \c[q2]Jorg.";
	DropItem "Q2Bullets", 128;
	DropItem "Q2Bullets", 128;
	DropItem "Q2CellPack", 128;
	Species "Makron";
	Tag "\c[q2]Jorg"; }
	Void A_JorgAttack()
	{
		double a=angle;
		A_SpawnItemEx("EnemyFlashSpawner",70,43,67);
		A_SpawnItemEx("EnemyFlashSpawner",70,-43,67);
		A_SpawnItemEx("WeaponFlash",70,43,67);
		A_SpawnItemEx("WeaponFlash",70,-43,67);
		A_CustomBulletAttack(10,10,random(1,2),5);
		A_PlaySound("Makron/Attack5",CHAN_5);
		angle=a;
		A_SmoothFace(target,20);
	}
	States
	{
	Spawn:
		JRG0 A 0 A_Jump(192,2);
		TNT1 A 0 A_PlaySound("Makron/Active",CHAN_VOICE);
		JRG0 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 6 A_Look;
		Goto Spawn+1;
	See:
		JRG1 A 0 { bNoPain=False; }
		TNT1 A 0 A_TakeInventory("Clip");
		JRG1 AB 4 A_SmoothChase(null,null,CHF_DONTMOVE);
		JRG1 C 0 A_PlaySound("Makron/Step",CHAN_BODY);
		JRG1 C 4 A_SmoothChase(null,null,CHF_DONTMOVE);
		JRG1 DEFG 4 A_SmoothChase;
		JRG1 HI 4 A_SmoothChase(null,null,CHF_DONTMOVE);
		JRG1 J 0 A_PlaySound("Makron/Step",CHAN_5);
		JRG1 J 4  A_SmoothChase(null,null,CHF_DONTMOVE);
		JRG1 KLMN 3 A_SmoothChase;
		Loop;
	Missile:
		"----" A 0 A_Jump(96,"BFG");
		"----" A 1 A_StopSound(CHAN_BODY);
		"----" A 8 { A_SmoothFace(target); A_PlaySound("Makron/Attack1",CHAN_5); special1=0; }
		JRG2 ABCDEFGH 4 A_SmoothFace(target);
		JRG2 I 3 A_JorgAttack;
		JRG2 J 4 A_JorgAttack;
		JRG2 K 3 A_JorgAttack;
		JRG2 L 4 A_JorgAttack;
		JRG2 M 3 A_JorgAttack;
		JRG2 N 4 A_JorgAttack;
		JRG2 I 0 { double a=angle; A_MonsterRefire(128,2); angle=a; special1++; Return A_JumpIf(special1>=4,1); }
		Goto Missile+11;
		JRG2 OPQR 6 A_SmoothFace(target,20);
		Goto See;
	BFG:
		"----" A 1 A_StopSound(CHAN_BODY);
		"----" A 8 A_SmoothFace(target);
		JRG3 A 0 A_PlaySound("Makron/Attack2",0);
		JRG3 ABCDE 3 A_SmoothFace(target);
		JRG3 F 0 A_PlaySound("Weapons/BFG10KShot",CHAN_WEAPON);
		JRG3 F 4 A_SpawnProjectile("MakronBFGBall",85,-5);
		JRG3 GHIJKLM 3;// A_FaceTarget;
		Goto See;
	Pain:
		"----" A 0 { bNoPain=True; A_StopSound(CHAN_5); A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2");
	Pain1:
		"----" A 4;
		JRG4 AB 9;
		Goto See;
	Pain2:
		"----" A 4;
		JRG3 NOP 6;
		Goto See;
	Pain.BFGSplash:
	Pain.BFG:
		"----" A 4 { bNoPain=True; A_StopSound(CHAN_5); A_PlaySound("Makron/Pain3",CHAN_VOICE); }
		JRG4 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^" 5;
		Goto See;
	XDeath:
		Stop;
	Death:
		"----" A 4 { A_StopSound(CHAN_5); A_Scream(); bNoDamage=True; }
		JRG5 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 4;
		JRG6 ABCDEFGHIJKLMNOPQ 5;
		JRG6 R 6 A_Fall;
		JRG6 S 6 A_PlaySound("Makron/Deathb");
		JRG6 T 4 A_SetSolid;
		JRG6 U 35;
		JRG6 U 0 A_BossDeath;
		TNT1 A 0 A_GiveInventory("Cell");
		JRG6 UUUU 8 A_SpawnItemEx("MakronExplosion",Random2(64),Random2(64),0,0,0,0,0,SXF_TRANSFERPOINTERS);
		JRG6 UUUU 4 A_SpawnItemEx("MakronExplosion",Random2(64),Random2(64),0,0,0,0,0,SXF_TRANSFERPOINTERS);
		JRG6 UUUU 0 A_SpawnItemEx("MakronExplosion",Random2(64),Random2(64),0,0,0,0,0,SXF_TRANSFERPOINTERS);
		TNT1 A 0 A_UnSetSolid;
		TNT1 A 0 A_UnSetShootable;
		TNT1 A 0 A_XScream;
		TNT1 AAAAAAAAAAAAAAAA 0 A_SpawnItemEx("Q2Gib",Random2(64),0,Random(0,64),2,0,Random(0,10),Random(1,360));
		JRG6 U 5
		{
			bool asd;
			actor makie;
			[asd,makie]=A_SpawnItemEx("Q2Makron",0,0,0,0,0,5,0,SXF_TRANSFERPOINTERS|SXF_SETMASTER|SXF_NOCHECKPOSITION);
			If(makie)
			makie.SetStateLabel("Eject");
		}
		Stop;
	}
}
Class MakronExplosion : EffectBase
{
	Default {
	+NOINTERACTION
	Projectile;
	ExplosionDamage 32;
	ExplosionRadius 97; }
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_PlaySound("Weapons/RocketExplosion",CHAN_5);
		TNT1 A 0 A_SpawnItem("Q2Explosion");
		TNT1 A 0 A_Explode;
		Stop;
	}
}
Class MakronBFGBall : BFG10KBall
{
	Default {
	Damage 100;
	BFG10KBall.BeamDamage 8;
	ExplosionDamage 64; }
	States
	{
	Death:
		BFE1 A 5 Bright A_StopSound(1);
		BFE1 B 5 Bright A_ExplodeParticles;
		BFE1 C 5 Bright
		{
			A_Explode();
			A_BFGSpray("BFGExtra",20,10);
			A_ExplodeParticles();
			A_GiveInventory("Clip",1);
		}
		BFE1 DEF 5 Bright;
		Stop;
	}
}/*
ACTOR MakronBFGBeamSpawner : BFG10KBeamSpawner
{
	Health 4
	ReactionTime 3
}*/


Class Q2Makron : Q2Jorg
{
	Default {
	SeeSound "Jorg/Voice";
	ActiveSound "Jorg/Active";
	PainSound "Jorg/Pain";
	AttackSound "Jorg/Attack4";
	DeathSound "Jorg/Death";
	+FULLVOLACTIVE
	+NOINFIGHTSPECIES
	Speed 12;
	DeathHeight 20;
	PainChance 20;
	PainChance "Railgun", 100;
	Obituary "%o was killed by the \c[q2]Makron.";
	DropItem "Q2Slugs", 128;
	Species "Makron";
	Tag "\c[q2]The Makron"; }
	Void A_MakronBlaster(double spawnh, double spawnoffs, double ang)
	{
		A_SpawnProjectile("BlasterProjectile",spawnh,spawnoffs,ang,2,pitch);
		A_PlaySound("Jorg/Blaster",CHAN_WEAPON);
	}
	Void A_MakronTarget()
	{
		if(!target) return;
		A_SmoothFace(target);
		tracer=spawn("actor",target.pos+(0,0,target.height/2));
		if(!tracer) return;
		tracer.tics=35;
		tracer.bNoGravity=True;
		tracer.height=0;
	}
	Void A_MakronRail()
	{
		Actor st=target;
		if(tracer)
		target=tracer;
		Vector3 Offset=(RotateVector((0,0),Angle),32-32);
		SetOrigin(Pos+Offset,1);
		A_CustomRailgun(Random(40,80),0,"2F 67 7F","White",RGF_FULLBRIGHT,1,0,"Q2RailgunPuff");//,0,0,8129,35,1,1,null,0);
		SetOrigin(Pos-Offset,1);
		target=st;
		if(tracer) tracer.destroy();
		//JRG2 H 3 A_CustomRailgun(Random(40,80),5,"2F 67 7F","White",RGF_FULLBRIGHT,1,0,"Q2RailgunPuff",0,0,8129,35,1,1,Null,3,);
	}
	States
	{
	Eject:
		JRG0 ABCDEF 5;
		JRG0 G 5 A_PlaySound("Jorg/Land",CHAN_BODY);
		JRG0 HIKLM 5;
		Goto Spawn;
	Spawn:
		JRG4 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 6 A_Look;
		JRG5 A 0 A_PlaySound("Jorg/Laugh",CHAN_VOICE);
		JRG5 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 6 A_Look;
		JRG2 YZ 6 A_Look;
		JRG4 A 0 A_PlaySound("Jorg/Laugh",CHAN_VOICE);
		Goto Spawn+1;
	See:
		JRG6 J 0 { bNoPain=False; }
		TNT1 A 0 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG6 JA 5 A_SmoothChase;
		JRG6 BCD 4 A_SmoothChase;
		JRG6 E 0 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG6 EF 5 A_SmoothChase;
		JRG6 GHI 4 A_SmoothChase;
		Loop;
	Missile:
		"----" A 0 A_Jump(160,"Railgun","Blaster");
		"----" A 3;
		JRG0 NOP 4 A_SmoothFace(target);
		JRG0 Q 0 A_PlaySound("Weapons/BFG10KShot",CHAN_WEAPON);
		JRG0 Q 4 A_SpawnProjectile("MakronBFGBall",55,-23);
		JRG0 RSTUV 4;
		Goto See;
	Blaster:
		"----" A 3;
		JRG1 ABC 5 A_SmoothFace(target,0,0);
		JRG1 E 0
		{
			if(!target) return;
			Vector2 Dir=Q2StuffLib.FaceVector(target.pos+(0,0,target.height/2),pos+(0,0,50));
			Pitch=Dir.Y;
		}
		JRG1 E 3 A_MakronBlaster(50,-20,50);
		JRG1 F 4 A_MakronBlaster(50,-16,40);
		JRG1 G 3 A_MakronBlaster(50,-12,30);
		JRG1 H 4 A_MakronBlaster(50,-5,20);
		JRG1 I 3 A_MakronBlaster(50,5,10);
		JRG1 J 4 A_MakronBlaster(52,18,0);
		JRG1 K 3 A_MakronBlaster(52,33,-15);
		JRG1 L 4 A_MakronBlaster(52,35,-30);
		JRG1 M 3 A_MakronBlaster(52,35,-45);
		JRG1 N 4 A_MakronBlaster(52,30,-30);
		JRG1 O 3 A_MakronBlaster(50,23,-15);
		JRG1 P 4 A_MakronBlaster(50,23,0);
		JRG1 Q 3 A_MakronBlaster(50,16,8);
		JRG1 R 4 A_MakronBlaster(50,8,16);
		JRG1 S 3 A_MakronBlaster(50,0,25);
		JRG1 T 4 A_MakronBlaster(50,-8,33);
		JRG1 U 3 A_MakronBlaster(50,-17,42);
		JRG1 V 4 A_MakronBlaster(50,-25,50);
		JRG1 WXYZ 4;
		Goto See;
	Railgun:
		"----" A 3;
		JRG2 A 0 A_PlaySound("Weapons/RailGunCharge",CHAN_WEAPON);
		JRG2 ABCDEF 4 A_SmoothFace(target);
		JRG2 G 4 A_MakronTarget;
		JRG2 H 3 A_MakronRail;
		JRG2 IJKLMNOP 3;// A_FaceTarget;
		Goto See;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain();}
		"----" A 0 A_Jump(256,"Pain1","Pain2");
	Pain1:
		"----" A 4;
		JRG2 QRST 3;
		Goto See;
	Pain2:
		"----" A 4;
		JRG2 UVWX 3;
		Goto See;
	Pain.Railgun:
		"----" A 4 { bNoPain=True; A_Pain(); }
		JRG3 ABCDEF 4;
		JRG3 GHIJKLMNO 3;
		JRG3 P 0 A_PlaySound("Jorg/Popup",CHAN_BODY);
		JRG3 "PQRSTUVWXYZ^" 4;
		JRG6 J 0 A_PlaySound("Jorg/Voice",CHAN_VOICE);
		Goto Missile;
	Pain.BFGSplash:
	Pain.BFG:
		Stop;
	Death:
		TNT1 A 0 { A_Scream(); bNoDamage=True; }
		TNT1 AAAAA 0 A_SpawnItemEx("Q2Gib",0,0,50,2,0,Random(0,10),Random(1,360),0,128);
		TNT1 A 0 A_SpawnItemEx("MakronTorso",0,0,50,Random(1,2),Random2(2),5);
		JRG7 AB 4;
		JRG7 C 3 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG7 DEFGHIJKLMNO 4;
		JRG7 P 3 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG7 "QRSTUVWXYZ^[]" 4;
		JRG8 ABCD 4;
		JRG8 E 4 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG8 FGHIJKLMNOPQRSTUVWXY 4;
		JRG8 Z 4 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG8 "^" 4;
		JRG8 "[" 3 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG8 "]" 4;
		JRG9 ABCDE 4;
		JRG9 F 3 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG9 G 4;
		JRG9 H 3 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG9 IJ 4;
		JRG9 K 3 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG9 L 4;
		JRG9 M 3 A_PlaySound("Jorg/Step",CHAN_BODY);
		JRG9 "NOPQRSTUVWXYZ^[]" 4;
		JRGA ABCD 4;
		JRGA E 0 { A_NoBlocko(); bNoDamage=False; }
		TNT1 A 0 A_PlaySound("Jorg/Brain",CHAN_BODY);
		JRGA E 3 A_PlaySound("Jorg/Step",CHAN_AUTO);
		JRGA FG 4;
		JRGA H -1;
		Stop;
	Raise:
		Stop;
	}
}
Class MakronTorso : Actor
{
	Default {
	Health 500;
	Mass 0x7fffffff;
	+SHOOTABLE
	+CORPSE +ISMONSTER +INTERPOLATEANGLES
	Gravity 0.66; }
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_SetPitch(-75);
		JRG0 A 1 { special1+=3; }
		TNT1 A 0 A_JumpIf(special1>=80,2);
		TNT1 A 0 A_SetPitch(Pitch+3);
		TNT1 A 0;
		Goto Spawn+1;
	Crash:
		//TNT1 A 0 A_SpawnItemEx(DestroyableBodyThing,0,0,0,0,0,0,0,SXF_NOCHECKPOSITION|SXF_SETMASTER);
		TNT1 A 0 A_SetPitch(0);
		TNT1 A 0 A_PlaySound("Jorg/Spine",CHAN_BODY,1.0,1);
		JRG0 ABCDEFGHIJKLMNOPQRST 4;
		JRG0 A 0 { reactiontime--; Return A_JumpIf(reactiontime<1,"Ded"); }
		Goto Crash+3;
	Ded:
		"----" A -1 A_StopSound(CHAN_BODY);
		Stop;
	Crush:
	Death:
		TNT1 A 1;
		TNT1 AAAAAAA 0 A_SpawnItemEx("Q2Gib",Random2(Radius),0,FRandom(5,Height),Vel.X+FRandom(-1,1),Vel.Y+FRandom(-1,1),2+Vel.Z,FRandom(1,360),SXF_ABSOLUTEVELOCITY);
		TNT1 A 5 A_XScream;
		Stop;
	}
}
Class Q1Ranger : Q2MonsterBase
{
	Default {
	Health 100;
	PainChance 96;
	SeeSound "Ranger/Sight";
	ActiveSound "Ranger/Idle";
	PainSound "Ranger/Pain";
	DeathSound "Ranger/Death";
	+NOINFIGHTSPECIES
	Species "Q1Ranger";
	Obituary "%o died misteriously.";
	GibHealth 50; }
	Void A_RangerAttack()
	{
		If(!target) return;
		double a=angle;
		Switch(weaponspecial)
		{
			Case 2:
				A_PlaySound("Ranger/Attack1",CHAN_WEAPON);
				A_SpawnItem("WeaponFlash",0,32);
				A_CustomBulletAttack(8,8,3,2);
				Angle=a; A_SmoothFace(target);
				Break;
			Case 3:
				A_PlaySound("Ranger/Attack1b",CHAN_WEAPON);
				A_SpawnItem("WeaponFlash",0,32);
				A_CustomBulletAttack(12,12,10,2);
				Angle=a; A_SmoothFace(target);
				Break;
			Case 4:
				A_SmoothFace(target);
				A_SpawnItem("WeaponFlash",0,32);
				A_PlaySound("Weapons/ShotgunFire",CHAN_WEAPON);
				A_SpawnProjectile("RangerNail",36,12);
				Break;
			Case 5:
				A_SmoothFace(target);
				A_SpawnItem("WeaponFlash",0,32);
				A_PlaySound("Weapons/SNG",CHAN_WEAPON);
				A_SpawnProjectile("RangerSNGNail",36,12);
				Break;
			Case 6:
				A_SmoothFace(target);
				A_SpawnItem("WeaponFlash",0,32);
				A_PlaySound("Ranger/Attack2",CHAN_WEAPON);
				A_SpawnProjectile("RangerGrenade",36,12,0,CMF_OFFSETPITCH,Random(5,10));
				Break;
			Case 7:
				A_SmoothFace(target);
				A_SpawnItem("WeaponFlash",0,32);
				A_PlaySound("Ranger/Attack3",CHAN_WEAPON);
				A_SpawnProjectile("RangerRocket",36,12);
				Break;
			Case 8:
				A_SmoothFace(target);
				A_SpawnProjectile("RangerThunderBoltLightning",38,12);
				Break;
		}
	}
	Override Void PostBeginPlay()
	{
		If(!weaponspecial)
		weaponspecial=Random(2,8);
		Super.PostBeginPlay();
	}
	States
	{
	Spawn:
		QPL0 ABCDE 4 A_Look;
		Loop;
	See:
		QPL0 F 0 { bNoPain=False; }
		QPL0 FF 2 A_SmoothChase(flags:CHF_FASTCHASE);
		QPL0 GGHHIIJJKK 2 A_SmoothChase;
		GOto See+1;
	Missile:
		"----" A 0 A_JumpIf(weaponspecial==2,"Shotgun");
		"----" A 0 A_JumpIf(weaponspecial==3,"SSG");
		"----" A 0 A_JumpIf(weaponspecial==4,"Nailgun");
		"----" A 0 A_JumpIf(weaponspecial==5,"SNG");
		"----" A 0 A_JumpIf(weaponspecial==6,"Grenade");
		"----" A 0 A_JumpIf(weaponspecial==7,"Rocket");
		"----" A 0 A_JumpIf(weaponspecial==8,"Lightning");
	Shotgun:
		"----" A 1;
		"----" A 4 A_SmoothFace(target);
		QPL1 L 4 A_SmoothFace(target);
		QPL1 M 4 A_RangerAttack;
		QPL1 NOP 4 A_SmoothFace(target);
		TNT1 A 0 A_Jump(64,"See");
		TNT1 A 0 { double a=angle; A_CPosRefire(); angle=a; }
		Goto Shotgun+2;
	SSG:
		"----" A 4 A_SmoothFace(target);
		QPL1 L 4 A_SmoothFace(target);
		QPL1 M 4 A_RangerAttack;
		QPL1 NO 4 A_SmoothFace(target);
		QPL1 P 10 A_SmoothFace(target);
		TNT1 A 0 A_Jump(64,"See");
		TNT1 A 0 { double a=angle; A_CPosRefire(); angle=a; }
		Goto SSG+2;
	SNG:
		"----" A 1;
		"----" A 4 A_SmoothFace(target);
		QPL1 A 4 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 4 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 4 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 4 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 4 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		Goto See;
	Nailgun:
		"----" A 1;
		"----" A 3 A_SmoothFace(target);
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		QPL1 A 3 A_RangerAttack;
		QPL1 B 3 A_RangerAttack;
		Goto See;
	Grenade:
		"----" A 0 A_JumpIfCloser(1024,1);
		Goto See;
		"----" A 1;
		"----" A 4 A_SmoothFace(target);
		QPL1 E 4 A_SmoothFace(target);
		QPL1 F 3 A_RangerAttack;
		QPL1 FGHI 3 A_SmoothFace(target);
		QPL1 J 5;
		TNT1 A 0 A_Jump(192,"See");
		TNT1 A 0 A_JumpIfCloser(1024,1);
		Goto See;
		QPL1 E 4 A_SmoothFace(target);
		QPL1 F 3 A_RangerAttack;
		QPL1 FGHI 3 A_SmoothFace(target);
		QPL1 J 5;
		TNT1 A 0 A_Jump(160,"See");
		TNT1 A 0 A_JumpIfCloser(1024,1);
		Goto See;
		QPL1 E 4 A_SmoothFace(target);
		QPL1 F 3 A_RangerAttack;
		QPL1 FGHI 3 A_SmoothFace(target);
		QPL1 J 10;
		Goto See;
	Rocket:
		"----" A 1;
		"----" A 4 A_SmoothFace(target);
		QPL1 E 4 A_SmoothFace(target);
		QPL1 F 3 A_RangerAttack;
		QPL1 GHI 3 A_SmoothFace(target);
		QPL1 J 12;
		TNT1 A 0 A_Jump(128,"See");
		QPL1 F 3 A_RangerAttack;
		QPL1 GHI 3 A_SmoothFace(target);
		QPL1 J 12;
		TNT1 A 0 A_Jump(128,"See");
		QPL1 F 3 A_RangerAttack;
		QPL1 GHI 3 A_SmoothFace(target);
		QPL1 J 12;
		Goto See;
	Lightning:
		"----" A 0 A_JumpIfCloser(768,1);
		Goto See;
		"----" A 1;
		"----" A 4 A_SmoothFace(target);
		QPL1 C 8 A_SmoothFace(target);
		TNT1 A 0 A_PlaySound("Weapons/LightningStart",CHAN_WEAPON);
		QPL1 DDDD 3 A_RangerAttack;
		TNT1 A 0 A_PlaySound("Weapons/Lightning",CHAN_5);
		QPL1 DDDDDDDD 3 A_RangerAttack;
		TNT1 A 0 A_PlaySound("Weapons/Lightning",CHAN_5);
		QPL1 DDDD 3 A_RangerAttack;
		Goto See;
	Pain:
		QPL0 L 3 { bNoPain=True; A_Pain(); }
		QPL0 LMNOPQ 3;
		Goto See;
	Death:
		TNT1 A 0 A_JumpIf(weaponspecial>3,2);
		TNT1 A 0 A_DropItem("ShellBox");
		Goto DeathAnim;
		TNT1 A 0 A_JumpIf(weaponspecial>5,6);
		TNT1 A 0 A_DropItem("ClipBox");
		TNT1 A 0 A_JumpIf(weaponspecial==5,3);
		TNT1 A 0 A_Jump(256,"DeathAnim");
		TNT1 A 0 A_Jump(192,"DeathAnim");
		TNT1 A 0 A_DropItem("Q1SNG");
		Goto DeathAnim;
		TNT1 A 0 A_JumpIf(weaponspecial>7,2);
		TNT1 A 0 A_DropItem("RocketBox");
		Goto DeathAnim;
		TNT1 A 0 A_Jump(128,2);
		TNT1 AA 0 A_DropItem("Cell");
		TNT1 A 0 A_Jump(192,"DeathAnim");
		TNT1 A 0 A_DropItem("Q1LightningGun");
		Goto DeathAnim;
	DeathAnim:
		TNT1 A 0 A_Scream;
		TNT1 A 0 A_Jump(256,"Death1","Death2","Death3","Death4","Death5");
	Death1:
		QPL2 AB 3;
		QPL2 C 3 A_NoBlocko;
		QPL2 DEFGHIJ 3;
		QPL2 K -1;
		Stop;
	Death2:
		QPL2 LM 3;
		QPL2 N 3 A_NoBlocko;
		QPL2 OPQRS 3;
		QPL2 T -1;
		Stop;
	Death3:
		QPL3 AB 3;
		QPL3 C 3 A_NoBlocko;
		QPL3 DEFGHIJKLMN 3;
		QPL3 O -1;
		Stop;
	Death4:
		QPL3 PQ 3;
		QPL3 R 3 A_NoBlocko;
		QPL3 STUVW 3;
		QPL3 X -1;
		Stop;
	Death5:
		QPL4 AB 3;
		QPL4 C 3 A_NoBlocko;
		QPL4 DEFGH 3;
		QPL4 I -1;
		Stop;
	XDeath:
		TNT1 A 0 A_JumpIf(weaponspecial>3,2);
		TNT1 A 0 A_DropItem("ShellBox");
		Goto XDeathAnim;
		TNT1 A 0 A_JumpIf(weaponspecial>5,6);
		TNT1 A 0 A_DropItem("ClipBox");
		TNT1 A 0 A_JumpIf(weaponspecial==5,3);
		TNT1 A 0 A_Jump(256,"XDeathAnim");
		TNT1 A 0 A_Jump(192,"XDeathAnim");
		TNT1 A 0 A_DropItem("Q1SNG");
		Goto XDeathAnim;
		TNT1 A 0 A_JumpIf(weaponspecial>7,2);
		TNT1 A 0 A_DropItem("RocketBox");
		Goto XDeathAnim;
		TNT1 A 0 A_Jump(128,2);
		TNT1 AA 0 A_DropItem("Cell");
		TNT1 A 0 A_Jump(192,"XDeathAnim");
		TNT1 A 0 A_DropItem("Q1LightningGun");
		Goto XDeathAnim;
	XDeathAnim:
		TNT1 A 0 A_PlaySound("Ranger/XDeath");
		TNT1 AAAAAAAA 0 A_SpawnItemEx("Q2Gib",Random2(20),0,Random(0,50),Random(0,5),0,Random(0,10),Random(1,360));
		TNT1 A 1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}
Class RangerNail : SNGNail
{
	Default {
	+STRIFEDAMAGE
	Damage 3; }
}
Class RangerSNGNail : RangerNail { Default { Damage 4; } }
Class RangerGrenade : Q2Grenade
{
	Default {
	BounceSound "Ranger/Attack2b";
	ExplosionDamage 64;
	Damage 10;
	Translation "221:221=176:176", "232:235=183:188";
	DontHurtShooter; }
	States
	{
	Death:
		TNT1 A 0 A_PlaySound("Ranger/Attack2b");
		Goto Super::Death+1;
	XDeath:
		TNT1 A 0 A_PlaySound("Ranger/Attack3b");
		Goto Super::XDeath+1;
	}
}
Class RangerRocket : Q2Rocket
{
	Default {
	DeathSound "Ranger/Attack3b";
	ExplosionDamage 64;
	Damage 10;
	Speed 25;
	DontHurtShooter; }
}
Class RangerThunderBoltLightning : ThunderBoltLightning { Default { DamageFunction (Random(0,3)); } }

Class USMCSoldier : Q2MonsterBase
{
	Default {
	Health 50;
	DeathSound "usmc/death";
	PainSound "usmc/pain";
	AttackSound "Weapons/MachineGunFire";
	+NOINFIGHTSPECIES
	Obituary "%o is dead, not big surprise.";
	Species "USMCSoldier";
	DropItem "Q2Bullets", 128;
	DropItem "Q2MachineGun", 64; }
	Void A_USMCAttack()
	{
		double a=angle;
		A_SpawnItemEx("EnemyFlashSpawner",22,10,38);
		A_SpawnItem("WeaponFlash",0,32);
		A_CustomBulletAttack(8,8,1,2*FRandom(1,2),"BulletPuff",0,CBAF_NORANDOM);
		angle=a;
		A_SmoothFace(target);
	}
	States
	{
	Spawn:
		USM0 ABCDEFGHIJKLMNOPONMLKJIHGFEDCB 6 A_Look;
		Loop;
	See:
		USM0 Q 0 { bNoPain=False; }
		USM0 QRSTUV 3 A_SmoothChase;
		Loop;
	Missile:
		"----" A 1 { special1=0; }
		"----" A 8 A_SmoothFace(target);
		USM1 A 4 A_USMCAttack;
		USM1 A 3 A_USMCAttack;
		USM1 A 0 { special1++; Return A_JumpIf(special1>=10,2); }
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_Jump(97,"See");
		TNT1 A 0;
		Goto Missile+2;
	Pain:
		"----" A 0 { bNoPain=True; A_Pain(); }
		"----" A 0 A_Jump(256,"Pain1","Pain2","Pain3");
	Pain1:
		"----" A 3;
		USM1 IJKL 3;
		Goto See;
	Pain2:
		"----" A 3;
		USM1 MNOP 3;
		Goto See;
	Pain3:
		"----" A 3;
		USM1 QRST 3;
		Goto See;
	Death:
		"----" A 0 A_Scream;
		"----" A 0 A_Jump(256,"Death1","Death2","Death3","Death4");
	Death1:
		"----" A 3;
		USM2 AB 6;
		USM2 C 6 A_NoBlocko;
		USM2 DE 6;
		USM2 F -1;
		Stop;
	Death2:
		"----" A 3;
		USM2 GH 6;
		USM2 I 6 A_NoBlocko;
		USM2 JK 6;
		USM2 L -1;
		Stop;
	Death3:
		"----" A 3;
		USM2 NO 6;
		USM2 P 6 A_NoBlocko;
		USM2 QRS 6;
		USM2 T -1;
		Stop;
	Death4:
		"----" A 3;
		USM2 UV 6;
		USM2 W 6 A_NoBlocko;
		USM2 X 6;
		USM2 Y -1;
		Stop;
	Raise:
		"----" A 8 A_Raised;
		Goto See;
	}
}