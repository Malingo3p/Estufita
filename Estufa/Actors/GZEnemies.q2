Actor MedicCommander : Q2Medic
{
	SeeSound "Mediccomm/Sight"
	ActiveSound "Mediccomm/Active"
	PainSound "Mediccomm/Pain"
	DeathSound "Mediccomm/Death"
	Speed 16
	Health 550
	PainChance 60
	GibHealth 100
	Mass 600
	Obituary "%o was blasted by a \cmMedic \c[g4]Commander."
	DropItem Q2Cell 128
	Species "Medic"
	Tag "\cmMedic \c[g4]Commander"
	States
	{
	Spawn:
		MED5 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 5 A_Look
		MED6 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 5 A_Look
		MED7 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[]" 5 A_Look
		MED8 ABC 5 A_Look
		MED5 A 0 A_PlaySound("Mediccomm/Idle",CHAN_VOICE)
		Loop
	See:
		MED0 A 0 A_ChangeFlag(NOPAIN,0)
		MED0 ABCDEF 3 A_VileChase
		Loop
	Missile:
	    TNT1 A 0 A_Jump(120,"SpawnMinion") // I've reduced his chance a bit
		TNT1 A 0 A_JumpIfCloser(260,"Blaster")
	Blaster:
		MED1 ABCDEFGHI 3 A_FaceTarget
		MED1 J 0 A_PlayWeaponSound("Medic/Attack")
		MED1 J 3 A_CustomMissile(BlasterProjectile,38,12)
		MED1 KL 3 A_FaceTarget
		MED1 M 0 A_PlayWeaponSound("Medic/Attack")
		MED1 M 3 A_CustomMissile(BlasterProjectile,38,12)
		MED1 NOPQRS 3 A_FaceTarget
		MED1 T 0 A_CustomMissile(HoverProjectile,38,18) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 T 3 A_FaceTarget
		MED1 U 0 A_CustomMissile(HoverProjectile,38,14) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 U 4 A_FaceTarget
		MED1 V 0 A_CustomMissile(HoverProjectile,38,8) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 V 3 A_FaceTarget
		MED1 W 0 A_CustomMissile(HoverProjectile,38,4) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 W 4 A_FaceTarget
		MED1 X 0 A_CustomMissile(HoverProjectile,38,0) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 X 3 A_FaceTarget
		MED1 Y 0 A_CustomMissile(HoverProjectile,38,4) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 Y 4 A_FaceTarget
		MED1 Z 0 A_CustomMissile(HoverProjectile,38,8) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 Z 3 A_FaceTarget
		MED1 "\" 0 A_CustomMissile(HoverProjectile,38,10) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 "\" 4 A_FaceTarget
		MED1 "[" 0 A_CustomMissile(HoverProjectile,38,13) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 "[" 3 A_FaceTarget
		MED1 "]" 0 A_CustomMissile(HoverProjectile,38,15) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED1 "]" 4 A_FaceTarget
		MED2 A 0 A_CustomMissile(HoverProjectile,38,14) TNT1 A 0 A_PlayWeaponSound("Medic/Attack") MED2 A 3 A_FaceTarget
		MED2 BCDEFGH 2 A_FaceTarget
		Goto See
	SpawnMinion:
		MED2 I 1 A_PlayWeaponSound("Mediccomm/Spawn")
		MED2 IJKL 2 A_Facetarget
		MED2 M 2 A_SpawnItemEx("MedicCommanderMinionspawner",64,0,0,0,0,0,0,SXF_SETMASTER|32)
		MED2 "NOPQRSTUVWXYZ\[]" 3 A_Facetarget
		MED0 YZ 3
		Goto See
	Heal:
		"----" A 3 A_PlayWeaponSound("Medic/Heal")
		MED2 IJKLMNOPQRSTUV 2
		MED2 "WXYZ\[]" 3
		MED0 YZ 3
		Goto See
	Pain:
		"----" A 0 A_ChangeFlag(NOPAIN,1)
		"----" A 0 A_Pain
		"----" A 0 A_Jump(256,"Pain1","Pain2")
		Goto See
	Pain1:
		"----" A 3
		MED3 ABCDEFGH 3
		Goto See
	Pain2:
		"----" A 3
		MED3 IJKLMNOPQRSTUVW 3
		Goto See
	Death:
		TNT1 A 0 A_SpawnItemEx(DestroyableBodyThing,0,0,0,0,0,0,0,SXF_NOCHECKPOSITION|SXF_SETMASTER)
		TNT1 A 0 A_ScreamAndUnblock
		MED4 "ABCDEFGHIJKLMNOPQRSTUVWXYZ\[" 3
		MED4 "]" -1
		Stop
	Raise:
		Stop
	}
}

