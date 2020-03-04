Const WRF_BOBONLY = WRF_NOFIRE | WRF_NOSWITCH;
Class Q2Weapon : DoomWeapon
{
	String SkinID;
	Property SkinID: SkinID;
	Default {
	Tag "[Insert Weapon Name Here]";
	Inventory.PickupMessage "[Insert Weapon Message Here]";
	+WEAPON.NOALERT
	Q2Weapon.SkinID "B";
	Weapon.BobStyle "InverseSmooth";
	Weapon.BobSpeed 2;
	Weapon.BobRangeX 0.66;
	Weapon.BobRangeY 0.66; }

	Action Actor HLW_Spawn(Class<Actor> Type, Double XOffs=0, Double YOffs=0,Double ZOffs=0)
	{ //imported from lambda, heh
		Vector2 R=RotateVector((XOffs*Cos(-Pitch) + Sin(Pitch)*ZOffs,YOffs),Angle);
		Vector3 SpawnOffs=(Pos.XY+R,Player.ViewZ  +  ZOffs*Cos(Pitch)  +  XOffs*Sin(-Pitch));
		Return Spawn(Type,SpawnOffs,ALLOW_REPLACE);
	}
	Static Vector3 Veto3Rotato(Double XOffs=0, Double YOffs=0,Double ZOffs=0, Double Angle=0, Double Pitch=0)
	{
		Vector2 R=RotateVector((XOffs*Cos(-Pitch) + Sin(Pitch)*ZOffs,YOffs),Angle);
		Vector3 SpawnOffs=(R,ZOffs*Cos(Pitch)  +  XOffs*Sin(-Pitch));
		Return SpawnOffs;
	}
	Static Actor FireTrasero(Actor Self, Vector3 Origin=(0,0,0), Vector2 Dir=(0,0),Int Damage=0, Double Range=MISSILERANGE, Class<Actor> PuffType="BulletPuff", String DecalName="")
	{
		Actor Puff;/*
		If(Self && Origin==(0,0,0)) Origin=Self.Pos;
		//If(Self.Player) origin.z=player.viewz;
		//vector3 dir=origin+Q2StuffLib.Vec3ToDir(512,angle,pitch);
		Vector3 direction;
		//direction.xy = AngleToVector(Angle);
		//direction.z = sin(-Pitch);
		trasero t=new("trasero");
		t.ignore=self;
		t.Trace(origin,self.cursector,(cos(Dir.X)*cos(Dir.Y),sin(Dir.X)*cos(Dir.Y),-sin(Dir.Y)),Range,0);
		//spawn("itemfog",pos+direction);
		if ( t.Results.HitType != TRACE_HitNone )
		{
			Bool NoPuffSpawn=False;
			if ( t.Results.HitType == TRACE_HitActor)
			{
				t.Results.HitActor.DamageMobj(self,self,damage,'hitscan');
				If(!t.Results.HitActor.bNoBlood)
				{
					self.SpawnBlood(t.results.HitPos,t.results.SrcAngleFromTarget,damage);
					NoPuffSpawn=True;
				}
			}
			if ( !NoPuffSpawn && (
			     t.Results.HitType == TRACE_HitWall ||
				 t.Results.HitType == TRACE_HitCeiling ||
				 t.Results.HitType == TRACE_HitFloor ||
				 t.Results.HitType == TRACE_HitActor ) )
			{
				TextureID SkyTex=TexMan.CheckForTexture("F_SKY1",TexMan.Type_Any);
				//Self.A_Log(TexMan.GetName(t.Results.HitTexture).." and "..TexMan.GetName(SkyTex).." are they equal? ".. ((t.Results.HitTexture==SkyTex)?"yea":"fuck no"));
				If((t.Results.HitType == TRACE_HitCeiling || t.Results.HitType == TRACE_HitFloor) && t.Results.HitTexture==SkyTex) NoPuffSpawn=True;
				If(t.Results.HitType == TRACE_HitWall && t.Results.HitLine && t.Results.HitLine.special==9) NoPuffSpawn=True;
				If(t.Results.HitType == TRACE_HitWall && T.Results.HitLine.activation) self.a_log(T.Results.HitLine.activation.." "..AF_MissileTrigger);//T.Results.HitLine.RemoteActivate(Self,t.Results.Side,AF_MissileTrigger,Self.Pos);
				//spawn("BulletPuff",t.results.HitPos,allow_replace);
				If(!NoPuffSpawn)
				{
					Puff=self.SpawnPuff(PuffType,t.results.HitPos,t.results.SrcAngleFromTarget,t.results.SrcAngleFromTarget,0,0,t.Results.HitActor);
					Puff.Angle=Dir.X;
					Puff.AddZ(-8);
					If(t.Results.HitType == TRACE_HitWall) Puff.A_SprayDecal(DecalName,32);
					Puff.AddZ(8);
				}
			}
		}*/
		FTranslatedLineTarget t;
		Self.LineAttack(dir.x,range,dir.y,0,'normal',"BlankPuff",LAF_NORANDOMPUFFZ,t,origin.z,origin.x,origin.y);
		actor shield;
		bool saveshield=false;
		if(t.linetarget && t.linetarget is "BrainShield" && t.linetarget.master==self)
		{
			shield=t.linetarget;
			saveshield=shield.bShootable;
			shield.bShootable=false;
		}
		t.linetarget=null;
		vector3 oldspeed;
		actor hit=Self.LineAttack(dir.x,range,dir.y,0,'normal',"BlankPuff",LAF_NORANDOMPUFFZ,t,origin.z,origin.x,origin.y);
		If(t.linetarget) oldspeed=t.linetarget.vel;
		Puff=Self.LineAttack(dir.x,range,dir.y,Damage,'normal',PuffType,LAF_NORANDOMPUFFZ,null,origin.z,origin.x,origin.y);
		
		If(shield)
		shield.bShootable=saveshield;
		If(t.linetarget)
		{
			vector2 dir=Q2StuffLib.FaceVector(hit.pos,self.pos+origin+(0,0,self.height/2));
			vector3 veldiff=t.linetarget.vel-oldspeed;
			//t.linetarget.vel+=Q2StuffLib.Vec3ToDir(veldiff.length(),dir.x,dir.y);
			t.linetarget.vel.z+=veldiff.length()*sin(-dir.y)*2;
		}
		Return Puff;
	}
	States
	{
	Select:
		TNT1 A 0 A_WeaponReady(WRF_BOBONLY);
		TNT1 A 0 A_Jump(256,"Raise");
	Deselect:
	Raise:
	Ready:
	Fire:
		TNT1 A 0 A_TakeInventory("Q2Weapon");
		Stop;
	InstantDeselect:
		TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_Lower;
		TNT1 A 1 A_Lower;
		Wait;
	}
}
Class WeaponIndex : InvBoolean { Default { Inventory.MaxAmount 20; } }
Class WeaponFlash : EffectBase
{
	States
	{
	Spawn:
		TNT1 A 2;
		Stop;
	}
}
Class FistReplacer Replaces Fist {}
Class Q2Blaster : Q2Weapon Replaces Pistol
{
	Default {
	Weapon.SelectionOrder 900;
	+INVENTORY.UNTOSSABLE
	Tag "Blaster";
	Q2Weapon.SkinID "A";
	Weapon.SlotNumber 1;
	Inventory.PickupMessage "Blaster";
	Inventory.Icon "W_BLSTR";
	DropItem ""; }
	States
	{
	Spawn:
		PSTL A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",1);
		BLS1 AB 5;
		BLS1 CDE 4;
		Goto Ready+1;
	Ready:
		TNT1 A 0;
		BLS2 AAA 6 A_WeaponReady;
		TNT1 A 0 A_Jump(64,1);
		Loop;
		BLS2 ABCDEFGHIJKL 6 A_WeaponReady;
		BLS2 LLL 6 A_WeaponReady;
		TNT1 A 0 A_Jump(64,1);
		Goto Ready+17;
		BLS2 MNOPQRSTUV 6 A_WeaponReady;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		BLS2 A 3;
		BLS1 JKL 4;
		Goto InstantDeselect;
	Fire:
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/BlasterFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/BlasterFire",CHAN_WEAPON,0.5,0,3);
		TNT1 A 0 A_FireProjectile("BlasterProjectile",0,0,8,4);
		TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		TNT1 A 0 A_GunFlash;
		BLS1 FGHI 4;
		BLS2 A 2;
		Goto Ready;
	Flash:
		TNT1 A 0 A_Light2;
		TNT1 A 0 A_SetPitch(Pitch-3.0,SPF_INTERPOLATE);
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.2,SPF_INTERPOLATE);
		TNT1 A 0 A_Light1;
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.2,SPF_INTERPOLATE);
		TNT1 A 0 A_Light0;
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.2,SPF_INTERPOLATE);
		Stop;
	}
}
Class BlasterProjectile : FastProjectile
{
	Default {
	Radius 3;
	Height 6;
	Speed 32;
	Damage 5;
	MissileHeight 8;
	MissileType "BlasterTrailSpawner";
	DeathSound "Weapons/LaserHit";
	+BLOODSPLATTER
	Decal "BlasterScorch"; }
	Override Void Effect()
	{
		special1++;
		If(special1%2==0) super.effect();
	}
	States
	{
	Spawn:
		NULL A 1 Light("BlasterProjectile") Bright A_PlaySound("Weapons/LaserFly",CHAN_VOICE,0.5,1);
		Loop;
	Death:
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
Class BlasterProjectileImpact : EffectBase
{
	Default {
	Height 6;
	+BRIGHT
	RenderStyle "Normal";
	//Translation "80:111=208:223";
	Translation "80:111=[255,255,0]:[255,64,0]";
	}
	States
	{
	Spawn:
		TNT1 AAAAAAAAAAAAAAAAAA 0
		{
			A_SpawnItemEx("BlasterImpactParticle",0,0,0,FRandom(0,1),0,FRandom(-0.25,3),Random(1,360),1);
			/*Double f=FRandom(0.5,2);
			Color Col=Color(256,256,int(128*f),0);
			A_SpawnParticle(Col,SPF_FULLBRIGHT|SPF_RELVEL,15,4,FRandom(0,360),0,0,0,FRandom(0,1),0,FRandom(-0.25,3));*/
		}
		TNT1 A 0 A_CheckFloor("Floor");
		TNT1 A 0 A_CheckCeiling(1);
		Goto Air;
		TNT1 A 0 A_SetScale(-1);
	Floor:
		NULL ABC 3;
		NULL D 1 A_FadeOut(0.25);
		Wait;
	Air:
		NULL EFG 3;
		NULL H 1 A_FadeOut(0.25);
		Wait;
	}
}
Class BlasterTrailSpawner : EffectBase
{
	Default { Scale 0.8; }
	States
	{
	Spawn:
		TNT1 AA 0 A_SpawnItemEx("BlasterTrail",FRandom(0,2),0,FRandom(-2,2),FRandom(0,0.15),0,FRandom(-0.15,0.15),Random(1,360),128|SXF_TRANSFERSCALE);
		/*TNT1 AA 0
		{
			Double f=FRandom(0.5,2);
			Color Col=Color(256,int(256*f),int(128*f),0);
			A_SpawnParticle(Col,SPF_FULLBRIGHT,15,4,FRandom(0,360),FRandom(0,2),0,FRandom(-2,2),FRandom(0,0.15),0,FRandom(-0.15,0.15));
		}*/
		Stop;
	}
}
Class BlasterTrail : Q2BulletPuffParticle { Default { /*Translation "80:111=208:223";*/ Translation "80:111=[255,181,26]:[219,104,0]"; Scale 0.8; } }
Class BlasterImpactParticle : BlasterTrail
{
	Default {
	Projectile;
	-NOINTERACTION -NOGRAVITY
	Gravity 0.125; }
	States
	{
	Fade:
		"----" A 10;
		"----" A 1 A_FadeOut;
		Wait;
	}
}
class trasero : LineTracer
{/*
   Actor Source;
   override ETraceStatus TraceCallback()
   {
      if (Results.HitType == TRACE_HitActor)
      {
         // Ignore source
         if (Results.HitActor == Source || Results.HitActor Is "BrainShield" && Results.HitActor.master==Source)
         {
            return TRACE_Skip;
         }
         return TRACE_Stop;
      }
      return TRACE_Stop;
   }*/
   
	Actor ignore;

	override ETraceStatus TraceCallback()
	{
		if ( Results.HitType == TRACE_HitActor )
		{
			if ( Results.HitActor == ignore ) return TRACE_Skip;
			if( Results.HitActor Is "BrainShield" && Results.HitActor.master==ignore) return TRACE_skip;
			if ( Results.HitActor.bSHOOTABLE ) return TRACE_Stop;
			return TRACE_Skip;
		}
		else if ( (Results.HitType == TRACE_HitWall) && (Results.Tier == TIER_Middle) )
		{
			if ( !Results.HitLine.sidedef[1] || (Results.HitLine.Flags&Line.ML_BlockHitscan) )
				return TRACE_Stop;
			return TRACE_Skip;
		}
		return TRACE_Stop;
	}
}
Class Q2Shotgun : Q2Weapon Replaces Shotgun
{
	Default {
	Tag "Shotgun";
	Inventory.PickupMessage "$GOTSHOTGUN";
	Q2Weapon.SkinID "B";
	Weapon.SelectionOrder 300;
	Weapon.AmmoType "Q2Shell";
	Weapon.AmmoUse 1;
	Weapon.SlotNumber 2;
	Weapon.AmmoGive 4;
	Inventory.Icon "W_SHTGN"; }
	
	Action Void A_ShotgunFire()
	{
		Invoker.DepleteAmmo(Invoker.bAltFire,false);
		int damage=5;/*
		//A_FireBullets(6,3,10,4);
		Vector3 Origin=Veto3Rotato(5,-5,-5,Angle,Pitch);
		Origin+=(Pos.XY,Player.ViewZ);
		for(int i=0;i<10;i++)
		FireTrasero(Self,Origin,(Angle+FRandom(-6,6),Pitch+FRandom(-3,3)/2),damage*random(1,8),DecalName:"BulletChip");*/
		for(int i=0;i<10;i++)
		FireTrasero(Self,(0,5,-2.5),(Angle+FRandom(-6,6),Pitch+FRandom(-3,3)/2),damage*random[GunShot](1, 3));
		
	}
	States
	{
	Spawn:
		TNT1 A 0;
		W002 D -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",2);
		W001 A 4;
		W001 B 3;
		W001 C 4;
		W001 D 3;
		W001 E 4;
		W001 F 3;
		W001 G 4;
		W001 HT 4 A_WeaponReady;
		Goto Ready;
	Ready:
		TNT1 A 0 A_Jump(32,2);
		W001 T 5 A_WeaponReady;
		Loop;
		W001 TUVW 15 A_WeaponReady;
		W001 XXX 5 A_WeaponReady;
		TNT1 A 0 A_Jump(32,1);
		Goto Ready+6;
		W001 "YZ[" 15 A_WeaponReady;
		W001 "^^^" 5 A_WeaponReady;
		TNT1 A 0 A_Jump(32,1);
		Goto Ready+14;
		W001 "]T" 15 A_WeaponReady;
		Loop;
	Deselect:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		W001 T 2;
		W002 ABC 4;
		Goto InstantDeselect;
	Fire:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"DFire");
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/ShotgunFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/ShotgunFire",CHAN_WEAPON,0.5,0,3);
		TNT1 A 0 A_ShotgunFire();
		//TNT1 A 0 a_refire;
		//TNT1 A 0 A_FireBullets(6,3,10,4);
		//TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		TNT1 A 0 A_GunFlash;
		W001 IJ 3;
		W001 K 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/ShotgunPump",0);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/ShotgunPump",0,0.5);
		W001 KLMN 4;
		W001 OPQRST 3;
		W001 T 3;
		Goto Ready;
	DFire:
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/ShotgunFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/ShotgunFire",CHAN_WEAPON,0.5,0,3);
		TNT1 A 0 A_FireBullets(6,3,7,5);
		TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		TNT1 A 0 A_GunFlash;
		W001 IJK 3;
		W001 L 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/ShotgunPump",0);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/ShotgunPump",0,0.5);
		W001 LMN 4;
		W001 OPQRST 3;
		W001 T 0;
		Goto Ready;
	Flash:
		TNT1 A 1 A_Light2;
		TNT1 A 0 A_SetPitch(Pitch-3.0,SPF_INTERPOLATE);
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.3,SPF_INTERPOLATE);
		TNT1 A 0 A_Light1;
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.3,SPF_INTERPOLATE);
		Goto LightDone;

	}
}
Class Q2SuperShotgun : Q2Weapon Replaces SuperShotgun
{
	Default {
	Tag "Super Shotgun";
	Inventory.PickupMessage "Super Shotgun";
	Obituary "%o was too close to %k's super shotgun.";
	Q2Weapon.SkinID "C";
	Weapon.SelectionOrder 200;
	Weapon.AmmoType "Q2Shell";
	Weapon.AmmoUse 2;
	Weapon.SlotNumber 3;
	Weapon.AmmoGive 6;
	Inventory.Icon "W_SSG"; }
	Action Void A_FireSSG()
	{
		Invoker.DepleteAmmo(Invoker.bAltFire,false);
		int damage=4;
		// A_FireBullets(18,10,20,4);
		for(int i=0;i<20;i++)
		FireTrasero(Self,(0,5,0),(Angle+FRandom(-18,18),Pitch+FRandom(-10,10)/2),damage*random[GunShot](1, 3));
		
	}
	States
	{
	Spawn:
		SGN2 A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",3);
		SSG0 ABCDEFG 4;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		SSG1 A 2;
		SSG0 STUV 3;
		Goto InstantDeselect;
	Ready:
		TNT1 A 0 A_Jump(6,2);
		SSG1 A 1 A_WeaponReady;
		Loop;
		SSG1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[^]" 5 A_WeaponReady;
		SSG2 ABCDEFGHIJK 5 A_WeaponReady;
		Goto Ready+1;
	Fire:
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/SuperShotgunFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/SuperShotgunFire",CHAN_WEAPON,0.5,0,3);
		TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"DFire");
		TNT1 A 0 A_FireSSG;
		TNT1 A 0 A_GunFlash;
		SSG0 H 4;
		SSG0 I 3;
		SSG0 J 4;
		SSG0 K 3;
		SSG0 L 4;
		SSG0 M 3;
		SSG0 N 4;
		SSG0 O 3;
		SSG0 P 4;
		SSG0 Q 3;
		SSG0 R 4;
		Goto Ready+1;
	DFire:
		TNT1 A 0 A_FireBullets(10,10,21,5);
		TNT1 A 0 A_GunFlash;
		SSG0 HIJ 3;
		SSG0 KLMNOPQR 4;
		SSG1 A 8;
		Goto Ready+1;
	Flash:
		TNT1 A 1 A_Light2;
		TNT1 A 0 A_SetPitch(Pitch-5.0,SPF_INTERPOLATE);
		TNT1 AAAAAAAAAA 1 A_SetPitch(Pitch+0.25,SPF_INTERPOLATE);
		TNT1 A 0 A_Light1;
		TNT1 AAAAAAAAAA 1 A_SetPitch(Pitch+0.25,SPF_INTERPOLATE);
		Goto LightDone;
	}
}

