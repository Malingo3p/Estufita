Class Q2EFTRifle : Q2Weapon
{
	Default {
	Tag "EFT Rifle";
	Inventory.PickupMessage "$GOTSHOTGUN";
	Q2Weapon.SkinID "B";
	Weapon.SelectionOrder 300;
	Weapon.AmmoType "Q2FlachetteAmmo";
	Weapon.AmmoUse 1;
	Weapon.SlotNumber 4;
	Weapon.AmmoGive 4;
	Inventory.Icon "W_EFT"; }
	States
	{
	Spawn:
		EFTR A -1;
		Stop;
	Raise:
		EFTA A 4;
		EFTA B 3;
		EFTA C 4;
		EFTA D 3;
		EFTA E 4;
		EFTI A 4 A_WeaponReady;
		Goto Ready;
	Ready:
	    TNT1 A 0;
        EFTI ABCDEFGHIJKLMNOPQRSTUVWXYZ 4 A_WeaponReady;
        EFT1 ABCD 4 A_WeaponReady;
		Loop;
	Deselect:
		EFTW A 2;
		EFTW BCD 4;
		Goto InstantDeselect;
	Fire:
		EFTP A 3;
		TNT1 A 0 A_PlaySound("Weapons/EFTRifleFire",CHAN_WEAPON);
        TNT1 A 0 A_FireProjectile("SNGNail",0,1,8,4);
        EFTP B 3;
		TNT1 A 0 A_PlaySound("Weapons/EFTRifleFire",CHAN_WEAPON);
        TNT1 A 0 A_FireProjectile("SNGNail",0,1,3,4);
        Goto Ready;
        Goto Ready;
	}
}

