Class IsCrouching : InvBoolean {}
Class IsNOTCrouching : InvBoolean {}
Class Q2Grunt : DoomPlayer
{
	Default {
	Player.DisplayName "Grunt";
	Player.SoundClass "Grunt";
	Player.ColorRange 0, 0;
	Player.StartItem "Q2Blaster";
	Player.ViewHeight 48;
	Player.AttackZOffset 15;
	//+DONTTRANSLATE
	+NOSKIN
	+INTERPOLATEANGLES
	GibHealth 50;
	}
	Bool Crouchie()
	{
		If(!Player) Return False;
		If(player.crouchfactor<0.75) Return True;
		Return False;
	}
	Virtual Void A_CheckSprite(String AnimID, StateLabel CrouchState=Null, StateLabel StandState=Null)
	{
		If(!Player) Return;
		//static const array<name> 
		String Letter="B";
		Let Weap=Q2Weapon(Player.ReadyWeapon);
		If(Weap && Weap.SkinID) Letter=Weap.SkinID;
		String Spn="P"..Letter..AnimID;
		//A_Log(Spn);
		Int Sp=GetSpriteIndex(Spn);
		//If(Player.ReadyWeapon.GetClassName()=="Q2Shotgun")
		Sprite=Sp;
		If(CrouchState && Crouchie()) SetStateLabel(CrouchState);
		Else If(StandState && !Crouchie()) SetStateLabel(StandState);
	}
	Override void PlayRunning ()
	{
		if (InStateSequence(CurState, SpawnState) || InStateSequence(CurState, ResolveState("SpawnCrouch")))
		{
			If(!Crouchie())
			SetState (SeeState);
			else
			SetStateLabel("SeeCrouch");
		}
	}
	Override void PlayIdle ()
	{
		if (InStateSequence(CurState, SeeState) || InStateSequence(CurState, ResolveState("SeeCrouch")))
		{
			If(!Crouchie())
			SetState (SpawnState);
			else
			SetStateLabel("SpawnCrouch");
		}
	}
	Override void PlayAttacking ()
	{
		StateLabel MisState="Missile";
		Let Weap=Q2Weapon(Player.ReadyWeapon);
		If(Weap)
		{
			String WeapName=Weap.GetClassName();
			Switch (Weap.GetClassName())
			{
				Case Name("Q2Blaster"):			MisState="Missile.Blaster"; Break;
				Case Name("Q2Shotgun"):			MisState="Missile.Shotgun"; Break;
				Case Name("Q2SuperShotgun"):	MisState="Missile.Shotgun"; Break;
				Case Name("Q2Machinegun"):		MisState="Missile.Machinegun"; Break;
				Case Name("Q2Chaingun"):		MisState="Missile.Chaingun"; Break;
				Case Name("Q2HandGrenade"):		MisState=Null; Break;
				Case Name("Q2GrenadeLauncher"):	MisState="Missile.Shotgun"; Break;
				Case Name("Q2RocketLauncher"):	MisState="Missile.RocketLauncher"; Break;
				Case Name("Q2HyperBlaster"):	MisState="Missile.HyperBlaster"; Break;
				Case Name("Q2Railgun"):			MisState="Missile.Shotgun"; Break;
				Case Name("Q2BFG10K"):			MisState="Missile.BFG"; Break;
				Case Name("Q1SNG"):				MisState="Missile.HyperBlaster"; Break;
			}
		}
		If(FindState(MisState,true))
		SetStateLabel(MisState);
	}
	Bool JCheckie;
	Override void CheckJump()
	{
		Double OldSpeed=Vel.Z;
		Super.CheckJump();
		If(OldSpeed!=Vel.Z && player.onground && !WaterLevel && !bNoGravity)
		JCheckie=True;
	}
	Override Void Tick()
	{
		Super.Tick();
		If(JCheckie)
		{
			JCheckie=False;
			SetStateLabel("Jump"); // had to do this outside CheckJump just in case
		}
	}
	States
	{
	Melee: Stop;
	
	SpawnCrouch:
		"----" A 4;
		PA05 ABCEFGHIJKLMNOPONMLKJIHGFEDCB 4 A_CheckSprite("05",Null,"Spawn");
		Goto SpawnCrouch+1;
	Spawn:
		"----" A 4;
		PA01 ABCDEFGHIJKLMNOPQRSTUTSRQPONMLKJIHGFEDCB 4 A_CheckSprite("01","SpawnCrouch");
		Goto Spawn+1;
		"----" A 4;
		PA05 ABCEFGHIJKLMNOPONMLKJIHGFEDCB 4 A_CheckSprite("05",Null,"Spawn");
		Goto Spawn+42;
	SeeCrouch:
		"----" A 4;
		PA06 ABCDEF 4 A_CheckSprite("06",Null,"See");
		Goto SeeCrouch+1;
	See:
		"----" A 4;
		PA02 ABCDEF 4 A_CheckSprite("02","SeeCrouch");
		Goto See+1;
	Jump:
		"----" A 4;
		PA04 A 8 A_CheckSprite("04");
		PA04 B 1 { A_CheckSprite("04"); Return A_JumpIf(Player.OnGround,1); }
		Wait;
		PA04 B 3 A_CheckSprite("04");
		PA04 CDEF 3 A_CheckSprite("04","SpawnCrouch");
		Goto Spawn;
	Missile:
		"----" A 4 A_JumpIf(Crouchie(),5);
		PA02 GHG 4 A_CheckSprite("02","SpawnCrouch");
		PA01 T 4 A_CheckSprite("01","SpawnCrouch");
		Goto Spawn;
		"----" A 4;
		PA07 ABA 4 A_CheckSprite("07",Null,"Spawn");
		PA05 A 4 A_CheckSprite("05",Null,"Spawn");
		Goto SpawnCrouch;
	Missile.Shotgun:
		"----" A 4 A_JumpIf(Crouchie(),9);
		PA02 GHIJKLMN 4 A_CheckSprite("02","SpawnCrouch");
		Goto Spawn;
		"----" A 4;
		PA07 ABCDEFGHI 4 A_CheckSprite("07",Null,"Spawn");
		PA05 A 4 A_CheckSprite("05",Null,"Spawn");
		Goto SpawnCrouch;
	Missile.Blaster:
		"----" A 4 A_JumpIf(Crouchie(),5);
		PA02 GHG 4 A_CheckSprite("02","SpawnCrouch");
		PA01 T 4 A_CheckSprite("01","SpawnCrouch");
		Goto Spawn;
		"----" A 4;
		PA07 ABA 4 A_CheckSprite("07",Null,"Spawn");
		PA05 A 4 A_CheckSprite("05",Null,"Spawn");
		Goto SpawnCrouch;
	Missile.Machinegun:
		TNT1 A 0 A_JumpIf(Crouchie(),5);
		PD02 GHGH 4 A_CheckSprite("02","SpawnCrouch");
		Goto Spawn;
		PD07 AIAI 4 A_CheckSprite("07",Null,"Spawn");
		Goto SpawnCrouch;
	Missile.Chaingun:
		TNT1 A 0 A_JumpIf(Crouchie(),13);
		PE02 GHGHGHGHGHGH 3 A_CheckSprite("02","SpawnCrouch");
		Goto Spawn;
		PE07 AIAIAIAIAIAI 3 A_CheckSprite("07",Null,"Spawn");
		Goto SpawnCrouch;
	Missile.RocketLauncher:
		"----" A 4 A_JumpIf(Crouchie(),6);
		PG02 GHIHG 3 A_CheckSprite("02","SpawnCrouch");
		Goto Spawn;
		"----" A 4;
		PG07 ABCBA 3 A_CheckSprite("07",Null,"Spawn");
		Goto SpawnCrouch;
	Missile.HyperBlaster:
		TNT1 A 0 A_JumpIf(Crouchie(),3);
		PH02 G 5 A_CheckSprite("02","SpawnCrouch");
		PH01 T 3 A_CheckSprite("01","SpawnCrouch");
		Goto Spawn;
		PH05 A 5 A_CheckSprite("05",Null,"Spawn");
		PH07 A 4 A_CheckSprite("07",Null,"Spawn");
		Goto SpawnCrouch;
	Missile.BFG:
		"----" A 5 A_JumpIf(Crouchie(),18);
		PJ02 GGG 5 A_CheckSprite("02","SpawnCrouch");
		PJ02 GHI 4 A_CheckSprite("02","SpawnCrouch");
		PJ02 GGGG 5 A_CheckSprite("02","SpawnCrouch");
		PJ02 HIJKLMN 3 A_CheckSprite("02","SpawnCrouch");
		Goto Spawn;
		"----" A 5;
		PJ07 AAA 5 A_CheckSprite("07",Null,"Spawn");
		PJ07 ABC 4 A_CheckSprite("07",Null,"Spawn");
		PJ07 AAAA 5 A_CheckSprite("07",Null,"Spawn");
		PJ07 CDEFGHI 3 A_CheckSprite("07",Null,"Spawn");
		Goto SpawnCrouch;
	Pain:
		"----" A 0 A_Pain;
		"----" A 0 A_JumpIf(Crouchie(),14);
		"----" A 0 A_Jump(256,1,5,9);
		Goto Spawn;
		PA03 ABCD 3 A_CheckSprite("03");
		Goto Spawn;
		PA03 EFGH 3 A_CheckSprite("03");
		Goto Spawn;
		PA03 IJKL 3 A_CheckSprite("03");
		Goto Spawn;
		PA08 ABCD 3 A_CheckSprite("08");
		Goto SpawnCrouch;
	Taunt.Flip:
		P002 ABCDEFGHIJKL 4;
		Goto Spawn;
	Taunt.Salute:
		P002 MNOPQRSTUVW 4;
		Goto Spawn;
	Taunt.Taunt:
		P003 ABCDEFGHIJKLMNOPQ 4;
		Goto Spawn;
	Taunt.Wave:
		P004 ABCDEFGHIJK 4;
		Goto Spawn;
	Taunt.Point:
		P003 "RSTUVWXYZ\[]" 4;
		Goto Spawn;
	Death:
		"----" A 0 A_PlayerScream;
		"----" A 0 A_NoBlocking;
		"----" A 0 A_JumpIf(Crouchie(),"CrouchDeath");
		"----" A 0 A_Jump(256,"Death1","Death2","Death3");
	Death1:
		"----" A 6;
		P001 ABCDE 6;
		P001 F -1;
		Stop;
	Death2:
		"----" A 6;
		P001 GHIJK 6;
		P001 L -1;
		Stop;
	Death3:
		"----" A 6;
		P001 MNOPQR 5;
		P001 S 20;
		P001 T -1;
		Stop;
	CrouchDeath:
		"----" A 6;
		P005 ABCD 5;
		P005 E -1;
		Stop;
	XDeath:
		TNT1 A 5 A_SpawnItem("Q2GibSpawner");
		TNT1 A 5 A_CheckPlayerDone();
		Wait;
	Crush:
		TNT1 AAAAAAA 0 A_SpawnItemEx("Q2Gib",Random2(40),0,5,Random(0,1),0,2,Random(1,360));
		TNT1 A 0 A_XScream;
		TNT1 A 5 A_CheckPlayerDone;
		Wait;// <- this fixes that byotyful crash that i did'nt noticed before the first release youtu.be/zkFco2XViu0?t=11m4s
		
		//sprite precache
		PA04 A 0; PA05 A 0; PA06 A 0; PA07 A 0; PA08 A 0;
		PB01 A 0; PB02 A 0; PB03 A 0; PB04 A 0; PB05 A 0; PB06 A 0; PB07 A 0; PB08 A 0; 
		PC01 A 0; PC02 A 0; PC03 A 0; PC04 A 0; PC05 A 0; PC06 A 0; PC07 A 0; PC08 A 0; 
		PD01 A 0; PD02 A 0; PD03 A 0; PD04 A 0; PD05 A 0; PD06 A 0; PD07 A 0; PD08 A 0; 
		PE01 A 0; PE02 A 0; PE03 A 0; PE04 A 0; PE05 A 0; PE06 A 0; PE07 A 0; PE08 A 0; 
		PF01 A 0; PF02 A 0; PF03 A 0; PF04 A 0; PF05 A 0; PF06 A 0; PF07 A 0; PF08 A 0; 
		PG01 A 0; PG02 A 0; PG03 A 0; PG04 A 0; PG05 A 0; PG06 A 0; PG07 A 0; PG08 A 0; 
		PH01 A 0; PH02 A 0; PH03 A 0; PH04 A 0; PH05 A 0; PH06 A 0; PH07 A 0; PI08 A 0; 
		PI01 A 0; PI02 A 0; PI03 A 0; PI04 A 0; PI05 A 0; PI06 A 0; PI07 A 0; PH08 A 0; 
		PJ01 A 0; PJ02 A 0; PJ03 A 0; PJ04 A 0; PJ05 A 0; PJ06 A 0; PJ07 A 0; PJ08 A 0; 
		PK01 A 0; PK02 A 0; PK03 A 0; PK04 A 0; PK05 A 0; PK06 A 0; PK07 A 0; PK08 A 0; 
		PS01 A 0; PS02 A 0; PS03 A 0; PS04 A 0; PS05 A 0; PS06 A 0; PS07 A 0; PS08 A 0; 
		PL01 A 0; PL02 A 0; PL03 A 0; PL04 A 0; PL05 A 0; PL06 A 0; PL07 A 0; PL08 A 0; 
		PT01 A 0; PT02 A 0; PT03 A 0; PT04 A 0; PT05 A 0; PT06 A 0; PT07 A 0; PT08 A 0; 
	/*
	Spawn:
		"----" A 1
		PA01 T 0 A_JumpIfInventory(IsCrouching,1,2)
		TNT1 A 0 A_Jump(256,361)//---
		PA01 T 0 A_JumpIfInventory(WeaponIndex,2,18)
		PA05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PA05 A 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,3,18)
		PB05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PB05 A 0 A_Jump(256,"Spawn")
		PB01 T 0 A_JumpIfInventory(WeaponIndex,4,18)
		PC05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PC05 A 0 A_Jump(256,"Spawn")
		PC01 T 0 A_JumpIfInventory(WeaponIndex,5,18)
		PD05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PD05 A 0 A_Jump(256,"Spawn")
		PD01 T 0 A_JumpIfInventory(WeaponIndex,6,18)
		PE05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PE05 A 0 A_Jump(256,"Spawn")
		PE01 T 0 A_JumpIfInventory(WeaponIndex,7,18)
		PF05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PF05 A 0 A_Jump(256,"Spawn")
		PF01 T 0 A_JumpIfInventory(WeaponIndex,8,18)
		PG05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PG05 A 0 A_Jump(256,"Spawn")
		PG01 T 0 A_JumpIfInventory(WeaponIndex,9,18)
		PH05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PH05 A 0 A_Jump(256,"Spawn")
		PH01 T 0 A_JumpIfInventory(WeaponIndex,10,18)
		PI05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PI05 A 0 A_Jump(256,"Spawn")
		PI01 T 0 A_JumpIfInventory(WeaponIndex,11,18)
		PJ05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PJ05 A 0 A_Jump(256,"Spawn")
		PJ01 T 0 A_JumpIfInventory(WeaponIndex,12,18)
		PK05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PK05 A 0 A_Jump(256,"Spawn")
		PK01 T 0 A_JumpIfInventory(WeaponIndex,13,18)
		PL05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PL05 A 0 A_Jump(256,"Spawn")
		PL01 T 0 A_JumpIfInventory(WeaponIndex,14,18)
		PM05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PM05 A 0 A_Jump(256,"Spawn")
		PM01 T 0 A_JumpIfInventory(WeaponIndex,15,18)
		PN05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PN05 A 0 A_Jump(256,"Spawn")
		PN01 T 0 A_JumpIfInventory(WeaponIndex,16,18)
		PO05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PO05 A 0 A_Jump(256,"Spawn")
		PO01 T 0 A_JumpIfInventory(WeaponIndex,17,18)
		PP05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PP05 A 0 A_Jump(256,"Spawn")
		PP01 T 0 A_JumpIfInventory(WeaponIndex,18,18)
		PQ05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PQ05 A 0 A_Jump(256,"Spawn")
		PQ01 T 0 A_JumpIfInventory(WeaponIndex,19,18)
		PR05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PR05 A 0 A_Jump(256,"Spawn")
		PR01 T 0 A_JumpIfInventory(WeaponIndex,20,18)
		PS05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PS05 A 0 A_Jump(256,"Spawn")
		PS01 T 0// A_JumpIfInventory(WeaponIndex,21,18)
		PT05 ABCDEFGHIJKLMNOP 6 A_JumpIfInventory(IsNOTCrouching,1,"Spawn")
		PT05 A 0 A_Jump(256,"Spawn")
		
		PA01 T 0 A_JumpIfInventory(WeaponIndex,2,42)
		PA01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn") // Blaster
		PA01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,3,42)
		PB01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// Shotgun
		PB01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,4,42)
		PC01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// SuperShotgun
		PC01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,5,42)
		PD01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// Machinegun
		PD01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,6,42)
		PE01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// Chaingun
		PE01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,7,42)
		PF01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// GrenadeLauncher
		PF01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,8,42)
		PG01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// RocketLauncher
		PG01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,9,42)
		PH01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// HyperBlaster
		PH01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,10,42)
		PI01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// Railgun
		PI01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,11,42)
		PJ01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// BFG10k
		PJ01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,12,42)
		PK01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// HandGrenade
		PK01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,13,42)
		PL01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// Phalanx
		PL01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,14,42)
		PM01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// ???
		PM01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,15,42)
		PN01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// ???
		PN01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,16,42)
		PO01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// ???
		PO01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,17,42)
		PP01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// ???
		PP01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,18,42)
		PQ01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// ???
		PQ01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,19,42)
		PR01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// ???
		PR01 T 0 A_Jump(256,"Spawn")
		PA01 T 0 A_JumpIfInventory(WeaponIndex,20,42)
		PS01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// Super Nailgun
		PS01 T 0 A_Jump(256,"Spawn")
		PT01 TSRQPONMLKJIHGFEDCBABCDEFGHIJKLMNOPQRSTU 4 A_JumpIfInventory(IsCrouching,1,"Spawn")// Thunderbolt
		PT01 T 0 A_Jump(256,"Spawn")
		Loop
	See:
		GRNT A -1 A_Jump(256,1)
		"----" A 0 A_JumpIfInventory(WeaponIndex,20,"SeeLG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,19,"SeeSNG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,12,"SeePhalanx")
		"----" A 0 A_JumpIfInventory(WeaponIndex,11,"SeeGrenade")
		"----" A 0 A_JumpIfInventory(WeaponIndex,10,"SeeBFG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,9,"SeeRailgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,8,"SeeHyperBlaster")
		"----" A 0 A_JumpIfInventory(WeaponIndex,7,"SeeRocketLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,6,"SeeGrenadeLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,5,"SeeChaingun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,4,"SeeMachinegun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,3,"SeeSuperShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,2,"SeeShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,1,"SeeBlaster")
		Goto SeeShotgun
	Missile:
		"----" A 0 A_JumpIfInventory(PowerQuadDamage,1,2)
		"----" A 0 A_Jump(256,2)
		"----" A 0 A_PlaySound("Powerup/QuadDamage/Attack",CHAN_7,0.75)
		"----" A 0 A_JumpIfInventory(WeaponIndex,20,"MissileLG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,19,"MissileSNG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,12,"MissilePhalanx")
		"----" A 0 A_JumpIfInventory(WeaponIndex,11,"MissileGrenade")
		"----" A 0 A_JumpIfInventory(WeaponIndex,10,"MissileBFG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,9,"MissileRailgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,8,"MissileHyperBlaster")
		"----" A 0 A_JumpIfInventory(WeaponIndex,7,"MissileRocketLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,6,"MissileGrenadeLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,5,"MissileChaingun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,4,"MissileMachinegun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,3,"MissileSuperShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,2,"MissileShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,1,"MissileBlaster")
		Goto MissileShotgun
	Pain.Falling:
		"----" A 0 A_PlaySoundEx("*fallpain",CHAN_VOICE,0)
		Goto Spawn
	Pain:
		"----" A 0 A_JumpIfInventory(WeaponIndex,20,"PainLG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,19,"PainSNG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,12,"PainPhalanx")
		"----" A 0 A_JumpIfInventory(WeaponIndex,11,"PainGrenade")
		"----" A 0 A_JumpIfInventory(WeaponIndex,10,"PainBFG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,9,"PainRailgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,8,"PainHyperBlaster")
		"----" A 0 A_JumpIfInventory(WeaponIndex,7,"PainRocketLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,6,"PainGrenadeLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,5,"PainChaingun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,4,"PainMachinegun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,3,"PainSuperShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,2,"PainShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,1,"PainBlaster")
		Goto PainShotgun
	Jump:
		"----" A 0 A_JumpIfInventory(WeaponIndex,20,"JumpLG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,19,"JumpSNG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,12,"JumpPhalanx")
		"----" A 0 A_JumpIfInventory(WeaponIndex,11,"JumpGrenade")
		"----" A 0 A_JumpIfInventory(WeaponIndex,10,"JumpBFG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,9,"JumpRailgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,8,"JumpHyperBlaster")
		"----" A 0 A_JumpIfInventory(WeaponIndex,7,"JumpRocketLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,6,"JumpGrenadeLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,5,"JumpChaingun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,4,"JumpMachinegun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,3,"JumpSuperShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,2,"JumpShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,1,"JumpBlaster")
		Goto JumpShotgun
	//----------------- BLASTER -----------------
	SeeBlaster:
		PA02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeBlaster")
		PA02 D 0 
		PA02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeBlaster")
		PA02 A 0 
		Goto Spawn
	CrouchSeeBlaster:
		PA06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeBlaster")
		PA06 A 0
		Goto Spawn
	MissileBlaster:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,5)
		PA02 GHG 4
		PA01 T 8
		Goto Spawn
		PA07 ABA 4
		PA05 A 8
		Goto Spawn
	PainBlaster:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PA03 ABCD 3
		Goto Spawn
		PA03 EFGH 3
		Goto Spawn
		PA03 IJKL 3
		Goto Spawn
		PA08 ABCD 3
		Goto Spawn
	JumpBlaster:
		PA04 A 8
		PA04 B 1 A_CheckFloor(1)
		Wait
		PA04 B 3
		PA04 CDEF 3
		Goto Spawn
		
	//----------------- SHOTGUN -----------------
	SeeShotgun:
		PB02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeShotgun")
		PB02 D 0 
		PB02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeShotgun")
		PB02 A 0 
		Goto Spawn
	CrouchSeeShotgun:
		PB06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeShotgun")
		PB06 A 0
		Goto Spawn
	MissileShotgun:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,9)
		PB02 GHIJKLMN 3
		Goto Spawn
		PB07 ABCDEFGHI 3
		Goto Spawn
	PainShotgun:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PB03 ABCD 3
		Goto Spawn
		PB03 EFGH 3
		Goto Spawn
		PB03 IJKL 3
		Goto Spawn
		PB08 ABCD 3
		Goto Spawn
	JumpShotgun:
		PB04 A 8
		PB04 B 1 A_CheckFloor(1)
		Wait
		PB04 B 3
		PB04 CDEF 3
		Goto Spawn
	//----------------- SUPERSHOTGUN -----------------
	SeeSuperShotgun:
		PC02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeSuperShotgun")
		PC02 D 0 
		PC02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeSuperShotgun")
		PC02 A 0 
		Goto Spawn
	CrouchSeeSuperShotgun:
		PC06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeSuperShotgun")
		PC06 A 0
		Goto Spawn
	MissileSuperShotgun:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,9)
		PC02 GHIJKLMN 4
		Goto Spawn
		PC07 ABCDEFGHI 4
		Goto Spawn
	PainSuperShotgun:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PC03 ABCD 3
		Goto Spawn
		PC03 EFGH 3
		Goto Spawn
		PC03 IJKL 3
		Goto Spawn
		PC08 ABCD 3
		Goto Spawn
	JumpSuperShotgun:
		PC04 A 8
		PC04 B 1 A_CheckFloor(1)
		Wait
		PC04 B 3
		PC04 CDEF 3
		Goto Spawn
		
	//----------------- MACHINEGUN -----------------
	SeeMachinegun:
		PD02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeMachinegun")
		PD02 D 0 
		PD02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeMachinegun")
		PD02 A 0 
		Goto Spawn
	CrouchSeeMachineGun:
		PD06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeMachinegun")
		PD06 A 0
		Goto Spawn
	MissileMachinegun:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,5)
		PD02 GHGH 4
		Goto Spawn
		PD07 AIAI 4
		Goto Spawn
	PainMachinegun:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PD03 ABCD 3
		Goto Spawn
		PD03 EFGH 3
		Goto Spawn
		PD03 IJKL 3
		Goto Spawn
		PD08 ABCD 3
		Goto Spawn
	JumpMachinegun:
		PD04 A 8
		PD04 B 1 A_CheckFloor(1)
		Wait
		PD04 B 3
		PD04 CDEF 3
		Goto Spawn
	//----------------- CHAINGUN -----------------
	SeeChaingun:
		PE02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeChaingun")
		PE02 D 0 
		PE02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeChaingun")
		PE02 A 0 
		Goto Spawn
	CrouchSeeChaingun:
		PE06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeChaingun")
		PE06 A 0
		Goto Spawn
	MissileChaingun:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,13)
		PE02 GHGHGHGHGHGH 3
		Goto Spawn
		PE07 AIAIAIAIAIAI 3
		Goto Spawn
	PainChaingun:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PE03 ABCD 3
		Goto Spawn
		PE03 EFGH 3
		Goto Spawn
		PE03 IJKL 3
		Goto Spawn
		PE08 ABCD 3
		Goto Spawn
	JumpChaingun:
		PE04 A 8
		PE04 B 1 A_CheckFloor(1)
		Wait
		PE04 B 3
		PE04 CDEF 3
		Goto Spawn
		
	//----------------- GLAUNCHER -----------------
	SeeGrenadeLauncher:
		PF02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeGrenadeLauncher")
		PF02 D 0 
		PF02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeGrenadeLauncher")
		PF02 A 0
		Goto Spawn
	CrouchSeeGrenadeLauncher:
		PF06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeGrenadeLauncher")
		PF06 A 0
		Goto Spawn
	MissileGrenadeLauncher:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,10)
		PF02 GHIJKLMN 3
		PF01 T 5
		Goto Spawn
		PF07 ABCDEFGHI 3
		PF05 A 5
		Goto Spawn
	PainGrenadeLauncher:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PF03 ABCD 3
		Goto Spawn
		PF03 EFGH 3
		Goto Spawn
		PF03 IJKL 3
		Goto Spawn
		PF08 ABCD 3
		Goto Spawn
	JumpGrenadeLauncher:
		PF04 A 8
		PF04 B 1 A_CheckFloor(1)
		Wait
		PF04 B 3
		PF04 CDEF 3
		Goto Spawn
		
	//----------------- RLAUNCHER -----------------
	SeeRocketLauncher:
		PG02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeRocketLauncher")
		PG02 D 0 
		PG02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeRocketLauncher")
		PG02 A 0 
		Goto Spawn
	CrouchSeeRocketLauncher:
		PG06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeRocketLauncher")
		PG06 A 0
		Goto Spawn
	MissileRocketLauncher:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,7)
		PG02 GHIHG 3
		PG01 T 5
		Goto Spawn
		PG07 ABCBA 3
		PG05 A 5
		Goto Spawn
	PainRocketLauncher:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PG03 ABCD 3
		Goto Spawn
		PG03 EFGH 3
		Goto Spawn
		PG03 IJKL 3
		Goto Spawn
		PG08 ABCD 3
		Goto Spawn
	JumpRocketLauncher:
		PG04 A 8
		PG04 B 1 A_CheckFloor(1)
		Wait
		PG04 B 3
		PG04 CDEF 3
		Goto Spawn
		
	//----------------- HYPERBLASTER -----------------
	SeeHyperBlaster:
		PH02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeHyperBlaster")
		PH02 D 0 
		PH02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeHyperBlaster")
		PH02 A 0 
		Goto Spawn
	CrouchSeeHyperBlaster:
		PH06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeHyperBlaster")
		PH06 A 0
		Goto Spawn
	MissileHyperBlaster:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,3) 
		PH02 G 5
		PH01 T 3
		Goto Spawn
		PH05 A 5
		PH07 A 4
		Goto Spawn
	PainHyperBlaster:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PH03 ABCD 3
		Goto Spawn
		PH03 EFGH 3
		Goto Spawn
		PH03 IJKL 3
		Goto Spawn
		PH08 ABCD 3
		Goto Spawn
	JumpHyperBlaster:
		PH04 A 8
		PH04 B 1 A_CheckFloor(1)
		Wait
		PH04 B 3
		PH04 CDEF 3
		Goto Spawn
		
	//----------------- RAILGUN -----------------
	SeeRailgun:
		PI02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeRailgun")
		PI02 D 0 
		PI02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeRailgun")
		PI02 A 0 
		Goto Spawn
	CrouchSeeRailgun:
		PI06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeRailgun")
		PI06 A 0
		Goto Spawn
	MissileRailgun:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,9)
		PI02 GH 3
		PI02 IJKLMN 4
		Goto Spawn
		PI07 AB 3
		PI07 CDEFGHI 4
		Goto Spawn
	PainRailgun:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PI03 ABCD 3
		Goto Spawn
		PI03 EFGH 3
		Goto Spawn
		PI03 IJKL 3
		Goto Spawn
		PI08 ABCD 3
		Goto Spawn
	JumpRailgun:
		PI04 A 8
		PI04 B 1 A_CheckFloor(1)
		Wait
		PI04 B 3
		PI04 CDEF 3
		Goto Spawn
		
	//----------------- BFG10K -----------------
	SeeBFG:
		PJ02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeBFG")
		PJ02 D 0 
		PJ02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeBFG")
		PJ02 A 0 
		Goto Spawn
	CrouchSeeBFG:
		PJ06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeBFG")
		PJ06 A 0
		Goto Spawn
	MissileBFG:
		PJ02 G 20 A_JumpIfInventory(IsCrouching,1,13)
		PJ02 GHI 4
		PJ02 GG 10
		PJ02 HIJKLMN 3
		Goto Spawn
		PJ07 A 20
		PJ07 ABC 4
		PJ07 AA 10
		PJ07 CDEFGHI 3
		Goto Spawn
	PainBFG:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PJ03 ABCD 3
		Goto Spawn
		PJ03 EFGH 3
		Goto Spawn
		PJ03 IJKL 3
		Goto Spawn
		PJ08 ABCD 3
		Goto Spawn
	JumpBFG:
		PJ04 A 8
		PJ04 B 1 A_CheckFloor(1)
		Wait
		PJ04 B 3
		PJ04 CDEF 3
		Goto Spawn
		
	//----------------- HandGrenade -----------------
	SeeGrenade:
		PK02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeGrenade")
		PK02 D 0 
		PK02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeGrenade")
		PK02 A 0 
		Goto Spawn
	CrouchSeeGrenade:
		PK06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeGrenade")
		PK06 A 0
		Goto Spawn
	MissileGrenade:
		"----" A 0 A_JumpIfInventory(Q2HoldingGrenade,1,1)
		Goto Spawn
		PK02 G 35
		Goto Spawn
	PainGrenade:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PK03 ABCD 3
		Goto Spawn
		PK03 EFGH 3
		Goto Spawn
		PK03 IJKL 3
		Goto Spawn
		PK08 ABCD 3
		Goto Spawn
	JumpGrenade:
		PK04 A 8
		PK04 B 1 A_CheckFloor(1)
		Wait
		PK04 B 3
		PK04 CDEF 3
		Goto Spawn
	//----------------- PHALANX -----------------
	SeePhalanx:
		PL02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeePhalanx")
		PL02 D 0 
		PL02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeePhalanx")
		PL02 A 0 
		Goto Spawn
	CrouchSeePhalanx:
		PL06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeePhalanx")
		PL06 A 0
		Goto Spawn
	MissilePhalanx:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,7)
		PL02 GHIHG 3
		PL01 T 5
		Goto Spawn
		PL07 ABCBA 3
		PL05 A 5
		Goto Spawn
	PainPhalanx:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PL03 ABCD 3
		Goto Spawn
		PL03 EFGH 3
		Goto Spawn
		PL03 IJKL 3
		Goto Spawn
		PL08 ABCD 3
		Goto Spawn
	JumpPhalanx:
		PL04 A 8
		PL04 B 1 A_CheckFloor(1)
		Wait
		PL04 B 3
		PL04 CDEF 3
		Goto Spawn
	//----------------- SUPERNAILGUN -----------------
	SeeSNG:
		PS02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeSNG")
		PS02 D 0 
		PS02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeSNG")
		PS02 A 0 
		Goto Spawn
	CrouchSeeSNG:
		PS06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeSNG")
		PS06 A 0
		Goto Spawn
	MissileSNG:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,3) 
		PS02 G 5
		PS01 T 3
		Goto Spawn
		PS05 A 5
		PS07 A 4
		Goto Spawn
	PainSNG:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PS03 ABCD 3
		Goto Spawn
		PS03 EFGH 3
		Goto Spawn
		PS03 IJKL 3
		Goto Spawn
		PS08 ABCD 3
		Goto Spawn
	JumpSNG:
		PS04 A 8
		PS04 B 1 A_CheckFloor(1)
		Wait
		PS04 B 3
		PS04 CDEF 3
		Goto Spawn
		
	//----------------- Thunderbolt -----------------
	SeeLG:
		PT02 ABC 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeLG")
		PT02 D 0 
		PT02 DEF 4 A_JumpIfInventory(IsCrouching,1,"CrouchSeeLG")
		PT02 A 0 
		Goto Spawn
	CrouchSeeLG:
		PT06 ABCDEF 3 A_JumpIfInventory(IsNOTCrouching,1,"SeeLG")
		PT06 A 0
		Goto Spawn
	MissileLG:
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,2) 
		PT02 G 15
		Goto Spawn
		PT07 A 15
		Goto Spawn
	PainLG:
		TNT1 A 0 A_Pain
		TNT1 A 0 A_JumpIfInventory(IsCrouching,1,14)
		TNT1 A 0 A_Jump(256,1,5,9)
		Goto Spawn
		PT03 ABCD 3
		Goto Spawn
		PT03 EFGH 3
		Goto Spawn
		PT03 IJKL 3
		Goto Spawn
		PT08 ABCD 3
		Goto Spawn
	JumpLG:
		PT04 A 8
		PT04 B 1 A_CheckFloor(1)
		Wait
		PT04 B 3
		PT04 CDEF 3
		Goto Spawn
		
	Taunt.Flip:
		P002 ABCDEFGHIJKL 4
		Goto Spawn
	Taunt.Salute:
		P002 MNOPQRSTUVW 4
		Goto Spawn
	Taunt.Taunt:
		P003 ABCDEFGHIJKLMNOPQ 4
		Goto Spawn
	Taunt.Wave:
		P004 ABCDEFGHIJK 4
		Goto Spawn
	Taunt.Point:
		P003 "RSTUVWXYZ\[]" 4
		Goto Spawn
	Death:
		"----" A 0 A_PlayerScream
		"----" A 0 A_NoBlocking
		"----" A 0 A_JumpIfInventory(IsCrouching,1,"CrouchDeath")
		"----" A 0 A_Jump(256,"Death1","Death2","Death3")
	Death1:
		P001 ABCDE 6
		P001 F -1
		Stop
	Death2:
		P001 GHIJK 6
		P001 L -1
		Stop
	Death3:
		P001 MNOPQR 5
		P001 S 20
		P001 T -1
		Stop
	CrouchDeath:
		P005 ABCD 5
		P005 E -1
		Stop
	XDeath:
		TNT1 A 5 A_SpawnItem(Q2GibSpawner)
		TNT1 A 5 A_CheckPlayerDone
		Wait
	Crush:
		TNT1 AAAAAAA 0 A_SpawnItemEx(Q2Gib,Random2(40),0,5,Random(0,1),0,2,Random(1,360))
		TNT1 A 0 A_XScream
		TNT1 A 5 A_CheckPlayerDone
		Wait// <- this fixes that byotyful crash that i did'nt noticed before the first release youtu.be/zkFco2XViu0?t=11m4s
	Melee:
		Stop*/
	}
}
/*
Class Q2Major : Q2Grunt
{
Player.DisplayName "Major"
	States
	{
	See:
		MAJR A -1 A_Jump(256,1)
		"----" A 0 A_JumpIfInventory(WeaponIndex,20,"SeeLG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,19,"SeeSNG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,12,"SeePhalanx")
		"----" A 0 A_JumpIfInventory(WeaponIndex,11,"SeeGrenade")
		"----" A 0 A_JumpIfInventory(WeaponIndex,10,"SeeBFG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,9,"SeeRailgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,8,"SeeHyperBlaster")
		"----" A 0 A_JumpIfInventory(WeaponIndex,7,"SeeRocketLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,6,"SeeGrenadeLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,5,"SeeChaingun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,4,"SeeMachinegun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,3,"SeeSuperShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,2,"SeeShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,1,"SeeBlaster")
		Goto SeeShotgun
	}
}

Class Q2Viper : Q2Grunt
{
Player.DisplayName "Viper"
	States
	{
	See:
		VIPR A -1 A_Jump(256,1)
		"----" A 0 A_JumpIfInventory(WeaponIndex,20,"SeeLG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,19,"SeeSNG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,12,"SeePhalanx")
		"----" A 0 A_JumpIfInventory(WeaponIndex,11,"SeeGrenade")
		"----" A 0 A_JumpIfInventory(WeaponIndex,10,"SeeBFG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,9,"SeeRailgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,8,"SeeHyperBlaster")
		"----" A 0 A_JumpIfInventory(WeaponIndex,7,"SeeRocketLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,6,"SeeGrenadeLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,5,"SeeChaingun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,4,"SeeMachinegun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,3,"SeeSuperShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,2,"SeeShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,1,"SeeBlaster")
		Goto SeeShotgun
	}
}

Class Q2Cipher : Q2Grunt
{
Player.DisplayName "Cipher"
    States
	{
	See:
	    CIPE A -1 A_Jump(256,1)
		"----" A 0 A_JumpIfInventory(WeaponIndex,20,"SeeLG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,19,"SeeSNG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,12,"SeePhalanx")
		"----" A 0 A_JumpIfInventory(WeaponIndex,11,"SeeGrenade")
		"----" A 0 A_JumpIfInventory(WeaponIndex,10,"SeeBFG")
		"----" A 0 A_JumpIfInventory(WeaponIndex,9,"SeeRailgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,8,"SeeHyperBlaster")
		"----" A 0 A_JumpIfInventory(WeaponIndex,7,"SeeRocketLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,6,"SeeGrenadeLauncher")
		"----" A 0 A_JumpIfInventory(WeaponIndex,5,"SeeChaingun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,4,"SeeMachinegun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,3,"SeeSuperShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,2,"SeeShotgun")
		"----" A 0 A_JumpIfInventory(WeaponIndex,1,"SeeBlaster")
		Goto SeeShotgun
	}
}*/