Actor MedicCommanderMinionspawner : RandomSpawner // Chances rebalanced too
{ 
    DropItem "LightGuard",  256, 256
    DropItem "ShotgunGuard", 256, 180
    DropItem "MachinegunGuard", 256, 175
	DropItem "Infantry", 256, 150
}

Actor Daedalus : Hover
{  Health 500
   DropItem "QCSlugAmmo", 15
   SeeSound "Daedalus/Sight"
   ActiveSound "Daedalus/Active"
   PainSound "Daedalus/Pain"
   DeathSound "Daedalus/Death"
   Obituary "%o was blasted by a \c[g4]Daedalus."
   Species "Daedalus"
   Tag "\c[g4]Daedalus"
   +NOINFIGHTSPECIES
   Species "painelemental"
   var int user_shieldup;
   States
	{
	Spawn:
	    TNT1 A 0 A_JumpIf(user_shieldup>=1,"SpawnLoop")
		TNT1 A 0 A_SpawnItemEx("BrainShieldSpawner",0,0,0,0,0,0, 0,SXF_NOCHECKPOSITION)
		TNT1 A 0 A_SetUserVar(user_shieldup,1)
	SpawnLoop:
		HVR0 A 0 A_PlaySound("Hover/Fly",CHAN_BODY,0.5,1)
		TNT1 A 0 A_SpawnItemEx("BrainShieldSpawner",0,0,0,0,0,0, 0,SXF_NOCHECKPOSITION)
		HVR0 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[^]" 6 A_Look
		Loop
	See:
		HVR1 A 0 A_ChangeFlag(NOPAIN,0)
		TNT1 A 0 A_FaceTarget
		HVR1 "ABCDEFGHIJKLMNOPQRSTUVWXYZ[^]" 3 A_Chase
		TNT1 A 0 A_FaceTarget
		Loop
	Missile:
	    "----" A 5 A_FaceTarget
	    HVR3 LMN 3 A_FaceTarget
	    HVR3 O 0 A_PlayWeaponSound("Weapons/HyperBlasterFire")
	    HVR3 O 3 A_CustomMissile(DaedalusGreenBlaster,37)
	    HVR3 P 0 A_PlayWeaponSound("Weapons/HyperBlasterFire")
	    HVR3 P 3 A_CustomMissile(DaedalusGreenBlaster,37)
	    HVR3 QRS 3 A_FaceTarget
	    HVR3 N 0 A_Jump(64,"See")
	    HVR3 N 0 A_CPosRefire
	    Goto Missile+4
	Pain:
		TNT1 A 0 A_ChangeFlag(NOPAIN,1)
		TNT1 A 0 A_Pain
		TNT1 A 0 A_Jump(256,"Pain1","Pain2")
	Pain1:
		HVR2 ABCDEFGHIJKL 3
		Goto See
	Pain2:
		HVR2 MNOPQRSTU 3
		Goto See
	Death:
		TNT1 A 0 A_ChangeFlag(FLOATBOB,0)
		TNT1 A 0 A_StopSound(CHAN_BODY)
		HVR1 A 0 A_ScreamAndUnblock
		TNT1 A 0 A_KillChildren("Removed")
		TNT1 A 0 A_GiveInventory("CheckShield",1)	 
		TNT1 A 0 A_SetUserVar(user_shieldup,0)
		HVR3 ABCDEFGHIJ 4
		HVR3 K 1 A_JumpIf(MomZ==0,1)
		Wait
		HVR3 K 20
		TNT1 A 0 A_PlaySound("Weapons/RocketExplosion")
		TNT1 A 0 A_SpawnItem(Q2Explosion)
		Goto Super::XDeath+1
	XDeath:
	    TNT1 A 0 A_NoBlocking
		TNT1 A 0 A_Fall
		TNT1 A 0 A_KillChildren("Removed")
		TNT1 A 0 A_GiveInventory("CheckShield",1)	 
		TNT1 A 0 A_PlaySound("Weapons/RocketExplosion")
		TNT1 A 0 A_SpawnItem(Q2Explosion,0,32)
		TNT1 A 5 A_SpawnItem(Q2GibSpawner)
		TNT1 A 5
		TNT1 A -1
		Goto Super::XDeathChecksDone
	Raise:
	    TNT1 A 0 A_TakeInventory("CheckShield",32767)
		"----" A 0 A_GiveInventory(ResurrectedToken,1)
		"----" A 25 A_StopSound(CHAN_BODY)
		"----" A 6 A_TakeInventory(ResurrectedToken,1)
		Goto See
	Crush:
		TNT1 AAAAAAA 0 A_SpawnItemEx(Q2Gib,Random2(40),0,5,Random(0,1),0,2,Random(1,360))
		TNT1 A 5 A_XScream
		Stop
	}
}

