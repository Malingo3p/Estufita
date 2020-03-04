Class Q2Cell : Ammo
{
	Default {
	+INVENTORY.IGNORESKILL
	Inventory.PickupMessage "$GOTCELL";
	Inventory.Amount 25;
	Inventory.MaxAmount 200;
	Ammo.BackPackAmount 25;
	Ammo.BackPackMaxAmount 300;
	Inventory.Icon "A_CELLS"; }
	States
	{
	Spawn:
		CELL A -1;
		Stop;
	}
}
Class Q2CellPack : Q2Cell
{
	Default {
	Inventory.Amount 100;
	Translation "9:12=%[0,0,0]:[1,2.00,0]", "152:159=%[0,0,0]:[2,2,0]", "112:127=%[0,0,0]:[1,2,0]"; }
}
Class Q2Slugs : Ammo
{
	Default {
	+INVENTORY.IGNORESKILL
	Inventory.PickupMessage "Picked up Railgun Slugs.";
	Inventory.Amount 20;
	Inventory.MaxAmount 50;
	Ammo.BackPackAmount 10;
	Ammo.BackPackMaxAmount 100;
	Inventory.Icon "A_SLUGS"; }
	States
	{
	Spawn:
		CELL A -1;
		Stop;
	}
}
Class Q2SlugPickupSmall : Q2Slugs { Default { Inventory.Amount 10; } }
Class Q2Shell : Ammo Replaces ShellBox
{
	Default {
	+INVENTORY.IGNORESKILL
	Inventory.PickupMessage "$GOTSHELLBOX";
	Inventory.Amount 20;
	Inventory.MaxAmount 50;
	Ammo.BackPackAmount 10;
	Ammo.BackPackMaxAmount 100;
	Inventory.Icon "A_SHELL"; }
	States
	{
	Spawn:
		SBOX A -1;
		Stop;
	}
}
Class Q2ShellPickupSmall : Q2Shell Replaces Shell { Default { Inventory.Amount 5; } }
Class Q2Bullets : Ammo Replaces ClipBox
{
	Default {
	Inventory.PickupMessage "$GOTCLIPBOX";
	Inventory.Amount 50;
	Inventory.MaxAmount 200;
	Ammo.BackPackAmount 50;
	Ammo.BackPackMaxAmount 300;
	Inventory.Icon "A_BULL"; }
	States
	{
	Spawn:
		AMMO A -1;
		Stop;
	}
}
Class Q2BulletPickupSmall : Q2Bullets Replaces Clip { Default { Inventory.Amount 10; } }
Class Q2Rockets : Ammo
{
	Default {
	+INVENTORY.IGNORESKILL
	Inventory.PickupMessage "$GOTROCKBOX";
	Inventory.Amount 5;
	Inventory.MaxAmount 50;
	Ammo.BackPackAmount 5;
	Ammo.BackPackMaxAmount 100;
	Inventory.Icon "A_ROCKET"; }
	States
	{
	Spawn:
		BROK A -1;
		Stop;
	}
}
Class Q2GrenadeAmmo : Ammo
{
	Default {
	+INVENTORY.IGNORESKILL
	Inventory.Amount 5;
	Inventory.MaxAmount 50;
	Ammo.BackPackMaxAmount 100;
	Ammo.BackPackAmount 6;
	Inventory.Icon "A_GRNDS"; }
	States
	{
	Spawn:
		SGRN A -1;
		Stop;
	}
}
Class Q2GrenadeAmmoItem : CustomInventory
{
	Default {
	Inventory.PickupSound "misc/ammo_pkup";
	Inventory.PickupMessage	"Grenades"; }
	States
	{
	Spawn:
		SGRN A -1;
		Stop;
	Pickup:
		TNT1 A 0 A_JumpIfInventory("Q2GrenadeAmmo",0,2);
		TNT1 A 0 A_Jump(256,1);
		Fail;
		TNT1 A 0 A_GiveInventory("Q2HandGrenade");
		TNT1 A 0 A_GiveInventory("Q2GrenadeAmmo",5);
		Stop;
	}
}