Class Q2Machinegun : Q2Weapon
{
	Default {
	Tag "Machinegun";
	Inventory.PickupMessage "Machinegun";
	Obituary "%o embraced %k's trusty Machinegun.";
	Q2Weapon.SkinID "D";
	Weapon.SelectionOrder 100;
	Weapon.AmmoType "Q2Bullets";
	Weapon.AmmoUse 1;
	Weapon.SlotNumber 4;
	Weapon.AmmoGive 20;
	Inventory.Icon "W_MCHNGN"; }
	States
	{
	Spawn:
		MGUN A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",4);
		MGN0 ABCD 5;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		MGN0 H 3;
		MGN1 STUV 3;
		Goto InstantDeselect;
	Ready:
		TNT1 A 0 A_Jump(6,2);
		MGN0 H 1 A_WeaponReady;
		Loop;
		MGN0 "IJKLMNOPQRSTUVWXYZ[^]" 5 A_WeaponReady;
		MGN1 ABCDEFGHIJKLMNOPQR 5 A_WeaponReady;
		Goto Ready+1;
	Fire:
		MGN0 F 4 A_GunFlash;
		MGN0 E 3 A_GunFlash;
		MGN0 F 0 A_JumpIfInventory("Q2Bullets",1,3);
		TNT1 A 0 A_PlaySound("Weapons/NoAmmo",CHAN_WEAPON);
		TNT1 A 0 A_CheckReload;
		MGN0 F 0 A_ReFire;
		TNT1 A 0 A_GunFlash("ClimbDown",GFF_NOEXTCHANGE);
		Goto Ready;
	Flash:
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/MachineGunFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/MachineGunFire",CHAN_WEAPON,0.5,0,3);
		TNT1 A 0 A_FireBullets(5,2,1,5);
		TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		TNT1 A 0 A_JumpIfInventory("MachinegunClimbToken",0,"Null");
		TNT1 A 0 A_GiveInventory("MachinegunClimbToken",1);
		TNT1 AAA 1 A_SetPitch(Pitch-0.33,SPF_INTERPOLATE);
		Stop;
	ClimbDown:
		TNT1 A 0 A_JumpIfInventory("MachinegunClimbToken",1,1);
		Stop;
		TNT1 A 0 A_TakeInventory("MachinegunClimbToken",2);
		TNT1 A 1 A_SetPitch(Pitch+1.98,SPF_INTERPOLATE);
		Loop;
	}
}
Class MachinegunClimbToken : InvBoolean { Default { Inventory.MaxAmount 10; } }

