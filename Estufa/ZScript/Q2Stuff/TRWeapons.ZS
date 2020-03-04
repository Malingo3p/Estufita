Class Q2Phalanx : Q2Weapon
{
	Default {
	Tag "Phalanx Particle Cannon";
	Inventory.PickupMessage "Phalanx Particle Cannon";
	Weapon.AmmoGive 10;
	Weapon.SlotNumber 3;
	Weapon.AmmoType "Q2Magslug";
	Weapon.AmmoUse 1;
	Inventory.Icon "W_PHLNX"; }
	States
	{
	Spawn:
		PLAS A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",12);
		PHA0 ABCDEF 4;
		Goto Ready+1;
	Ready:
		TNT1 A 0;
		PHA1 AAA 6 A_WeaponReady;
		TNT1 A 0 A_Jump(64,1);
		Loop;
		PHA1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 6 A_WeaponReady;
		PHA2 ABCDEFGHIJ 6 A_WeaponReady;
		Goto Ready+1;
	Deselect:
		PHA1 A 3;
		PHA0 TUVWX 3;
		Goto InstantDeselect;
	Fire:
		PHA0 G 4;
		PHA0 H 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/PhalanxShot",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/PhalanxShot",CHAN_WEAPON,0.5,0,3);
		TNT1 A 0 A_FireProjectile("PhalanxPhoton",1.5,1,8,-4);
		TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		TNT1 A 0 A_GunFlash;
		PHA0 H 4;
		PHA0 I 0 A_FireProjectile("PhalanxPhoton",-1.5,0,8,-4);
		TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		TNT1 A 0 A_GunFlash;
		PHA0 IJKLMNOPQRS 4;
		Goto Ready+1;
	Flash:
		TNT1 A 0 A_Light2;
		TNT1 A 1 A_SetPitch(Pitch-3.0);
		TNT1 A 1 A_SetPitch(Pitch+1);
		TNT1 A 0 A_Light1;
		TNT1 AA 1 A_SetPitch(Pitch+1);
		Goto LightDone;
	}
}
Class PhalanxPhoton : PlasmaBall
{
	Default {
	-ZDOOMTRANS
	RenderStyle "Translucent";
	Alpha 0.75;
	Damage 10;
	ExplosionDamage 64;
	Obituary "%o was absolutely destroyed by %k's Phalanx.";
	Scale 0.85;
	SeeSound "";
	DeathSound "Weapons/RocketExplosion";
	Decal "Scorch"; }
	States
	{
	Spawn:
		PHOT A 0 Bright NoDelay A_PlaySound("Weapons/RocketFly",CHAN_VOICE,0.66,1);
		PHOT AAAABBBBCCCC 1 Bright Light("Rocket")
		{
			A_SpawnItemEx("BlasterTrailSpawner",0,0,6,flags:SXF_TRANSFERSCALE);
			A_SpawnItemEx("BlasterTrailSpawner",0,0,6,flags:SXF_TRANSFERSCALE);
			A_SpawnItemEx("BlasterTrailSpawner",-Vel.X/2,-Vel.Y/2,-Vel.Z/2+6,flags:SXF_ABSOLUTEPOSITION|SXF_TRANSFERSCALE);
			A_SpawnItemEx("BlasterTrailSpawner",-Vel.X/2,-Vel.Y/2,-Vel.Z/2+6,flags:SXF_ABSOLUTEPOSITION|SXF_TRANSFERSCALE);
		}
		Loop;
	Death:
		TNT1 A 0 A_Explode;
		TNT1 A 5 A_SpawnItem("Q2Explosion");
		Stop;
	}
}/*
Class ReckoningRocketLauncherReplacer : RandomSpawner Replaces RocketLauncher
{
	Default {
	DropItem "RocketLauncherReplacer", 256, 100;
	DropItem "Q2Phalanx", 256, 33; }
}*/
Class IonRipper : Q2Weapon
{
	Default {
	Tag "Ion Ripper";
	Inventory.PickupMessage "Ion Ripper";
	Weapon.AmmoGive 20;
	Weapon.SlotNumber 1;
	Weapon.AmmoType "Q2Cell";
	Weapon.AmmoUse 1;
	Inventory.Icon "W_RIPPER"; }
	States
	{
	Spawn:
		PLAS A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",12);
		RIP0 ABCDEF 4;
		Goto Ready+1;
	Ready:
		TNT1 A 0;
		RIP0 H 6 A_WeaponReady;
		TNT1 A 0 A_Jump(64,1);
		Loop;
		RIP0 H 6 A_WeaponReady;
		RIP1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^" 6 A_WeaponReady;
		Goto Ready+1;
	Deselect:
		RIP0 H 5;
		RIP2 ABC 5;
		Goto InstantDeselect;
	Fire:
		RIP0 F 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/RipperFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/RipperFire",CHAN_WEAPON,0.5,0,3);
		TNT1 A 0 A_FireProjectile("IonRipperProjectile",0,1,8,0);
		TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		RIP0 F 4 A_GunFlash;
		RIP0 G 4;
		RIP0 H 2;
		Goto Ready+1;
	Flash:
		TNT1 A 0 A_Light2;
		TNT1 A 1 A_SetPitch(Pitch-3.0);
		TNT1 A 1 A_SetPitch(Pitch+1);
		TNT1 A 0 A_Light1;
		TNT1 AA 1 A_SetPitch(Pitch+1);
		Goto LightDone;
	}
}
Class IonRipperProjectile : Actor
{
	Default {
	Radius 3;
	Height 6;
	Speed 21;
	Damage 15;
	MissileHeight 8;
	//BounceCount 5;
	Projectile;
	+STRIFEDAMAGE
	+HEXENBOUNCE
	+BLOODSPLATTER
	+INTERPOLATEANGLES
	BounceFactor 1.0;
	WallBounceFactor 1.0;
	DeathSound "Weapons/LaserHit";
	Decal "BlasterScorch";
	ReactionTime 140; }
    States
    {
    Spawn:
        TNT1 A 0 NoDelay A_PlaySound("Weapons/LaserFly",CHAN_VOICE,0.25,1);
        NULL A 1 Light("BlasterProjectile") Bright
		{
			A_SpawnItemEx("BlasterTrail",0,0,3,0,0.5,0,0,SXF_ABSOLUTEPOSITION);
			A_SpawnItemEx("BlasterTrail",0,0,3,0,-0.5,0,0,SXF_ABSOLUTEPOSITION);
		}
        TNT1 A 0 A_Countdown;
        Goto Spawn+1;
    Death:
		TNT1 A 0 A_Stop;
        TNT1 A 0 A_SpawnItem("BlasterProjectileImpact");
        TNT1 A 3 Light("BlasterProjectile_X1");
        TNT1 A 3 Light("BlasterProjectile_X2");
        TNT1 A 3 Light("BlasterProjectile_X3");
        TNT1 A 3 Light("BlasterProjectile_X4");
        Stop;
    XDeath:
        TNT1 A 0;
        Stop;
    }
}
Class TrapAmmo : Ammo { Default { Inventory.MaxAmount 5; Ammo.BackPackMaxAmount 10; } }
Class Q2Trapito : Q2Weapon
{
	Default {
	Tag "Trap";
	Inventory.PickupMessage "Trap";
	Weapon.AmmoGive 1;
	Weapon.SlotNumber 1;
	Weapon.SlotPriority 10;
	Weapon.AmmoType "TrapAmmo";
	Weapon.AmmoUse 1;
	Inventory.PickupSound "misc/ammo_pkup";
	Inventory.Icon "A_TRAP"; }
	Override Bool ShouldStay() { Return False; }
	States
	{
	Spawn:
		RBOX A -1;
		Stop;
	Select:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",12);
		TNT1 A 1 A_Raise;
		Wait;
	Ready:
		TNT1 A 0;
		TRA1 AAA 6 A_WeaponReady;
		TNT1 A 0 A_Jump(64,1);
		Loop;
		TRA1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^" 6 A_WeaponReady;
		TRA0 XYZ 6 A_WeaponReady;
		Goto Ready+1;
	Deselect:
		TRA1 A 1 A_Lower;
		Wait;
	Fire:
		TRA0 ABCD 3;
		TRA0 E 3 A_PlaySound("Weapons/TrapOpen",CHAN_WEAPON);
		TRA0 FGHIJK 3;
		TRA0 LM 5;
	Hold:
		TNT1 A 0;
		TRA0 P 3;
		TNT1 A 0 A_ReFire;
		TRA0 P 3 { Actor Trap=A_FireProjectile("Q2Trapo",0,1,5,0,0,-8); Trap.Master=Self; }
		TRA0 ONM 3;
		TNT1 A 20;
		Goto Ready+1;
	}
}
Class Q2Trapo : Actor
{
	Default
	{
		+MISSILE
		+NOTRIGGER
		+NOBLOOD
		+INTERPOLATEANGLES
		+BOUNCEONACTORS
		-NOBLOCKMAP
		+NOTAUTOAIMED
		+EXTREMEDEATH
		Tag "Trap";
		BounceType "Doom";
		Speed 16;
		Gravity 0.5;
		BounceFactor 0.33;
		Radius 5;
		Height 5;
		Health 30;
		Mass 0x7fffffff;
	}
	Void A_Succ()
	{
		Bool Suckie=False;
		Bool Ded=False;
		Bool alive=false;
		AddZ(12);
		BlockThingsIterator It=BlockThingsIterator.Create(Self,16);
		While(It.Next())
		{
			If(It.Thing && It.Thing.bShootable && CheckSight(It.Thing) || It.Thing Is "Q2Gib")
			{
				Double ZDiff=Abs(Pos.Z-It.Thing.Z);
				If((It.Thing.bIsMonster || It.Thing.Player) && !It.Thing.bNoBlood && ZDiff<=64)
				{
					For(Int i=0;i<15;i++)
					{
						Color Col;
						If(It.Thing.BloodColor) Col=It.Thing.BloodColor;
						Else Col=Color(255,255,Random(0,64),0);

						Vector3 Offs=(FRandom(-It.Thing.Radius,It.Thing.Radius),FRandom(-It.Thing.Radius,It.Thing.Radius),FRandom(5,It.Thing.Height));
						Vector3 Diff=Pos-It.Thing.Pos+Offs;
						Double Dist=Abs(Diff.Length());
						Vector2 Dir=Q2StuffLib.FaceVector(Pos,It.Thing.Pos+Offs);
						Int T=10;
						Double S=Dist/T;
						Vector3 V=(
						(Cos(Dir.X)*S)*Cos(Dir.Y),
						(Sin(Dir.X)*S)*Cos(Dir.Y),
						Sin(-Dir.Y)*S);
						It.Thing.A_SpawnParticle(Col,SPF_FULLBRIGHT,T,5,0,Offs.X,Offs.Y,Offs.Z,V.X,V.Y,V.Z);
					}
					alive=it.thing.health>0;
					Int Dmg=It.Thing.DamageMobj(self,master? Master:Null,20,"Normal",DMG_THRUSTLESS);
					If(alive && it.thing.bShootable)
					specialf1+=Dmg/40.;
					Suckie=True;
					If(it.thing.health<1) ded=true;
				}
				Else If(it.thing Is "Q2Gib")
				{
					it.thing.bNoInterAction=True;
					int sp=it.thing.sprite;
					int fr=it.thing.frame;
					it.thing.SetStateLabel("Null");
					it.thing.sprite=sp;
					it.thing.frame=fr;
					it.thing.tics=11;
					Vector2 Dir=Q2StuffLib.FaceVector(pos,it.thing.pos);
					it.thing.Vel3DFromAngle(Distance3D(it.thing)/10,Dir.X,Dir.Y);
				}
			}
		}
		AddZ(-12);
		If(Suckie)
		{
			If(Ded && alive)
			A_PlaySound("Weapons/TrapDown",CHAN_VOICE);
			A_PlaySound("Weapons/TrapSuck",0);
			For(int i=0;i<5;i++)
			A_SpawnParticle("66FFFF",SPF_FULLBRIGHT|SPF_RELATIVE,5,5,FRandom(1,360),0,0,5,FRandom(0,2),0,FRandom(0,4));
		}
	}
	States
	{
	Spawn:
		CELL A -1;
		Stop;
	Death:
		TNT1 A 0 A_JumpIf(Health<1,"Boom");
		CELL F 5 A_CheckFloor(1);
		Wait;
		CELL F 10 { bShootable=True;}
		CELL BCD 5;
		CELL E 0 A_PlaySound("Weapons/TrapLoop",1,1,1);
		CELL E 1
		{
			special1++;
			Color Col=Color(255,255,Random(128,192),0);
			For(Int i=3;i<18;i++)
			A_SpawnParticle(Col,SPF_FULLBRIGHT|SPF_RELVEL,10,4,FRandom(1,360),0,0,i*4,FRandom(0,1),0,FRandom(-1,1),0,0,0.1);
			For(Int i=0;i<5;i++)
			A_SpawnParticle(Col,SPF_FULLBRIGHT|SPF_RELVEL|SPF_RELPOS,10,4,FRandom(1,360),FRandom(0,20),0,FRandom(12,40),FRandom(0,1),0,FRandom(-1,1));
			Int SuccTics=5;
			If(Level.Time%SuccTics==0)
			{
				A_Succ();
				A_RadiusThrust(-256*SuccTics,192,RTF_NOTMISSILE|RTF_NOIMPACTDAMAGE,128);
				A_RadiusThrust(-64*SuccTics,192,RTF_NOIMPACTDAMAGE,128);
				A_RadiusThrust(-32,192,RTF_NOTMISSILE|RTF_NOIMPACTDAMAGE|RTF_THRUSTZ,128);
			}
			If(specialf1>=100 || special1>35*10)
			Return ResolveState(1);
			Return ResolveState(null);
		}
		Wait;
		//CEll E 35;
		TNT1 A 0 { A_UnSetShootable(); A_PlaySound("Weapons/TrapOpen",1,pitch:2); }
		CELL EDCB 3;
		CELL F 70 A_JumpIf(!specialf1,10);
		CELL FBCD 4;
		CELL E 35
		{
			Let h=Health(Spawn("TrapHealth",Pos,ALLOW_REPLACE));
			h.amount=int(min(100,specialf1));
			h.TossItem();
		}
		CELL EDCB 4;
		CELL F 1 A_FadeOut(0.01);
		Wait;
	Boom:
		TNT1 A 5 { A_PlaySound("Weapons/RocketExplosion"); A_SpawnItem("Q2Explosion"); }
		Stop;
	}
}
Class TrapHealth : Health
{
	Default
	{
		+INVENTORY.ALWAYSPICKUP
		Inventory.Amount 100;
		Inventory.MaxAmount 300;
		Inventory.PickupMessage "";
		Inventory.PickupSound "misc/m_health";
	}
	States
	{
	Spawn:
		BON1 A -1 Bright;
		Stop;
	}
}