Class Q2PlasmaBeamer : Q2Weapon
{
	Default {
	Tag "Plasma Beamer";
	Inventory.PickupMessage "Plasma Beamer";
	Weapon.AmmoGive 20;
	Weapon.SlotNumber 8;
	Weapon.AmmoType "Q2Cell";
	Weapon.AmmoUse 2;
	Inventory.Icon "W_BEAMER"; }
	States
	{
	Spawn:
		PLAS A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",12);
		BEM0 ABCDEFGHI 3;
		Goto Ready+1;
	Ready:
		TNT1 A 0;
		BEM1 A 6 A_WeaponReady;
		TNT1 A 0 A_Jump(64,1);
		Loop;
		BEM1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^" 6 A_WeaponReady;
		BEM0 Z 6;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		TNT1 A 0 A_Overlay(2,"Null");
		BEM0 OPQRS 3;
		Goto InstantDeselect;
	Fire:
		TNT1 A 0 A_Overlay(2,"Beamy");
		TNT1 A 0 A_PlaySound("Weapons/BFG10KFly",CHAN_WEAPON,0.66,1);
	Hold:
		BEM0 J 3; BEM0 K 0 A_ReFire(1); Goto FireStop;
		BEM0 K 3; BEM0 L 0 A_ReFire(1); Goto FireStop;
		BEM0 L 3; BEM0 M 0 A_ReFire(1); Goto FireStop;
		BEM0 M 3; BEM0 N 0 A_ReFire(1); Goto FireStop;
		BEM0 N 3;
		BEM0 J 0 A_ReFire;
		Goto FireStop;
	FireStop:
		TNT1 A 0 A_StopSound(CHAN_WEAPON);
		TNT1 A 0 A_Overlay(2,"Null");
		Goto Ready;
	Beamy:
		TNT1 A 0 A_PlasmaHitscan;
		TNT1 AAA 1 A_PlasmaBeam;
		TNT1 A 0 A_PlasmaHitscan;
		TNT1 AAAA 1 A_PlasmaBeam;
		Loop;
	}
	Action Void A_PlasmaHitscan()
	{
		If(!Player) Return;
		If(CountInv(Invoker.AmmoType1)<Invoker.AmmoUse1)
		{
			A_PlaySound("Weapons/NoAmmo",CHAN_WEAPON);
			Return;
		}
		Double Range=2048;
		double pitche=pitch; pitch=AimLineAttack(angle, Range);
		LineAttack(Angle,Range,Pitch,40,"Fire","BeamerPuff",LAF_NORANDOMPUFFZ);
		Invoker.DepleteAmmo(Invoker.bAltFire, true, 1);
		A_PlaySound("Weapons/BFG10KFly",CHAN_WEAPON,0.66,1);
		A_GunFlash();
		pitch=pitche;
	}
	Action Void A_PlasmaBeam()
	{
		If(!Player || CountInv(Invoker.AmmoType1)<Invoker.AmmoUse1) Return;
		Double Range=2048;
		double pitche=pitch; pitch=AimLineAttack(angle, Range);
		FTranslatedLineTarget t;
		Actor Puff=LineAttack(Angle,Range,Pitch,0,"Fire","BlankPuff",LAF_NORANDOMPUFFZ,t);
		If(Puff)
		{
			Actor Origin=HLW_Spawn("EffectBase",15,-7,-8);
			Actor Zap=Spawn("LightningBeamBase",Origin.Pos,ALLOW_REPLACE);
			Let Zapp=LightningBeamBase(Zap);
			Zapp.framen=1;
			Zap.A_SetRenderStyle(1,STYLE_Normal);
			//Zap.SetShade("Green");
			Zap.Tracer=Puff;
			Zap.Scale.X=1;
			Zap.ReactionTime=0;
			Zap.SetOrigin((Zap.Pos.XY+Vel.XY,Zap.Pos.Z),1);
			Zap.Vel-=Vel;
			Zap.bNoTimeFreeze=True;
			Actor Ring=Spawn("BeamerRingSpawner",Origin.Pos,ALLOW_REPLACE);
			If(Ring)
			{
				Ring.Tracer=Puff;
				Ring.Target=Self;
				Ring.SetOrigin((Ring.Pos.XY+Vel.XY,Ring.Pos.Z),1);
			}
		}
		pitch=pitche;
		invoker.weaponspecial++;
	}
}
Class BeamerRingSpawner : EffectBase
{
	Default { Speed 5; ReactionTime 16; }

	Action Actor Ringofseto(Class<Actor> Type, Double XOffs=0, Double YOffs=0,Double ZOffs=0)
	{ //imported from lambda, heh
		Vector2 R=RotateVector((XOffs*Cos(-Pitch) + Sin(Pitch)*ZOffs,YOffs),Angle);
		Vector3 SpawnOffs=(Pos.XY+R,Pos.Z + ZOffs*Cos(Pitch)  +  XOffs*Sin(-Pitch));
		Return Spawn(Type,SpawnOffs,ALLOW_REPLACE);
	}
	Override Void PostBeginPlay()
	{
		Super.PostBeginPlay();
		If(!Tracer) Destroy();
		Double Dist=Distance3D(Tracer);
		Double Traveled;
		Vector2 Dir=Q2StuffLib.FaceVector(Tracer.Pos,Self.Pos);
		Angle=Dir.X; Pitch=Dir.Y;
		Vel3DFromAngle(Speed,Angle,Pitch);
		Int Disto;
		Double DistFromCenter=4;
		Double DistFactor;
		Int RingAmount=16;
		While(Traveled<Dist)
		{
			Traveled+=Speed;
			Disto++;
			If(Traveled>5)
			DistFactor=Min(DistFactor+0.1,1);
			SetOrigin(Pos+Vel,1);
			If((Disto-Int(Level.Time*1.5))%ReactionTime==0)
			For(int i=0;i<RingAmount;i++)
			{
				Double C=Cos(360*i/RingAmount)*DistFromCenter;
				Double S=Sin(360*i/RingAmount)*DistFromCenter;
				Actor Ring=Ringofseto("EffectBase",0,C*DistFactor,S*DistFactor);
				If(Ring)
				{
					Ring.bNoTimeFreeze=True;
					Ring.SetState(FindState("Ring",1));
					Ring.A_SetScale(2);
					Ring.A_SetRenderStyle(0.95,STYLE_SHADED);
					Color Col=Color(255,255,160+Int(95*abs(Cos(540*i/RingAmount))),Int(90*abs(Cos(540*i/RingAmount))));
					Ring.SetShade(Col);
					If(Target)
					Ring.Prev=Ring.Prev-Target.Vel;
				}
			}
		}
		Destroy();
	}
	States
	{
		Ring:
			P001 A 2 Bright;
			Stop;
	}
}
Class BeamerPuff : Q2BulletPuff
{
	Default {
	Translation "80:111=[255,255,0]:[255,64,0]";
	DamageType "Fire";
	Decal "BlasterScorch"; }
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_PlaySound("Weapons/LaserHit");
		TNT1 AAAAAAAAAAAAA 0 A_SpawnItemEx("Q2BulletPuffParticle",FRandom(0,12),0,FRandom(-8,15),FRandom(0,0.5),0,FRandom(-1,-0.1),Random(1,360),1);
		Stop;
	}
}