Class Q2Chaingun : Q2Weapon
{
	Default {
	Tag "Chaingun";
	Inventory.PickupMessage "Chaingun";
	Obituary "%o became a meat bag full of holes by %k";
	Q2Weapon.SkinID "E";
	Weapon.AmmoType "Q2Bullets";
	Weapon.SelectionOrder 150;
	Weapon.AmmoUse 1;
	Weapon.SlotNumber 5;
	Weapon.AmmoGive 20;
	Inventory.Icon "W_CHGN"; }
	Action Void A_ChaingunFire()
	{
		If(FindInventory("PowerSilencer"))
		{
			A_AlertMonsters();
			A_PlaySound("Weapons/MachineGunFire",CHAN_WEAPON|CHAN_OVERLAP);
		}
		Else
		A_PlaySound("Weapons/MachineGunFire",CHAN_WEAPON|CHAN_OVERLAP,0.5,0,3);
		If(CountInv(Invoker.AmmoType1)>=Invoker.AmmoUse1)
		{
			A_FireBullets(5,2,-1,6);
			A_FireProjectile("WeaponFlash",0,0);
			Double Reco;
			Switch(Invoker.special2)
			{
				Case 0: Reco=0.5; Break;
				Case 1: Reco=0.33; Break;
				Case 2: Reco=0.25; Break;
			}
			A_SetAngle(Angle+FRandom(-Reco,Reco),SPF_INTERPOLATE);
			A_SetPitch(Pitch+FRandom(-Reco,Reco),SPF_INTERPOLATE);
		}
		Else
		{
			A_StopSound(CHAN_WEAPON);
			A_PlaySound("Weapons/NoAmmo",CHAN_WEAPON);
		}
	}
	States
	{
	Spawn:
		MGUN A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",5);
		CHG0 ABCDE 4;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_Overlay(2,"Null");
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		TNT1 A 0 A_StopSound(CHAN_5);
		CHG0 FGHI 4;
		Goto InstantDeselect;
	Ready:
		TNT1 A 0 A_Jump(6,2);
		CHG0 F 1 A_WeaponReady;
		Loop;
		CHG2 "ABCDEFGHIJKLMNOPQRSTUVWXYZ^[]" 5 A_WeaponReady;
		Goto Ready+1;
	Fire:
		TNT1 A 0
		{
			Invoker.special2=0;
			A_PlaySound("Weapons/ChaingunSpinUp",CHAN_5);
		}
		CHG1 A 4 A_ChaingunFire;
		CHG1 B 3 A_ChaingunFire;
		CHG1 C 4 A_ChaingunFire;
		CHG1 D 3 A_ChaingunFire;
		CHG1 E 4 A_ChaingunFire;
		CHG1 F 3 A_ChaingunFire;
		CHG1 G 4 A_ChaingunFire;
		CHG1 H 0 A_ReFire(1);
		Goto Ready+1;
		TNT1 A 0 { Invoker.special2=1; A_Overlay(2,"FireOverlay"); }
		CHG1 H 3;
		CHG1 I 4;
		CHG1 J 0 A_PlaySound("Weapons/ChaingunSpinning",CHAN_5,1,1);
		CHG1 JKLM 3;
		CHG1 N 0 { Invoker.special2=2; A_Overlay(2,"FireOverlay2"); }
		CHG1 NOPQ 2;
	Hold:
		CHG1 "RSTUVWXYZ^" 2;
		CHG1 R 0 A_JumpIfInventory("Q2Bullets",1,2);
		TNT1 A 0 A_PlaySound("Weapons/NoAmmo",CHAN_WEAPON);
		Goto SpinDown;
		TNT1 A 0 A_ReFire;
	SpinDown:
		TNT1 A 0 A_Overlay(2,"Null");
		TNT1 A 0 A_PlaySound("Weapons/ChaingunSpinDown",CHAN_5,0.75);
		CHG1 ABCDEFGHIJ 4 A_WeaponReady;
		CHG0 F 0 A_CheckReload;
		Goto Ready;
	Flash:
		TNT1 A 1;
		Stop;
	FireOverlay:
		TNT1 A 1 A_ChaingunFire;
		TNT1 A 2 A_ChaingunFire;
		TNT1 A 1 A_ChaingunFire;
		TNT1 A 3 A_ChaingunFire;
		Loop;
	FireOverlay2:
		TNT1 A 2 A_ChaingunFire;
		TNT1 AAAAA 1 A_ChaingunFire;
		Loop;
	}
}
Class Q2HandGrenade : Q2Weapon
{
	Default {
	Tag "Hand Grenade";
	Weapon.SelectionOrder 850;
	Obituary "%k's grenade was too precise and killed %o";
	+WEAPON.AMMO_OPTIONAL
	+WEAPON.NOAUTOAIM
	Q2Weapon.SkinID "K";
	Weapon.SlotPriority 1;
	Weapon.SlotNumber 1;
	Weapon.AmmoUse 1;
	Weapon.AmmoType "Q2GrenadeAmmo";
	Inventory.Icon "W_HGREN"; }
	States
	{
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",11);
		GRN1 EF 5;
		GRN0 A 5;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		GRN0 A 5;
		GRN1 FE 5;
		Goto InstantDeselect;
	Ready:
		TNT1 A 0 A_Jump(32,2);
		GRN0 A 1 A_WeaponReady;
		Loop;
		GRN0 "BCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 5 A_WeaponReady;
		GRN1 ABCD 5 A_WeaponReady;
		Goto Ready+1;
	Fire:
		GRN1 F 4;
		GRN1 G 4 A_PlaySound("Weapons/HGrenadeActivate",CHAN_WEAPON);
		GRN1 HIJK 4;
		GRN1 L 0 { Invoker.Tracer=A_FireProjectile("Q2HGrenade",0,1); If(Invoker.Tracer) Invoker.Tracer.Master=Invoker; }
		GRN1 LMN 3;
	Hold:
		GRN1 O 3;
		GRN1 P 0 A_JumpIf(!Invoker.Tracer,2);
		GRN1 P 0 A_ReFire;
		Goto Throw;
		GRN1 P 20 A_ClearReFire;
		Goto Ready+1;
	Throw:
		GRN1 P 3 ACS_NamedExecuteAlways("Q2TauntScript",0,3);
		GRN1 Q 4
		{
			A_PlaySound("Weapons/HGrenadeThrow",CHAN_WEAPON);
			If(Invoker.Tracer)
			{
				Invoker.Tracer.bNoClip=False;
				Invoker.Tracer.Vel3DFromAngle(Invoker.Tracer.Speed,Angle,Pitch-8);
				Invoker.Tracer.SetStateLabel("Idle");
				Invoker.Tracer.Angle+180;
			}
		}
		GRN1 RS 4;
		GRN0 A 0;
		TNT1 A 0 A_JumpIfInventory("Q2GrenadeAmmo",1,"Ready");
		TNT1 A 0 A_TakeInventory("Q2HandGrenade");
		Goto Ready;
	}
}
Class Q2HGrenade : Actor
{
	Default {
	Projectile;
	-NOGRAVITY +FORCERADIUSDMG +MOVEWITHSECTOR +NOCLIP
	+INTERPOLATEANGLES
	Obituary "%k's grenade was too precise and killed %o";
	Speed 16;
	Gravity 0.66;
	Damage 25;
	Radius 5;
	Height 10;
	BounceType "Doom";
	BounceSound "Weapons/HGrenadeBounce"; }
	Override Void Tick()
	{
		Super.Tick();
		//If(level.frozen || globalfreeze) Return;
		special1++;
		If(special1==120)
		SetStateLabel("XDeath");
		if(bNoClip) A_Warp(AAPTR_TARGET,-8,-8,42,180,WARPF_NOCHECKPOSITION);
	}
	Override Void PostBeginPlay()
	{
		Super.PostBeginPlay();
		specialf1=FRandom(1,6)*RandomPick(-1,1);
	}
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_PlaySound("Weapons/HGrenadeCount",CHAN_BODY,0.75,3);
	Hide:
		TNT1 A -1;
		Loop;
	Idle:
		TNT1 AAA 0 A_SpawnItemEx("Q2GrenadeSmoke",Random2(5),0,Random2(5),0,0,FRandom(0.1,0.5),Random(1,360),0,128);
		TNT1 A 0 A_SetAngle(Angle+specialf1);
		SGRN A 1 A_SetPitch(Pitch-15);
		Loop;
	Death:
		TNT1 A 0 A_PlaySound("Weapons/HGrenadeBounce",CHAN_VOICE);
		SGRN A 1 A_SpawnItemEx("Q2GrenadeSmoke",Random2(5),0,Random2(5),0,0,FRandom(0.1,1),Random(1,360),0,128);
		Wait;
	XDeath:
		TNT1 A 0 A_PlaySound("Weapons/GrenadeExplosion");
		TNT1 A 0 A_SpawnItem("Q2Explosion");
		TNT1 A 1 A_Explode;
		Stop;
	}
}
Class Q2GrenadeLauncher : Q2Weapon
{
	Default {
	Tag "Grenade Launcher";
	Inventory.PickupMessage "Grenade Launcher";
	Q2Weapon.SkinID "F";
	Weapon.SelectionOrder 500;
	Weapon.AmmoGive 5;
	Weapon.AmmoType "Q2GrenadeAmmo";
	Weapon.AmmoUse 1;
	Weapon.SlotNumber 6;
	Inventory.Icon "W_GLNCHR";
	+WEAPON.NOAUTOAIM }
	States
	{
	Spawn:
		RLAU A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",6);
		GRL0 ABCDEF 4;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		GRL1 A 2;
		GRL0 STUVW 3;
		Goto InstantDeselect;
	Ready:
		TNT1 A 0 A_Jump(32,2);
		GRL1 A 1 A_WeaponReady;
		Loop;
		GRL1 "BCDEFGHIJKLMNOPQRSTUVWXYZ[^]" 5 A_WeaponReady;
		GRL2 ABCDEFGHIJKLMN 5 A_WeaponReady;
		Goto Ready+1;
	Fire:
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/GrenadeLauncherFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/GrenadeLauncherFire",CHAN_WEAPON,0.5,0,3);
		TNT1 A 0 A_FireProjectile("Q2Grenade",0,1,9,0,0,-10);
		TNT1 A 0 A_GunFlash;
		GRL0 HI 3;
		GRL0 J 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/GrenadeLauncherReload",0);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/GrenadeLauncherReload",0,0.5,0,3);
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"DFire");
		GRL0 JKLMNOPQR 4;
		GRL1 A 2;
		Goto Ready;
	DFire:
		GRL0 JKLM 4;
		GRL0 NOPQR 4 A_WeaponReady;
		Goto Ready;
	Flash:
		TNT1 A 1 A_Light2;
		TNT1 A 0 A_SetPitch(Pitch-5.0,SPF_INTERPOLATE);
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.5,SPF_INTERPOLATE);
		TNT1 A 0 A_Light1;
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.5,SPF_INTERPOLATE);
		Goto LightDone;
	}
}
Class Q2Grenade : Actor
{
	Default {
	Projectile;
	-NOGRAVITY +FORCERADIUSDMG +MOVEWITHSECTOR
	Obituary "%o exploded in pieces thanks to %k's Grenade Launcher";
	Speed 25;
	Gravity 0.66;
	Damage 20;
	DamageType "Explosion";
	Radius 5;
	Height 10;
	BounceType "Doom";
	BounceSound "Weapons/GrenadeBounce";
	ReactionTime 120; //timer
	+INTERPOLATEANGLES }
	Override Void Tick()
	{
		Super.Tick();
		If(Level.Frozen || GlobalFreeze) Return;
		special1++;
		If(special1==reactiontime) SetStateLabel("XDeath");
	}
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_Jump(128,2);
		TNT1 A 0 { specialf1=FRandom(1,6)*RandomPick(-1,1); }
	Idle:
		TNT1 AAA 0 A_SpawnItemEx("Q2GrenadeSmoke",Random2(5),0,Random2(5),0,0,FRandom(0.1,0.5),Random(1,360),0,128);
		TNT1 A 0 A_SetAngle(Angle+specialf1);
		SGRN A 1 A_SetPitch(Pitch-15);
		Loop;
	Death:
		TNT1 A 0 A_PlaySound("Weapons/GrenadeBounce");
		SGRN A 1 A_SpawnItemEx("Q2GrenadeSmoke",Random2(5),0,Random2(5),0,0,FRandom(0.1,1),Random(1,360),0,128);
		Wait;
	XDeath:
		TNT1 A 0 A_PlaySound("Weapons/GrenadeExplosion");
		TNT1 A 5
		{
			A_Stop();
			bThruActors=True;
			A_Explode();
			A_SpawnItem("Q2Explosion");
			special1=reactiontime+1;
		}
		Stop;
	}
}
Class Q2GrenadeSmoke : Q2BulletPuffParticle
{
	Default { Scale 1; }
	States
	{
	Fade:
		"----" A 1 A_FadeOut(0.025);
		Wait;
	}
}