Class PowerQuadDamage : PowerDamage
{
	Default {
	Powerup.Duration -30;
	DamageFactor "Normal", 4.0; }
	override void Tick()
	{
		Super.Tick();
		If(Owner && EffectTics>0)
		{
			If(EffectTics==BLINKTHRESHOLD)
			Owner.A_PlaySound("Powerup/QuadDamage/Empty",0,local:true);
			{
				If(!isBlinking())
				{
					Actor Light=Spawn("TempPointLight",Owner.Pos+(0,0,Owner.Height/2));
					Light.Args[1]=64;
					Light.Args[2]=255;
					Light.Args[3]=48;
					Light.Tics=1;
					Light.Target=Owner;
					Light.bNoTimeFreeze=True;
				}
			}
		}
	}
}
Class Q2QuadDamage : PowerupGiver Replaces Berserk
{
	Default {
	+INVENTORY.INVBAR
	Inventory.Amount 1;
	Inventory.MaxAmount 2;
	Inventory.InterHubAmount 2;
	Powerup.Color "Blue", 0.1;
	Powerup.Type "PowerQuadDamage";
	Inventory.Icon "P_QUAD";
	Inventory.PickupSound "Powerup/Pickup";
	Inventory.UseSound "Powerup/QuadDamage/Use";
	Inventory.PickupMessage "Quad Damage";
	Tag "Quad Damage"; }
	States
	{
	Spawn:
		PSTR A -1;
		Stop;
	}
}

Class PowerInvuln : PowerProtection
{
	//===========================================================================
	//
	// APowerInvisibility :: DoEffect
	//
	//===========================================================================

	override void Tick()
	{
		Super.Tick();
		If(Owner && EffectTics>0)
		{
			If(EffectTics==BLINKTHRESHOLD)
			Owner.A_PlaySound(PainSound,0,local:true);
			{
				If(!isBlinking())
				{
					Actor Light=Spawn("TempPointLight",Owner.Pos+(0,0,Owner.Height/2));
					Light.Args[0]=255;
					Light.Args[1]=128;
					Light.Args[3]=48;
					Light.Tics=1;
					Light.Target=Owner;
					Light.bNoTimeFreeze=True;
				}
			}
			ReactionTime--;
		}
	}
	Override Void AbsorbDamage(int damage, name damagetype, out int newdamage)
	{
		Double BAlpha=Clamp(damage*0.1,0.1,0.75);
		Owner.A_SetBlend(FillColor,BAlpha*0.5,Int(BAlpha*50));
		If(ReactionTime<1)
		{
			ReactionTime=50;
			Actor Snd=Spawn("SoundThingie");
			Snd.Tics=20;
			Snd.Target=Owner;
			Snd.A_PlaySound(AttackSound);
		}
		newdamage=0;
	}
	Default
	{
		ReactionTime 0;
		AttackSound "Powerup/Invulnerability/Active";
		PainSound "Powerup/Invulnerability/Empty";
		StencilColor "Orange";
	}
}
Class Q2Invulnerability : PowerupGiver Replaces InvulnerabilitySphere
{
	Default {
	+INVENTORY.INVBAR
	Inventory.Amount 1;
	Inventory.MaxAmount 2;
	Inventory.InterHubAmount 2;
	Powerup.Color "Yellow", 0.1;
	Powerup.Type "PowerInvuln";
	Inventory.Icon "P_INVUL";
	Inventory.PickupSound "Powerup/Pickup";
	Inventory.UseSound "Powerup/Invulnerability/Use";
	Inventory.PickupMessage "Invulnerability";
	Tag "Invulnerability"; }
	States
	{
	Spawn:
		PINV A -1;
		Stop;
	}
}
Class Q2Bandolier : CustomInventory
{
	Default {
	Height 26;
	Inventory.PickupMessage "Bandolier";
	Inventory.PickupSound "Powerup/Pickup"; }
	States
	{
	Spawn:
		BPAK A -1;
		Stop;
	Pickup:
		TNT1 A 0 ACS_NamedExecuteAlways("Q2Bandolier");
		TNT1 A 0 A_GiveInventory("Q2Shell",10);
		TNT1 A 0 A_GiveInventory("Q2Bullets",50);
		TNT1 A 0 A_GiveInventory("Q2GrenadeAmmo",1);
		Stop;
	}
}
Class BandolierToken : InvBoolean {}
Class Q2AmmoPack : CustomInventory
{
	Default {
	Height 26;
	Inventory.PickupMessage "Ammo Pack";
	Inventory.PickupSound "Powerup/Pickup"; }
	States
	{
	Spawn:
		BPAK A -1;
		Stop;
	Pickup:
		TNT1 A 0 A_GiveInventory("BackPack",1);
		Stop;
	}
}
Class Q2BodyArmor : BlueArmor Replaces BlueArmor
{
	Default {
	Inventory.PickupSound "misc/ar3_pkup";
	Inventory.Icon "I_BARM";
	Inventory.PickupMessage "Body Armor";
	Armor.SavePercent 66;
	Armor.SaveAmount 200;
	Scale 1.1; }
	States
	{
	Spawn:
		ARM2 B -1;
		Stop;
	}
}
Class Q2CombatArmor : BasicArmorPickup
{
	Default {
	Inventory.PickupSound "misc/ar_pkup";
	Inventory.Icon "I_CARM";
	Inventory.PickupMessage "Combat Armor";
	Armor.SavePercent 50;
	Armor.SaveAmount 100;
	Scale 1.1; }
	States
	{
	Spawn:
		ARM1 A -1;
		Stop;
	}
}
Class Q2JacketArmor : BasicArmorBonus
{
	Default {
	Inventory.PickupSound "misc/ar_pkup";
	Inventory.Icon "I_JARM";
	Inventory.PickupMessage "Jacket Armor";
	Armor.SavePercent 33.335;
	Armor.SaveAmount 25;
	Armor.MaxSaveAmount 200;
	Scale 1.1; }
	States
	{
	Spawn:
		ARM1 A -1;
		Stop;
	}
}
Class Q2ArmorShard : BasicArmorBonus Replaces ArmorBonus
{
	Default {
	+COUNTITEM +INVENTORY.ALWAYSPICKUP
	Inventory.PickupSound "misc/ar2_pkup";
	Inventory.Icon "I_JARM";
	Inventory.PickupMessage "Armor Shard";
	Armor.SavePercent 33.335;
	Armor.SaveAmount 2;
	Armor.MaxSaveAmount 200; }
	States
	{
	Spawn:
		BON2 A -1;
		Stop;
	}
}