Actor DaedalusGreenBlaster : HoverProjectile { +THRUGHOST }

Actor GZBlackWidow1 
{   Health 4500
	Speed 5
	PainChance 10
	Mass 3000
	Radius 40
	Height 110
	DeathHeight 110
	MeleeDamage 7
	Monster
	Obituary "%o was killed by the \c[l5]Black Widow."
	Species "BlackWidow"
	Tag "\c[l5]Black Widow"
	+NOFEAR 
	+NORADIUSDMG
	+BOSS 
	+BOSSDEATH 
	+DONTMORPH
	+MISSILEMORE
	+NOINFIGHTSPECIES
    SeeSound "BlackWidow/Sight"
    PainSound "BlackWidow1/Pain"
	ActiveSound "BlackWidow/Active"
	DeathSound "BlackWidow/Death"
	States
{   
    Spawn:
	  BWID ABCDEFGHIJK 5 A_Look
	  Loop
	Idle:
	  BWSW ABCDEFGHIJKLMNOPQR 4 A_Look
	  Loop
	See:
	  BWWK ABCDEFIJ 3 A_Chase
	  TNT1 A 0 A_PlaySound("BlackWidow/Step")
	  BWWK KLM 5 A_Chase
	  Loop
	Melee:
	  BWKC ABCDEFGH 3 A_MeleeAttack TNT1 A 0 A_FaceTarget
	  Goto See
	Pain:
	  TNT1 A 0 A_Jump(256,"Pain1","Pain2")
	Pain1:
	  TNT1 A 0 A_Pain
	  BWPN ABCDEFGHIJKLM 5 
	  Goto See
	Pain2:
	  BWPN NOP 7
	  Goto See
	Missile:
	  TNT1 A 0 A_Jump(85,"Missile1","Missile2","Missile3","Missile4")
	Run:
	  TNT1 A 0 A_ChangeFlag("ALWAYSFAST",1)
	  BWRN ABCDEFGH 3 A_ExtChase(256,0)
	  TNT1 A 0 A_ChangeFlag("ALWAYSFAST",0)
	  Goto Missile+1
	Missile1:
	  BWAK ABCDEFGHI 6 A_FaceTarget
	  Goto See
	Missile2:
	  BWAK JKLMNOPQR 6 A_FaceTarget
	  Goto See
	Missile3:
	  BWAK STUVWXYZ 5 A_FaceTarget
	  BWA_ A 1
	  Goto See
	Missile4:
	  BWA2 ABCDEFGHIJKLMNOPQRSTUVW 3 A_FaceTarget
	  Goto See
	TS:
	TSR:
	  BWTS ABCDE 4
	  Goto See
	TSL:
	  BWTS FGHIJ 4
	  Goto See
	TSM:
	  BWTS KLMN 4
	  Goto See
	Death: 
      TNT1 A 0 A_Scream
	  BWDT ABCDEFGHIJKLMNOPQRSTUVWXYZ 3 A_SpawnItemEx(MakronExplosion,Random2(Radius),Random2(Radius),Random(0,80),0,0,0,0,SXF_TRANSFERPOINTERS)
	  BWD_ ABCDE 5 A_SpawnItemEx(MakronExplosion,Random2(Radius),Random2(Radius),Random(0,80),0,0,0,0,SXF_TRANSFERPOINTERS)
	  TNT1 AAAAAAAAAAAAAAAA 0 A_SpawnItemEx(Q2Gib,Random2(Radius),0,Random(0,80),2,0,Random(0,10),Random(1,360))
	  TNT1 A 5 A_XScream
	  Stop
}}

Actor GZStalker : Q2SoldierBase
{  Health 550
   Mass 120 }