Class Q2RocketLauncher : Q2Weapon
{
	Default {
	Tag "Rocket Launcher";
	Inventory.PickupMessage "Rocket Launcher";
	Q2Weapon.SkinID "G";
	Weapon.SelectionOrder 500;
	Weapon.AmmoGive 5;
	Weapon.AmmoType "Q2Rockets";
	Weapon.AmmoUse 1;
	Weapon.SlotNumber 7;
	Inventory.Icon "W_RLNCHR"; }
	States
	{
	Spawn:
		RLAU A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",7);
		RCK0 ABCDE 4;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		RCK0 N 2;
		RCK1 WXYZ 3;
		Goto InstantDeselect;
	Ready:
		TNT1 A 0 A_Jump(32,2);
		RCK0 N 1 A_WeaponReady;
		Loop;
		RCK0 "OPQRSTUVWXYZ[^]" 5 A_WeaponReady;
		RCK1 ABCDEFGHIJKLMNOPQRSTUV 5 A_WeaponReady;
		Goto Ready+1;
	Fire:
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		RCK0 N 2 A_PlaySound("Weapons/RocketLauncherFire",CHAN_WEAPON);
		RCK0 F 0 A_Jump(256,2);
		RCK0 N 2 A_PlaySound("Weapons/RocketLauncherFire",CHAN_WEAPON,0.5,0,3);
		RCK0 F 0 A_FireProjectile("Q2Rocket",0,1,4,3);
		RCK0 F 3 A_GunFlash;
		RCK0 G 3;
		RCK0 H 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/RocketLauncherLoad",0);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/RocketLauncherLoad",0,0.5,0,3);
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"DFire");
		RCK0 HIJ 3;
		RCK0 KLM 5;
		RCK0 N 0;
		Goto Ready;
	DFire:
		RCK0 HIJK 3;
		RCK0 LM 5 A_WeaponReady;
		RCK0 N 0;
		Goto Ready;
	Flash:
		TNT1 A 0 A_SetPitch(Pitch-5.0,SPF_INTERPOLATE);
		TNT1 A 1 A_Light2;
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.5,SPF_INTERPOLATE);
		TNT1 A 0 A_Light1;
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.5,SPF_INTERPOLATE);
		Goto LightDone;
	}
}
Class Q2Rocket : Rocket Replaces Rocket
{
	Default {
	Speed 20;
	Damage 25;
	-ROCKETTRAIL +BRIGHT
	Obituary "%k catched %o with a Rocket";
	DamageType "Explosion";
	DeathSound "Weapons/RocketExplosion";
	Decal "Scorch"; }
	States
	{
	Spawn:
		MIS1 AAAAA 0 A_SpawnItemEx("Q2GrenadeSmoke",Random2(5),0,Random2(5),0,0,FRandom(0.1,0.5),Random(1,360),0,128);
		MIS1 A 0 A_SpawnItemEx("Q2RocketTrail",0,0,0,FRandom(0,0.5),0,FRandom(-0.5,0),Random(1,360),128);
		MIS1 A 1 Light("ROCKET") A_PlaySound("Weapons/RocketFly",CHAN_VOICE,0.66,1);
		Loop;
	Death:
		TNT1 A 0 A_Explode;
		TNT1 A 5 A_SpawnItem("Q2Explosion");
		Stop;
	}
}
Class Q2RocketTrail : Q2GrenadeSmoke { Default { Translation "80:111=160:167"; } }
Class Q2HyperBlaster : Q2Weapon
{
	Default {
	Tag "HyperBlaster";
	Inventory.PickupMessage "Hyper Blaster";
	Q2Weapon.SkinID "H";
	Weapon.SelectionOrder 50;
	Weapon.AmmoGive 20;
	Weapon.AmmoType "Q2Cell";
	Weapon.AmmoUse 1;
	Weapon.SlotNumber 8;
	Inventory.Icon "W_HYPERB"; }
	States
	{
	Spawn:
		PLAS A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",8);
		HYP0 ABCDEF 3;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		TNT1 A 0 A_StopSound(CHAN_5);
		HYP2 A 2;
		HYP0 GHIJ 3;
		Goto InstantDeselect;
	Ready:
		TNT1 A 0 A_Jump(32,2);
		HYP2 A 1 A_WeaponReady;
		Loop;
		HYP2 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[^]" 5 A_WeaponReady;
		Goto Ready+1;
	Fire:
		HYP1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterLoop",CHAN_5,0.75);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterLoop",CHAN_5,0.33,0,3);
		TNT1 A 0 A_ReFire(2); TNT1 A 0 A_Jump(256,3);
		TNT1 A 0 A_GunFlash;
		TNT1 A 0 A_FireProjectile("HyperBlasterProjectile",0,1,6,5);
		HYP1 A 4;
		HYP1 B 0 A_ReFire(2); TNT1 A 0 A_Jump(256,3);
		TNT1 A 0 A_GunFlash;
		TNT1 A 0 A_FireProjectile("HyperBlasterProjectile",0,1,6,2.5);
		HYP1 B 3;
		HYP1 C 0 A_ReFire(2); TNT1 A 0 A_Jump(256,3);
		TNT1 A 0 A_GunFlash;
		TNT1 A 0 A_FireProjectile("HyperBlasterProjectile",0,1,6,0);
		HYP1 C 4;
		HYP1 D 0 A_ReFire(2); TNT1 A 0 A_Jump(256,3);
		TNT1 A 0 A_GunFlash;
		TNT1 A 0 A_FireProjectile("HyperBlasterProjectile",0,1,6,-2.5);
		HYP1 D 3;
		HYP1 E 0 A_ReFire(2); TNT1 A 0 A_Jump(256,3);
		TNT1 A 0 A_GunFlash;
		TNT1 A 0 A_FireProjectile("HyperBlasterProjectile",0,1,6,0);
		HYP1 E 4;
		HYP1 F 0 A_ReFire(2); TNT1 A 0 A_Jump(256,3);
		TNT1 A 0 A_GunFlash;
		TNT1 A 0 A_FireProjectile("HyperBlasterProjectile",0,1,6,2.5);
		HYP1 F 3;
		HYP1 A 0 A_ReFire;
//		HYP1 ABCDEF 3 A_ReFire;
	FireStop:
		HYP1 G 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterStop",CHAN_5);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterStop",CHAN_5,0.5,0,3);
		HYP1 GHIJKLMNO 4;
		Goto Ready;
	Flash:
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,"Null");
		TNT1 A 0 A_PlaySound("Weapons/HyperBlasterFire",CHAN_WEAPON,0.5,0,3);
		Stop;
	}
}
Class HyperBlasterProjectile : BlasterProjectile
{
	Default {
	Speed 40;
	Damage 5;
	Obituary "%o was pulverized by %k's Hyper Blaster";
	MissileType ""; }
}
Class Q2Railgun : Q2Weapon
{
	Default {
	Tag "Railgun";
	Inventory.PickupMessage "Railgun";
	Obituary "%o was ashamed by %k's Railgun";
	Q2Weapon.SkinID "I";
	Weapon.SelectionOrder 300;
	Weapon.AmmoGive 5;
	Weapon.AmmoType "Q2Slugs";
	Weapon.AmmoUse 1;
	Weapon.SlotNumber 9;
	Decal "RailScorch";
	Inventory.Icon "W_RAILG"; }
	Action Void A_FireRailguna()
	{
		If(!Player) Return;
		If(CountInv(Invoker.AmmoType1)<Invoker.AmmoUse1)
		{
			A_PlaySound("Weapons/NoAmmo",CHAN_WEAPON);
			Return;
		}
		Double Range=PLAYERMISSILERANGE;
		double pitche=pitch; pitch=AimLineAttack(angle, Range);
		If(FindInventory("PowerSilencer"))
		{
			A_AlertMonsters();
			A_RailAttack(Random(100,200),5,1,"2F 67 7F","White",RGF_FULLBRIGHT,1.0,"Q2RailgunPuff");
		}
		Else
		{
			A_PlaySound("Weapons/RailGF",CHAN_WEAPON,0.5,0,3);
			A_RailAttack(Random(100,200),5,1,"2F 67 7F","White",RGF_FULLBRIGHT|RGF_SILENT,1.0,"Q2RailgunPuff");
		}
		Pitch=pitche;
		A_GunFlash();
	}
	States
	{
	Spawn:
		PLAS A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",9);
		TNT1 A 0 A_PlaySound("Weapons/RailGunLoop",CHAN_5,0.5,1);
		RLG0 ABCD 4;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_StopSound(CHAN_5);
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		RLG0 TUVWX 3;
		Goto InstantDeselect;
	Ready:
		TNT1 A 0 A_Jump(32,2);
		RLG1 A 1 A_WeaponReady;
		Loop;
		RLG1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[^]" 5 A_WeaponReady;
		RLG2 ABCDEFGHI 5 A_WeaponReady;
		Goto Ready+1;
	Fire:
		RLG0 E 3 A_FireRailguna;
		RLG0 FG 4;
		RLG0 H 4;// A_PlaySound("Weapons/RailGunCharge",0,0.75);
		RLG0 IJKLMNOPQRS 4;
		Goto Ready;
	Flash:
		TNT1 A 0 A_SetPitch(Pitch-5.0,SPF_INTERPOLATE);
		TNT1 A 1 A_Light2;
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.5,SPF_INTERPOLATE);
		TNT1 A 0 A_Light1;
		TNT1 AAAAA 1 A_SetPitch(Pitch+0.5,SPF_INTERPOLATE);
		Goto LightDone;
	}
}
Class Q2RailgunPuff : Q2BulletPuff { Default { DamageType "Railgun"; } }
//BFG10K, base decorate taken from AEoD4
//Brightmaps and zscript conversionby TheCamaleonMaligno

