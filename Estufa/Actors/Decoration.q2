
ACTOR DeadBackGrunt : DeadMarine
{
	+CORPSE
	+SHOOTABLE
	+NOTAUTOAIMED
	Mass 0x7fffffff
	Health 60
	Radius 32
	States
	{
	Spawn:
	    TNT1 A 2 NoDelay A_SetAngle(FRandom(1,360))
		PLAY N -1
		Stop
	Death:
	Crush:
		TNT1 AAAAAAA 0 A_SpawnItemEx(Q2Gib,Random(0,40),0,5,Random(0,1),0,2,Random(1,360))
		TNT1 A 5 A_XScream
		Stop
	}
}

ACTOR DeadStomatchGrunt : DeadBackGrunt {}

ACTOR DeadBackGruntNohead : DeadBackGrunt {}

ACTOR DeadSideGrunt : DeadBackGrunt {}

ACTOR DeadSittingGrunt
{
	+CORPSE
	+SHOOTABLE
	+NOTAUTOAIMED
	Mass 0x7fffffff
	Health 20
	Radius 32
	States
	{
	Spawn:
		PLAY N -1
		Stop
	Death:
	Crush:
		TNT1 AAAAAAA 0 A_SpawnItemEx(Q2Gib,Random(0,40),0,5,Random(0,1),0,2,Random(1,360))
		TNT1 A 5 A_XScream
		Stop
	}
}

ACTOR DeadBackMajor : DeadBackGrunt {}

ACTOR DeadStomatchMajor : DeadBackGrunt {}

ACTOR DeadBackMajorNohead : DeadBackGrunt {}

ACTOR DeadSideMajor : DeadBackGrunt {}

ACTOR DeadSittingMajor : DeadSittingGrunt {}

Actor DeadGruntSpawner : RandomSpawner Replaces DeadMarine
{
	DropItem "DeadBackGrunt"
	DropItem "DeadBackGruntNohead"
	DropItem "DeadStomatchGrunt"
	DropItem "DeadSideGrunt"
	DropItem "DeadBackMajor"
	DropItem "DeadBackMajorNohead"
	DropItem "DeadStomatchMajor"
	DropItem "DeadSideMajor"	
}

Actor DeadGrunt2Spawner : RandomSpawner Replaces GibbedMarine
{
	DropItem "DeadBackGrunt"
	DropItem "DeadBackGruntNohead"
	DropItem "DeadStomatchGrunt"
	DropItem "DeadSideGrunt"
	DropItem "DeadBackMajor"
	DropItem "DeadBackMajorNohead"
	DropItem "DeadStomatchMajor"
	DropItem "DeadSideMajor"	
}

ACTOR DeadGuard1 : DeadBackGrunt
{
	States
	{
	Spawn:
	    TNT1 A 2 NoDelay A_SetAngle(FRandom(1,360))
		GRD5 N -1
		Stop
	}
}

ACTOR DeadGuard2 : DeadGuard1 {}
ACTOR DeadGuard3 : DeadGuard1 {}
ACTOR DeadGuard4 : DeadGuard1 {}
ACTOR DeadGuard5 : DeadGuard1 {}
ACTOR DeadGuard6 : DeadGuard1 {}
ACTOR DeadShotgunGuard1 : DeadGuard1 {}
ACTOR DeadShotgunGuard2 : DeadGuard1 {}
ACTOR DeadShotgunGuard3 : DeadGuard1 {}
ACTOR DeadShotgunGuard4 : DeadGuard1 {}
ACTOR DeadShotgunGuard5 : DeadGuard1 {}
ACTOR DeadShotgunGuard6 : DeadGuard1 {}

Actor DeadGuardSpawner : RandomSpawner Replaces DeadZombieman
{
	DropItem "DeadGuard1"
	DropItem "DeadGuard2"
	DropItem "DeadGuard3"
	DropItem "DeadGuard4"
	DropItem "DeadGuard5"
	DropItem "DeadGuard6"
}

Actor DeadShotgunGuardSpawner : RandomSpawner Replaces DeadShotgunguy
{
	DropItem "DeadShotgunGuard1"
	DropItem "DeadShotgunGuard2"
	DropItem "DeadShotgunGuard3"
	DropItem "DeadShotgunGuard4"
	DropItem "DeadShotgunGuard5"
	DropItem "DeadShotgunGuard6"
}

Actor DeadEnhancedGuardSpawner : RandomSpawner Replaces DeadDoomimp
{
	DropItem "DeadGuard1"
	DropItem "DeadGuard2"
	DropItem "DeadGuard3"
	DropItem "DeadGuard4"
	DropItem "DeadGuard5"
	DropItem "DeadGuard6"
}
Actor Q2ExplosiveBarrel : ExplosiveBarrel Replaces ExplosiveBarrel
{
	DeathSound "Weapons/RocketExplosion"
	DamageType Explosion
	States
	{
	Spawn:
		BAR1 A -1
		Stop
	Death:
		BAR1 A 3 Bright
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",2)==True,"Explode")
		BAR1 A 12 Bright A_JumpIf(ACS_NamedExecuteWithResult("GetCvarInfo",1)==True,1)
		Goto Explode
		BAR1 A 2 Bright
		BAR1 AAAAAA 1 Bright A_SetScale(ScaleX-0.03,ScaleY+0.066)
		BAR1 AAAAAA 1 Bright A_SetScale(ScaleX*1.25,ScaleY-0.09)
	Explode:
		TNT1 A 0 A_Scream
		TNT1 A 0 A_SpawnItem(Q2Explosion,0,22)
		TNT1 A 0 A_Explode
		TNT1 A 1050 BRIGHT A_BarrelDestroy
		TNT1 A 5 A_Respawn
		Wait
	}
}