Class Q2ArmorShardNoCount : Q2ArmorShard { Default { -COUNTITEM } }

Class Q2LargeHealth : Health Replaces Medikit
{
	Default {
	Inventory.Amount 25;
	//Inventory.MaxAmount 100;
	Inventory.PickupMessage "Health (+25)";
	Inventory.PickupSound "misc/l_health"; }
	States
	{
	Spawn:
		MEDI A -1;
		Stop;
	}
}
Class Q2MediumHealth : Health Replaces StimPack
{
	Default {
	Inventory.Amount 10;
	//Inventory.MaxAmount 110;
	Inventory.PickupMessage "Health (+10)";
	Inventory.PickupSound "misc/n_health";
	Scale 0.9; }
	States
	{
	Spawn:
		STIM A -1;
		Stop;
	}
}
Class Q2StimPack : Health Replaces HealthBonus
{
	Default {
	+COUNTITEM
	+INVENTORY.ALWAYSPICKUP
	Inventory.Amount 2;
	Inventory.MaxAmount 200;
	Inventory.PickupMessage "Health (+2)";
	Inventory.PickupSound "misc/s_health"; }
	States
	{
	Spawn:
		BON1 A -1;
		Stop;
	}
}
Class Q2Adrenaline : CustomInventory Replaces SoulSphere
{
	Default {
	Inventory.PickupMessage "Adrenaline";
	Inventory.PickupSound "Powerup/Pickup"; }
	States
	{
	Spawn:
		SOUL A -1;
		Stop;
	Pickup:
		TNT1 A 0 
		{
			Int Max=GetMaxHealth();
			A_GiveInventory("UpgradeStamina",1);
			If(Health<Max && !q2_addadrenhealth)
			A_SetHealth(Max);
			Else If(q2_addadrenhealth)
			A_GiveInventory("SoulSphere");
		}
		Stop;
	}
}
Class Q2MegaHealth : MegaSphere Replaces MegaSphere
{
	Default {
	Inventory.PickupMessage "Mega Health";
	Inventory.PickupSound "misc/m_health";
	Scale 1.25; }
	States
	{
	Spawn:
		MEGA A -1;
		Stop;
	Pickup:
		TNT1 A 0 A_GiveInventory("MegasphereHealth");
		TNT1 A 0 A_GiveInventory("Q2BodyArmor");
		Stop;
	}
}
Class Q2BlueKey : CustomInventory Replaces BlueCard
{
	Default {
	Inventory.PickupMessage "Blue Key";
	Inventory.PickupSound "misc/k_pkup";
	+NOTDMATCH
	+DONTGIB }
	States
	{
	Spawn:
		BKEY A 10;
		BKEY A 10 Bright;
		Loop;
	Pickup:
		TNT1 A 0 A_JumpIfInventory("BlueCard",1,"Nope");
		TNT1 A 0 A_GiveInventory("BlueCard");
		Stop;
	Nope:
		TNT1 A 0;
		Fail;
	}
}
Class Q2YellowKey : Q2BlueKey Replaces YellowCard
{
	Default { Inventory.PickupMessage "Yellow Key"; }
	States
	{
	Spawn:
		YKEY A 10;
		YKEY A 10 Bright;
		Loop;
	Pickup:
		TNT1 A 0 A_JumpIfInventory("YellowCard",1,"Nope");
		TNT1 A 0 A_GiveInventory("YellowCard");
		Stop;
	}
}
Class Q2RedKey : Q2BlueKey Replaces RedCard
{
	Default { Inventory.PickupMessage "Red Key"; }
	States
	{
	Spawn:
		RKEY A 10;
		RKEY A 10 Bright;
		Loop;
	Pickup:
		TNT1 A 0 A_JumpIfInventory("RedCard",1,"Nope");
		TNT1 A 0 A_GiveInventory("RedCard");
		Stop;
	}
}
Class Q2BlueSkull: Q2BlueKey Replaces BlueSkull
{
	Default { Inventory.PickupMessage "Blue Skull Key"; }
	States
	{
	Spawn:
		BSKU A 10;
		BSKU A 10 Bright;
		Loop;
	Pickup:
		TNT1 A 0 A_JumpIfInventory("BlueSkull",1,"Nope");
		TNT1 A 0 A_GiveInventory("BlueSkull");
		Stop;
	}
}
Class Q2YellowSkull: Q2BlueKey Replaces YellowSkull
{
	Default { Inventory.PickupMessage "Yellow Skull Key"; }
	States
	{
	Spawn:
		YSKU A 10;
		YSKU A 10 Bright;
		Loop;
	Pickup:
		TNT1 A 0 A_JumpIfInventory("YellowSkull",1,"Nope");
		TNT1 A 0 A_GiveInventory("YellowSkull");
		Stop;
	}
}
Class Q2RedSkull : Q2BlueKey Replaces RedSkull
{
	Default { Inventory.PickupMessage "Red Skull Key"; }
	States
	{
	Spawn:
		RSKU A 10;
		RSKU A 10 Bright;
		Loop;
	Pickup:
		TNT1 A 0 A_JumpIfInventory("RedSkull",1,"Nope");
		TNT1 A 0 A_GiveInventory("RedSkull");
		Stop;
	}
}
Class PowerSilencer : Powerup { Default { Powerup.Duration -60 ; } }
Class Q2Silencer : PowerupGiver Replaces BlurSphere
{
	Default {
	+INVENTORY.INVBAR
	Inventory.Amount 1;
	Inventory.MaxAmount 2;
	Inventory.InterHubAmount 2;
	Powerup.Type "PowerSilencer";
	Inventory.Icon "P_SLNCR";
	Inventory.PickupSound "Powerup/Pickup";
	Inventory.PickupMessage "Silencer";
	Tag "Silencer"; }
	States
	{
	Spawn:
		PINS A -1;
		Stop;
	}
}
Class Q2EnvironmentSuit : PowerupGiver Replaces RadSuit
{
	Default {
	+INVENTORY.INVBAR
	Inventory.Amount 1;
	Inventory.MaxAmount 2;
	Inventory.InterHubAmount 2;
	Powerup.Color "Green", 0.1;
	Powerup.Type "PowerIronFeet";
	Inventory.Icon "P_SUIT";
	Inventory.PickupSound "Powerup/Pickup";
	Inventory.PickupMessage "Environment Suit";
	Tag "Environment Suit"; }
	States
	{
	Spawn:
		SUIT A -1;
		Stop;
	}
}
Class Q2PowerShield : CustomInventory
{
	Default {
	Tag "Power Shield";
	Inventory.Amount 1;
	Inventory.MaxAmount 1;
	+INVENTORY.INVBAR
	Inventory.Icon "I_PSHLD";
	Inventory.PickupSound "Powerup/Pickup";
	Inventory.PickupMessage "Power Shield";
	}
	Override Void AbsorbDamage(int damage, name damageType, out int newdamage)
	{
		If(!special1) return;
		If(damageType=='Hitscan' ||
		   damageType=='Bullet' ||
		   damageType=='Melee' ||
		   damageType=='Explosion')
		{
			NewDamage=int(damage*0.5);
			Owner.A_SetBlend("Green",0.25,50);
			Owner.A_TakeInventory("Q2Cell",max(1,Int(NewDamage*0.66)));
			Owner.player.DamageCount=0;
			If(!Owner.CountInv("Q2Cell"))
			{
				special1=0;
				Owner.A_PlaySound("misc/power2",CHAN_ITEM);
			}
		}
	}
	Override Void OwnerDied() { Super.OwnerDied(); special1=0; }
	Override Void OnDrop(Actor Dropper) { Super.OnDrop(Dropper); special1=0; }
	States
	{
	Spawn:
		ARM2 A -1;
		Stop;
/*	Pickup: FUCK YOU GZDOOOOM!!!!!!!!!!!! WHAT THE HELL DID YOU DO TO PICKUP
		//TNT1 A 0 A_JumpIfInventory("Q2PowerShield",1,1);
		//Goto Pickup+2;
		//TNT1 A 0 A_JumpIfInventory("Q2Cell",0,"Nope");
		TNT1 A 0 A_GiveInventory("Q2Cell",50);
		Stop;

	Nope:
		TNT1 A 0;
		Fail;*/
	Use:
		TNT1 A 0
		{
			if(!invoker.special1)
			{
				if(CountInv("Q2Cell")<1)
				{
					A_Log("Not enough power",true);
					Return;
				}
				invoker.special1=1;
				A_PlaySound("misc/power1",CHAN_ITEM);
			}
			Else
			{
				invoker.special1=0;
				A_PlaySound("misc/power2",CHAN_ITEM);
			}
		}
		Fail;
	}
	Override Void Touch(Actor toucher)
	{
		bool maxed=toucher.A_JumpIfInventory("Q2Cell",0,"Null");
		bool already=toucher.CountInv(GetClassName());
		Bool IsGud=(!maxed || !already);
		bool s=bAlwaysPickup;
		If(IsGud)
		{
			If(!bDropped)
			{
				toucher.A_GiveInventory("Q2Cell",50);
				bAlwaysPickup=True;
			}
			Super.Touch(toucher);
			bAlwaysPickup=s;
		}
	}
}

Class Q2PowerScreen : Q2PowerShield
{
	Default {
	Tag "Power Screen";
	Inventory.Amount 1;
	Inventory.MaxAmount 1;
	+INVENTORY.INVBAR
	Inventory.Icon "I_PSHLD";
	Inventory.PickupSound "Powerup/Pickup";
	Inventory.PickupMessage "Power Screen";
	}
	Actor Shield;
	Override Void AbsorbDamage(int damage, name damageType, out int newdamage) {}
	Override Void Tick()
	{
		Super.Tick();
		If(!Owner) Return;
		If(special1 && !shield)
		{
			Shield=Spawn("BrainShield",Pos,ALLOW_REPLACE);
			Shield.master=owner;
		}
		Else If(!special1 && shield) Shield.Destroy();
	}
}