Class Q2BFG10K : Q2Weapon Replaces BFG9000
{
	Default {
	Tag "BFG10K";
	Inventory.PickupMessage "You got the BFG10K!";
	Q2Weapon.SkinID "J";
	Weapon.SelectionOrder 800;
	Weapon.AmmoType "Q2Cell";
	Weapon.AmmoGive 50;
	Weapon.AmmoUse 25;
	+WEAPON.BFG
	Obituary "%o was disintegrated by %k's BFG10K.";
	Weapon.SlotNumber 0;
	Inventory.Icon "W_BFG"; }
	States
	{
	Spawn:
		BFUG A -1;
		Stop;
	Raise:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",10);
		TNT1 A 0 A_PlaySound("Weapons/BFG10KLoop",CHAN_5,1,1);
		QBFG A 3;
		QBFG B 4;
		QBFG C 3;
		QBFG D 4;
		QBFG E 3;
		QBFG F 4;
		Goto Ready+1;
	Ready:
		TNT1 A 0;
		QBFG G 1 A_WeaponReady;
		QBFG G 0 A_Jump(10,1);
		Loop;
		QBF2 DEFGHIJKLMNOPQRSTUVWXYZ 4 A_WeaponReady;
		Goto Ready+1;
	Deselect:
		TNT1 A 0 A_StopSound(CHAN_5);
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"InstantDeselect");
		QBF3 ABCD 3;
		TNT1 A 5;
		Goto InstantDeselect;
	Fire:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,3);
		TNT1 A 0 A_JumpIfInventory("Q2Cell",50,2);
		QBFG G 20 A_PlaySound("Weapons/NoAmmo",CHAN_WEAPON);
		Goto Ready;
		TNT1 A 0 A_JumpIfInventory("PowerSilencer",1,4);
		TNT1 A 0 A_AlertMonsters;
		TNT1 A 0 A_PlaySound("Weapons/BFG10kFire",CHAN_WEAPON);
		TNT1 A 0 A_Jump(256,2);
		TNT1 A 0 A_PlaySound("Weapons/BFG10kFire",CHAN_WEAPON,0.5,0,3);
		QBFG HIJKLMNO 3;
		QBFG P 0 A_TakeInventory("Q2Cell",25,TIF_NOTAKEINFINITE);
		QBFG P 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",0)==True,"DFire");
		QBFG P 0 A_FireProjectile("BFG10KBall",0,1,10,8);
		QBFG P 0 A_GunFlash;
		QBFG PQQRSTUVWXYZ 3;
		QBF2 ABC 3;
		QBFG G 0 A_CheckReload;
		Goto Ready+1;
	DFire:
		QBFG P 0 A_FireProjectile("BFG10KBall2",0,0,10,8);
		QBFG P 0 A_GunFlash;
		QBFG PQQRSTUU 3;
		QBFG VWXYZ 3 A_ReFire;
		QBF2 ABC 3 A_ReFire;
		QBFG G 0 A_CheckReload;
		Goto Ready+1;
	Flash:
		TNT1 A 1 A_Light2;
		TNT1 A 1 A_SetPitch(Pitch-15,SPF_INTERPOLATE);
		TNT1 AAAA 2 A_SetPitch(Pitch+1.5,SPF_INTERPOLATE);
		TNT1 A 0 A_Light1;
		TNT1 AAAAAA 2 A_SetPitch(Pitch+1.5,SPF_INTERPOLATE);
		Goto LightDone;
	}
}
Class BFG10KBall : BFGBall Replaces BFGBall
{
	Property BeamDamage : special1;
	Default {
	DamageType "BFG";
	Damage 150;
	Speed 10;
	BFG10KBall.BeamDamage 15;
	Decal "BFGLightning";
	+FORCEXYBILLBOARD +NOBLOCKMONST;
	DeathSound "Weapons/BFG10KExplode"; }
	States
	{
	Spawn:
		TNT1 A 0 NoDelay SpawnParticles();
		TNT1 A 0 A_PlaySound("Weapons/BFG10KFly",1,0.66,1);
		BFS1 ABAB 4 Bright;
		TNT1 A 0 A_Jump(256,"Fly");
	Fly:
		BFS1 AAAABBBB 1 Bright;
		Loop;
	Death:
		BFE1 A 5 Bright A_StopSound(1);
		BFE1 B 5 Bright A_ExplodeParticles;
		BFE1 C 5 Bright
		{
			A_Explode(64,192);
			A_Explode(192,256,0);
			A_BFGSpray("BFGExtra",40,18);
			A_ExplodeParticles();
		}
		TNT1 A 0 A_GiveInventory("Clip",1);// this thing removes the orbiting particles
		BFE1 DEF 5 Bright;
		Stop;
	}
	Array<Actor> Targets;
	Array<Actor> Others;
	Override Void Tick()
	{
		Super.Tick();
		If(Level.Frozen || GlobalFreeze) Return;
		FireBeams();
		If(GetAge()%10==0)
		UpdateTargets();
	}
	Virtual Void UpdateTargets()
	{
		Targets.Clear();
		Others.Clear();
		BlockThingsIterator It=BlockThingsIterator.Create(Self,716);
		While(It.Next())
		{
			If(It.Thing && It.Thing.bShootable && CheckSight(It.Thing) && it.thing!=target && !it.thing.bNoDamage)
			{
				If(target && !it.thing.isFriend(target))
				Targets.Push(it.thing);
				Else
				Others.Push(it.thing);
			}
		}
	}

	Virtual Void FireBeams()
	{
		Int MaxTargets=5;
		Int TargCount;
		Int TS=Targets.Size();
		Int OS=Others.Size();
		Int Dmg;
		If(GetAge()%5==0)
		Dmg=special1;
		For(Int i=0;TS>0 && i<TS;i++)
		{
			If(Targets[i] && CheckSight(Targets[i]) && TargCount<MaxTargets)
			{
				TargCount++;
				BeamAttack(Targets[i],dmg);
			}
		}
		If(TargCount<MaxTargets)
		For(Int i=0;OS>0 && i<OS;i++)
		{
			If(Others[i] && CheckSight(Others[i]) && TargCount<MaxTargets)
			{
				TargCount++;
				BeamAttack(Others[i],dmg);
			}
		}
	}
	Virtual Void BeamAttack(Actor Targ, int dmg)
	{
		If(!Targ) Return;
		Vector2 Dir=Q2StuffLib.FaceVector(Targ.Pos+(0,0,Targ.Height/2),Pos);
		Actor Beam=SpawnMissileXYZ(Pos,Targ,"BFG10KBeam",1,Target);
		If(Beam)
		{
			Beam.SetDamage(Dmg);
			Beam.Vel3DFromAngle(Beam.Speed,Dir.X,Dir.Y);
		}
	}
	Virtual Void SpawnParticles()
	{
		For(int i=0;i<200;i++)
		{
			Actor P=Spawn("BFG10KOrbitParticle",pos,ALLOW_REPLACE);
			p.target=self;
		}
	}
	Void A_ExplodeParticles()
	{
		For(int i=0;i<200;i++)
		A_SpawnItemEx("BFG10KExplosionParticle",0,0,0,random(-4,4),random(-4,4),random(-4,4),random(1,360));
	}
}
Class BFG10KBall2 : BFG10KBall
{
	Default {
	Damage 100;
	Speed 25; }
	States
	{
	Death:
		BFE1 A 5 Bright A_StopSound(1);
		BFE1 B 5 Bright A_ExplodeParticles;
		BFE1 C 5 Bright A_BFGSpray;
		TNT1 A 0 A_GiveInventory("Clip",1);
		BFE1 DEF 5 Bright;
		Stop;
	}
}
Class BFG10KExplosionParticle : Q2ExplosionParticle
{
	Default {
	Translation "80:111=112:127";
	RenderStyle "Add";
	Scale 1.25; }
	States
	{
	Fade:
		"----" A 20 Bright;
		"----" A 5 Bright;
		"----" A 0 A_Jump(97,"Null");
		Goto Fade+1;
	}
}
Class BFG10KOrbitParticle : EffectBase
{
	Int UOrbit[4];
	Default {
	Radius 38;
	Translation "80:111=112:127";
	RenderStyle "Translucent";
	Scale 1.15; }
	States
	{
	Spawn:
		TNT1 A 0 NoDelay
		{
			UOrbit[0]=Random(20,Radius);
			UOrbit[3]=2;
			UOrbit[1]=FRandom(-UOrbit[3]*65536,UOrbit[3]*65536);
			UOrbit[2]=FRandom(-UOrbit[3]*65536,UOrbit[3]*65536);
			A_SetTranslucent((Radius-(UOrbit[0]-20))*0.1,1);
			A_SetAngle(Random(1,360));
			A_SetPitch(Random2(45));
		}
	Decide:
		P001 ABCDEFGH 0 A_Jump(64,"Idle");
		Loop;
	Idle:
		"----" A 0 A_SetPitch(Pitch+(UOrbit[1]*0.0000153));
		"----" A 1 Bright A_SetAngle(Angle+(UOrbit[2]*0.0000153));
		"----" A 0 A_JumpIfInventory("Clip",1,"Null",AAPTR_TARGET);
		"----" A 0 A_Warp(AAPTR_TARGET,Cos(Pitch)*UOrbit[0],Cos(Pitch)*UOrbit[0],Sin(Pitch)*UOrbit[0],0,WARPF_USECALLERANGLE|WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE,"Idle");
		Stop;
	}
}
Class BFG10KBeam : Actor
{
	Default
	{
		Projectile;
		Speed 16;
		Radius 5;
		Height 2.5;
		Damage 5;
		+NOTIMEFREEZE
		+NOTRIGGER
		+PAINLESS
		+BLOODLESSIMPACT
		+SKYEXPLODE
	}
	Vector3 Origin;
	Override Void PostBeginPlay()
	{
		Super.PostBeginPlay();
		Origin=Pos-(Vel/2);
	}
	Override Void Tick()
	{
		While(bMissile)
		{
			Super.Tick();
			If(special1>500) ExplodeMissile();
			special1++;
		}
		Super.Tick();
	}
	Array <Actor> UwUr;
	Override int SpecialMissileHit (Actor victim)
	{
		If(Victim.bShootable && Victim.bShootable && (Target && Victim!=Target))
		{
			Bool Recognized=false;
			Int Size=UwUr.Size();
			If(Size>0)
			For(int i=0;i<Size;i++)
			{
				If(UwUr[i]==Victim)
				{
					Recognized=True;
					Return 1;
				}
			}
			UwUr.Push(Victim);
			Int dmg=Damage;
			If(dmg>0) { bPainLess=False; A_SpawnItem("GreenPuffNoSnd"); }
			Int FinalDamage=Victim.DamageMobj(Self,Target,Damage,DamageType);
		}
		Return 1;
	}
	States
	{
	Death:
		TNT1 A 3
		{
			bMissile=0;
			If(Damage>0)
			A_SpawnItem("GreenPuffNoSnd");

			Actor Zap=Spawn("LightningBeamBase",Origin,ALLOW_REPLACE);
			Zap.A_SetRenderStyle(0.25,STYLE_ADDSHADED);
			Zap.SetShade("Green");
			Zap.Tracer=Self;
			Zap.Scale.X=2;
			Zap.ReactionTime=0;
		}
		Stop;
	}
}
Class Q1SNG : Q2Weapon
{
	Default {
	Tag "Super Nailgun";
	+WEAPON.CHEATNOTWEAPON
	Inventory.PickupMessage "Super Nailgun.";
	Obituary "%o was nailed by %k's Nailgun";
	Q2Weapon.SkinID "S";
	Weapon.SelectionOrder 200;
	Weapon.AmmoGive 50;
	Weapon.AmmoType "Q2Bullets";
	Weapon.AmmoUse 2;
	Weapon.SlotNumber 5;
	Inventory.Icon "W_NAIL2"; }
	States
	{
	Spawn:
		MGUN A -1;
		Stop;
	Select:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",19);
		SNG1 A 0 A_Raise;
		SNG1 A 1 A_Raise;
		Goto Select+2;
	Deselect:
		SNG1 A 0 A_Lower;
		SNG1 A 1 A_Lower;
		Loop;
	Ready:
		TNT1 A 0;
		SNG1 A 1 A_WeaponReady;
		Loop;
	Fire:
		SNG1 B 3 A_GunFlash;
		SNG1 C 0 A_ReFire(2); TNT1 A 0 A_Jump(256,"Ready");
		SNG1 C 4 A_GunFlash;
		SNG1 D 0 A_ReFire(2); TNT1 A 0 A_Jump(256,"Ready");
		SNG1 D 3 A_GunFlash;
		SNG1 E 0 A_ReFire(2); TNT1 A 0 A_Jump(256,"Ready");
		SNG1 E 4 A_GunFlash;
		SNG1 F 0 A_ReFire(2); TNT1 A 0 A_Jump(256,"Ready");
		SNG1 F 3 A_GunFlash;
		SNG1 G 0 A_ReFire(2); TNT1 A 0 A_Jump(256,"Ready");
		SNG1 G 4 A_GunFlash;
		SNG1 H 0 A_ReFire(2); TNT1 A 0 A_Jump(256,"Ready");
		SNG1 H 3 A_GunFlash;
		SNG1 I 0 A_ReFire(2); TNT1 A 0 A_Jump(256,"Ready");
		SNG1 I 4 A_GunFlash;
		SNG1 B 0;
		Goto Ready;
	Flash:
		TNT1 A 0 A_Light1;
		TNT1 A 0 A_FireProjectile("WeaponFlash",0,0);
		TNT1 A 0 A_FireProjectile("SNGNail");
		TNT1 A 0 A_PlaySound("Weapons/SNG",CHAN_WEAPON);
		TNT1 A 1 A_SetPitch(Pitch-0.66,SPF_INTERPOLATE);
		TNT1 AA 1 A_SetPitch(Pitch+0.33,SPF_INTERPOLATE);
		Goto LightDone;
	}
}
Class SNGNail : Actor
{
	Default {
	Projectile;
	Speed 35;
	Damage 4;
	Radius 3;
	Height 6;
	+BLOODSPLATTER
	Decal "BulletChip"; }
	States
	{
	Spawn:
		PUFF A -1;
		Stop;
	Crash:
	Death:
		TNT1 A 1 A_SpawnItem("BulletPuff");
		Stop;
	XDeath:
		TNT1 A 0;
		Stop;
	}
}
Class Q1LightningGun : Q2Weapon
{
	Default {
	Tag "Thunderbolt";
	+WEAPON.CHEATNOTWEAPON
	Weapon.SelectionOrder 150;
	Inventory.PickupMessage "Thunderbolt";
	Q2Weapon.SkinID "T";
	Weapon.SlotNumber 8;
	Weapon.AmmoType "Q2Cell";
	Weapon.AmmoGive 40;
	Weapon.AmmoUse 1;
	Inventory.Icon "W_LIGHT";
	Obituary "%o was electrocuted by %k's Thunderbolt."; }
	States
	{
	Spawn:
		PLAS A -1;
		Stop;
	Select:
		TNT1 A 0 A_TakeInventory("WeaponIndex");
		TNT1 A 0 A_GiveInventory("WeaponIndex",20);
		THND A 0 A_Raise;
		THND A 1 A_Raise;
		Goto Select+2;
	Deselect:
		THND A 0 A_Lower;
		THND A 1 A_Lower;
		Loop;
	Ready:
		TNT1 A 0;
		THND A 1 A_WeaponReady;
		Loop;
	Fire:
		THND A 0 A_PlaySound("Weapons/LightningStart",CHAN_WEAPON);
		TNT1 A 0 A_TakeInventory("Q2Cell",1,TIF_NOTAKEINFINITE);
		THND BC 3 A_GunFlash;
		TNT1 A 0 A_TakeInventory("Q2Cell",1,TIF_NOTAKEINFINITE);
		THND DE 3 A_GunFlash;
		TNT1 A 0 A_ReFire;
		goto Ready;
	Hold:
		TNT1 A 0 A_PlaySound("Weapons/Lightning",CHAN_5);
		TNT1 A 0 A_TakeInventory("Q2Cell",1,TIF_NOTAKEINFINITE);
		THND BC 3 A_GunFlash;
		THND D 0 A_TakeInventory("Q2Cell",1,TIF_NOTAKEINFINITE);
		THND DE 3 A_GunFlash;
		TNT1 A 0 A_ReFire(1);
		goto Ready;
		TNT1 A 0 A_TakeInventory("Q2Cell",1,TIF_NOTAKEINFINITE);
		THND BC 3 A_GunFlash;
		TNT1 A 0 A_TakeInventory("Q2Cell",1,TIF_NOTAKEINFINITE);
		THND DE 3 A_GunFlash;
		TNT1 A 0 A_ReFire;
		goto Ready;
	Flash:
		TNT1 A 0 A_Light2;
		TNT1 A 0 A_FireProjectile("ThunderBoltLightning",0,0,0,-7);
		TNT1 A 1 A_SetPitch(Pitch-0.5,SPF_INTERPOLATE);
		TNT1 A 1 A_SetPitch(Pitch+0.5,SPF_INTERPOLATE);
		TNT1 A 0 A_Light0;
		Stop;
	}
}
Class ThunderBoltLightning : FastProjectile
{
	Default {
	Speed 22;
	Damage 4;
	DamageType "Electric";
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
		TNT1 A 0 A_SpawnItemEx("ThunderBoltLightningTrail",0,0,0,(Vel.X*0.01), (Vel.Y*0.01), (Vel.Z*0.01), Angle, 128 | SXF_ABSOLUTEPOSITION | SXF_ABSOLUTEMOMENTUM | SXF_SETMASTER | SXF_ABSOLUTEANGLE);

		TNT1 A 0 A_Warp(AAPTR_DEFAULT,Vel.X/5,Vel.Y/5,Vel.Z/5,0,WARPF_ABSOLUTEOFFSET,1); Goto Death;
		TNT1 A 0 A_Warp(AAPTR_DEFAULT,Vel.X/5,Vel.Y/5,Vel.Z/5,0,WARPF_ABSOLUTEOFFSET,1); Goto Death;
		TNT1 A 0 A_Warp(AAPTR_DEFAULT,Vel.X/5,Vel.Y/5,Vel.Z/5,0,WARPF_ABSOLUTEOFFSET,1); Goto Death;
		TNT1 A 0 A_Warp(AAPTR_DEFAULT,Vel.X/5,Vel.Y/5,Vel.Z/5,0,WARPF_ABSOLUTEOFFSET,1); Goto Death;
		TNT1 A 0 A_Warp(AAPTR_DEFAULT,Vel.X/5,Vel.Y/5,Vel.Z/5,0,WARPF_ABSOLUTEOFFSET,"Moving");
		Stop;
	Death:
		TNT1 A 1 Light("PLASMA_X3") A_SetTranslucent(1,1);
		SPK1 C 2 Bright Light("PLASMA_X3") A_SetScale(FRandom(0.33,1));
		TNT1 A 3 Light("PLASMA_X3");
		TNT1 A 5 Light("PLASMA_X4");
		Stop;
	}
}
Class ThunderBoltLightningTrail : EffectBase
{
	Default {
	+NOTIMEFREEZE
	RenderStyle "Normal";
	Scale 0.5; }
	States
	{
	Spawn:
		PLSE BCDE 0 A_Jump(64,"Fade");
		Loop;
	Fade:
		"####" "#" 3 Bright { Roll=FRandom(1,360); }
		Stop;
	}
}