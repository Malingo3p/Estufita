Model Q2BulletPuffSmoke
{
	Path "Models/Effects/Smoke"
	Skin 0 "Smoke.png"
	Model 0 "Smoke.md2"
	Scale 0.75 0.75 0.75

	FrameIndex PUFF A 0 0
	FrameIndex PUFF B 0 1
	FrameIndex PUFF C 0 2
	FrameIndex PUFF D 0 3
}
Model Q2BulletPuffFlash
{
	Path "Models/Effects/Flash"
	Skin 0 "Flash.png"
	Model 0 "Flash.md2"
	Scale 1.25 1.25 1.25

	FrameIndex PUFF A 0 0
	FrameIndex PUFF B 0 1
}
Model LightningBeamTrailBase
{
   Path "Models/Misc/beam"
   MODEL 0 "beam.md3"
   Scale 1 1 1.2
   INHERITACTORPITCH

   SKIN 0 "WHITO"
   FrameIndex NULL A 0 0
   SKIN 0 "Beamer.png"
   MODEL 0 "Beamer.md2"
   Scale 2 2 2
   PitchOffset -90
   ROTATING
   Rotation-Speed -15
   FrameIndex NULL B 0 0


	Path "Models/Monsters/Parasite"
	Model 0 "Segment.md2"
	Skin 0 "Segment.png"
	Rotation-Speed 100

	Scale 1 1 2
	FrameIndex NULL C 0 0
}

Model Q2Blaster
{
	Path "Models/Weapons/Blaster"
	Skin 0 "Blaster.png"
	Model 0 "Blaster.md2"
	Scale -1 1 1

	Frame BLS1 A 0 "active01"
	Frame BLS1 B 0 "active02"
	Frame BLS1 C 0 "active03"
	Frame BLS1 D 0 "active04"
	Frame BLS1 E 0 "active05"

	Frame BLS1 F 0 "pow01"
	Frame BLS1 G 0 "pow02"
	Frame BLS1 H 0 "pow03"
	Frame BLS1 I 0 "pow04"

	Frame BLS1 J 0 "putway01"
	Frame BLS1 K 0 "putway02"
	Frame BLS1 L 0 "putway03"

	Frame BLS2 A 0 "idle101"
	Frame BLS2 B 0 "idle103"
	Frame BLS2 C 0 "idle105"
	Frame BLS2 D 0 "idle107"
	Frame BLS2 E 0 "idle109"
	Frame BLS2 F 0 "idle111"
	Frame BLS2 G 0 "idle113"
	Frame BLS2 H 0 "idle115"
	Frame BLS2 I 0 "idle117"
	Frame BLS2 J 0 "idle119"
	Frame BLS2 K 0 "idle121"
	Frame BLS2 L 0 "idle124"

	Frame BLS2 M 0 "idle201"
	Frame BLS2 N 0 "idle204"
	Frame BLS2 O 0 "idle206"
	Frame BLS2 P 0 "idle208"
	Frame BLS2 Q 0 "idle210"
	Frame BLS2 R 0 "idle212"
	Frame BLS2 S 0 "idle214"
	Frame BLS2 T 0 "idlE216"
	Frame BLS2 U 0 "idle218"
	Frame BLS2 V 0 "idle220"

	Skin 0 "g_blaster.png"
	Path "Models/Player/Male"
	Model 0 "w_blaster.md2"
	Scale 2 2 2
	Offset 5 18 20
	PitchOffset -20
	ROTATING

	//FrameIndex PSTL A 0 47
}
Model BlasterProjectile
{
	AngleOffset 180
	Path "Models/Projectiles/Laser"
	Skin 0 "Laser.png"
	Model 0 "Laser.md2"
	Scale 1 2 2
	IGNORETRANSLATION
	PITCHFROMMOMENTUM
	FrameIndex NULL A 0 0
}
Model BlasterProjectileImpact
{
	Path "Models/Effects/Impact"
	Skin 0 "BlasterImpact.png"
	Model 0 "BlasterImpact.md2"
	Scale 0.66 0.66 0.66

	FrameIndex NULL A 0 0
	FrameIndex NULL B 0 1
	FrameIndex NULL C 0 2
	FrameIndex NULL D 0 3

	Scale 0.66 0.66 0.66
	AngleOffset -90
	RollOffset 90

	FrameIndex NULL E 0 0
	FrameIndex NULL F 0 1
	FrameIndex NULL G 0 2
	FrameIndex NULL H 0 3
}
Model Q2Shotgun
{
	Path "Models/Weapons/Shotgun"
	Skin 0 "vshotgun.png"
	Model 0 "vshotgun.md2"
	Scale -1 1 1

	Frame W001 A 0 "active01"
	Frame W001 B 0 "active02"
	Frame W001 C 0 "active03"
	Frame W001 D 0 "active04"
	Frame W001 E 0 "active05"
	Frame W001 F 0 "active06"
	Frame W001 G 0 "active07"
	Frame W001 H 0 "active08"

	Frame W001 I 0 "pow01"
	Frame W001 J 0 "pow02"
	Frame W001 K 0 "pow03"
	Frame W001 L 0 "pow04"
	Frame W001 M 0 "pow05"
	Frame W001 N 0 "pow06"
	Frame W001 O 0 "pow07"
	Frame W001 P 0 "pow08"
	Frame W001 Q 0 "pow09"
	Frame W001 R 0 "pow10"
	Frame W001 S 0 "pow11"

	Frame W001 T 0 "idle01"
	Frame W001 U 0 "idle02"
	Frame W001 V 0 "idle04"
	Frame W001 W 0 "idle06"
	Frame W001 X 0 "idle08"
	Frame W001 Y 0 "idle10"
	Frame W001 Z 0 "idle12"
	Frame W001 [ 0 "idle14"
	Frame W001 \ 0 "idle16"
	Frame W001 ] 0 "idle18"

	Frame W002 A 0 "putway01"
	Frame W002 B 0 "putway02"
	Frame W002 C 0 "putway03"

	Path "Models/Weapons/Shotgun"
	Skin 0 "shotgun.png"
	Model 0 "shotgun.md2"
	Scale 1.25 1.25 1.25
	Offset 0 0 10
	ROTATING

	FrameIndex W002 D 0 0
}
Model Q2SuperShotgun
{
	Path "Models/Weapons/SSG"
	Skin 0 "vSSG.png"
	Model 0 "vSSG.md2"
	Scale -1 1 1

	Frame SSG0 A 0 "active01"
	Frame SSG0 B 0 "active02"
	Frame SSG0 C 0 "active03"
	Frame SSG0 D 0 "active04"
	Frame SSG0 E 0 "active05"
	Frame SSG0 F 0 "active06"
	Frame SSG0 G 0 "active07"

	Frame SSG0 H 0 "pow01"
	Frame SSG0 I 0 "pow02"
	Frame SSG0 J 0 "pow03"
	Frame SSG0 K 0 "pow04"
	Frame SSG0 L 0 "pow05"
	Frame SSG0 M 0 "pow06"
	Frame SSG0 N 0 "pow07"
	Frame SSG0 O 0 "pow08"
	Frame SSG0 P 0 "pow09"
	Frame SSG0 Q 0 "pow10"
	Frame SSG0 R 0 "pow11"

	Frame SSG0 S 0 "putway01"
	Frame SSG0 T 0 "putway02"
	Frame SSG0 U 0 "putway03"
	Frame SSG0 V 0 "putway04"

	Frame SSG1 A 0 "idle01"
	Frame SSG1 B 0 "idle02"
	Frame SSG1 C 0 "idle03"
	Frame SSG1 D 0 "idle04"
	Frame SSG1 E 0 "idle05"
	Frame SSG1 F 0 "idle06"
	Frame SSG1 G 0 "idle07"
	Frame SSG1 H 0 "idle08"
	Frame SSG1 I 0 "idle09"
	Frame SSG1 J 0 "idle10"
	Frame SSG1 K 0 "idle11"
	Frame SSG1 L 0 "idle12"
	Frame SSG1 M 0 "idle13"
	Frame SSG1 N 0 "idle14"
	Frame SSG1 O 0 "idle15"
	Frame SSG1 P 0 "idle16"
	Frame SSG1 Q 0 "idle17"
	Frame SSG1 R 0 "idle18"
	Frame SSG1 S 0 "idle19"
	Frame SSG1 T 0 "idle20"
	Frame SSG1 U 0 "idle21"
	Frame SSG1 V 0 "idle22"
	Frame SSG1 W 0 "idle23"
	Frame SSG1 X 0 "idle24"
	Frame SSG1 Y 0 "idle25"
	Frame SSG1 Z 0 "idle26"
	Frame SSG1 [ 0 "idle27"
	Frame SSG1 \ 0 "idle28"
	Frame SSG1 ] 0 "idle29"
	Frame SSG2 A 0 "idle30"
	Frame SSG2 B 0 "idle31"
	Frame SSG2 C 0 "idle32"
	Frame SSG2 D 0 "idle33"
	Frame SSG2 E 0 "idle34"
	Frame SSG2 F 0 "idle35"
	Frame SSG2 G 0 "idle36"
	Frame SSG2 H 0 "idle37"
	Frame SSG2 I 0 "idle38"
	Frame SSG2 J 0 "idle39"
	Frame SSG2 K 0 "idle40"

	Path "Models/Weapons/SSG"
	Skin 0 "SSG.png"
	Model 0 "SSG.md2"
	Scale 1.25 1.25 1.25
	Offset 0 0 10
	ROTATING

	FrameIndex SGN2 A 0 0
}
Model Q2Machinegun
{
	Path "Models/Weapons/Machinegun"
	Skin 0 "v_machinegun.png"
	Model 0 "v_machinegun.md2"
	Scale -1 1 1
	INTERPOLATEDOUBLEDFRAMES
	Frame MGN0 A 0 "active01"
	Frame MGN0 B 0 "active02"
	Frame MGN0 C 0 "active03"
	Frame MGN0 D 0 "active04"

	Frame MGN0 E 0 "pow01" // Only 2 Frames???... uhh... okay.
	Frame MGN0 F 0 "pow02"

	Frame MGN0 H 0 "idle01"
	Frame MGN0 I 0 "idle02"
	Frame MGN0 J 0 "idle03"
	Frame MGN0 K 0 "idle04"
	Frame MGN0 L 0 "idle05"
	Frame MGN0 M 0 "idle06"
	Frame MGN0 N 0 "idle07"
	Frame MGN0 O 0 "idle08"
	Frame MGN0 P 0 "idle09"
	Frame MGN0 Q 0 "idle10"
	Frame MGN0 R 0 "idle11"
	Frame MGN0 S 0 "idle12"
	Frame MGN0 T 0 "idle13"
	Frame MGN0 U 0 "idle14"
	Frame MGN0 V 0 "idle15"
	Frame MGN0 W 0 "idle16"
	Frame MGN0 X 0 "idle17"
	Frame MGN0 Y 0 "idle18"
	Frame MGN0 Z 0 "idle19"
	Frame MGN0 [ 0 "idle20"
	Frame MGN0 \ 0 "idle21"
	Frame MGN0 ] 0 "idle22"
	Frame MGN1 A 0 "idle23"
	Frame MGN1 B 0 "idle24"
	Frame MGN1 C 0 "idle25"
	Frame MGN1 D 0 "idle26"
	Frame MGN1 E 0 "idle27"
	Frame MGN1 F 0 "idle28"
	Frame MGN1 G 0 "idle29"
	Frame MGN1 H 0 "idle30"
	Frame MGN1 I 0 "idle31"
	Frame MGN1 J 0 "idle32"
	Frame MGN1 K 0 "idle33"
	Frame MGN1 L 0 "idle34"
	Frame MGN1 M 0 "idle35"
	Frame MGN1 N 0 "idle36"
	Frame MGN1 O 0 "idle37"
	Frame MGN1 P 0 "idle38"
	Frame MGN1 Q 0 "idle39"
	Frame MGN1 R 0 "idle40"

	Frame MGN1 S 0 "putway01"
	Frame MGN1 T 0 "putway02"
	Frame MGN1 U 0 "putway03"
	Frame MGN1 V 0 "putway04"

	Path "Models/Weapons/Machinegun"
	Skin 0 "g_machinegun.png"
	Model 0 "g_machinegun.md2"
	Scale 1.25 1.25 1.25
	Offset 0 0 10
	ROTATING

	FrameIndex MGUN A 0 0
}
Model Q2Chaingun
{
	Path "Models/Weapons/Chaingun"
	Skin 0 "v_chaingun.png"
	Model 0 "v_chaingun.md2"
	Scale -1 1 1

	Frame CHG0 A 0 "active01"
	Frame CHG0 B 0 "active02"
	Frame CHG0 C 0 "active03"
	Frame CHG0 D 0 "active04"
	Frame CHG0 E 0 "active05"

	Frame CHG0 F 0 "idle01"

	Frame CHG0 G 0 "putway01"
	Frame CHG0 H 0 "putway02"
	Frame CHG0 I 0 "putway03"

	Frame CHG1 A 0 "pow01"
	Frame CHG1 B 0 "pow02"
	Frame CHG1 C 0 "pow03"
	Frame CHG1 D 0 "pow04"
	Frame CHG1 E 0 "pow05"
	Frame CHG1 F 0 "pow06"
	Frame CHG1 G 0 "pow07"
	Frame CHG1 H 0 "pow08"
	Frame CHG1 I 0 "pow09"
	Frame CHG1 J 0 "pow10"
	Frame CHG1 K 0 "pow11"
	Frame CHG1 L 0 "pow12"
	Frame CHG1 M 0 "pow13"
	Frame CHG1 N 0 "pow14"
	Frame CHG1 O 0 "pow15"
	Frame CHG1 P 0 "pow16"
	Frame CHG1 Q 0 "pow17"
	Frame CHG1 R 0 "pow18"
	Frame CHG1 S 0 "pow19"
	Frame CHG1 T 0 "pow20"
	Frame CHG1 U 0 "pow21"
	Frame CHG1 V 0 "pow22"
	Frame CHG1 W 0 "pow23"
	Frame CHG1 X 0 "pow24"
	Frame CHG1 Y 0 "pow25"
	Frame CHG1 Z 0 "pow26"
	Frame CHG1 \ 0 "pow27"

	Frame CHG2 A 0 "idle02"
	Frame CHG2 B 0 "idle03"
	Frame CHG2 C 0 "idle04"
	Frame CHG2 D 0 "idle05"
	Frame CHG2 E 0 "idle06"
	Frame CHG2 F 0 "idle07"
	Frame CHG2 G 0 "idle08"
	Frame CHG2 H 0 "idle09"
	Frame CHG2 I 0 "idle10"
	Frame CHG2 J 0 "idle11"
	Frame CHG2 K 0 "idle12"
	Frame CHG2 L 0 "idle13"
	Frame CHG2 M 0 "idle14"
	Frame CHG2 N 0 "idle15"
	Frame CHG2 O 0 "idle16"
	Frame CHG2 P 0 "idle17"
	Frame CHG2 Q 0 "idle18"
	Frame CHG2 R 0 "idle19"
	Frame CHG2 S 0 "idle20"
	Frame CHG2 T 0 "idle21"
	Frame CHG2 U 0 "idle22"
	Frame CHG2 V 0 "idle23"
	Frame CHG2 W 0 "idle24"
	Frame CHG2 X 0 "idle25"
	Frame CHG2 Y 0 "idle26"
	Frame CHG2 Z 0 "idle27"
	Frame CHG2 \ 0 "idle28"
	Frame CHG2 [ 0 "idle29"
	Frame CHG2 ] 0 "idle30"

	Path "Models/Weapons/Chaingun"
	Skin 0 "g_chaingun.png"
	Model 0 "g_chaingun.md2"
	Scale 1.25 1.25 1.25
	Offset 0 0 10
	ROTATING

	FrameIndex MGUN A 0 0
}
Model Q2HandGrenade
{
	Path "Models/Weapons/HandGrenade"
	Skin 0 "HandGrenade.png"
	Model 0 "HandGrenade.md2"
	Scale -1 1 1

	Frame GRN0 A 0 "idle01"
	Frame GRN0 B 0 "idle02"
	Frame GRN0 C 0 "idle03"
	Frame GRN0 D 0 "idle04"
	Frame GRN0 E 0 "idle05"
	Frame GRN0 F 0 "idle06"
	Frame GRN0 G 0 "idle07"
	Frame GRN0 H 0 "idle08"
	Frame GRN0 I 0 "idle09"
	Frame GRN0 J 0 "idle10"
	Frame GRN0 K 0 "idle11"
	Frame GRN0 L 0 "idle12"
	Frame GRN0 M 0 "idle13"
	Frame GRN0 N 0 "idle14"
	Frame GRN0 O 0 "idle15"
	Frame GRN0 P 0 "idle16"
	Frame GRN0 Q 0 "idle17"
	Frame GRN0 R 0 "idle18"
	Frame GRN0 S 0 "idle19"
	Frame GRN0 T 0 "idle20"
	Frame GRN0 U 0 "idle21"
	Frame GRN0 V 0 "idle22"
	Frame GRN0 W 0 "idle23"
	Frame GRN0 X 0 "idle24"
	Frame GRN0 Y 0 "idle25"
	Frame GRN0 Z 0 "idle26"
	Frame GRN0 \ 0 "idle27"
	Frame GRN0 [ 0 "idle28"
	Frame GRN0 ] 0 "idle29"
	Frame GRN1 A 0 "idle30"
	Frame GRN1 B 0 "idle31"
	Frame GRN1 C 0 "idle32"
	Frame GRN1 D 0 "idle33"

	Frame GRN1 E 0 "throw01"
	Frame GRN1 F 0 "throw02"//throw3 is missing
	Frame GRN1 G 0 "throw04"
	Frame GRN1 H 0 "throw05"
	Frame GRN1 I 0 "throw06"
	Frame GRN1 J 0 "throw07"
	Frame GRN1 K 0 "throw08"
	Frame GRN1 L 0 "throw09"
	Frame GRN1 M 0 "throw10"
	Frame GRN1 N 0 "throw11"
	Frame GRN1 O 0 "throw12"
	Frame GRN1 P 0 "throw13"
	Frame GRN1 Q 0 "throw14"
	Frame GRN1 R 0 "throw15"
	Frame GRN1 S 0 "throw16"
}
Model Q2HGrenade
{
	Path "Models/Weapons/HandGrenade"
	Skin 0 "Grenade.png"
	Model 0 "Grenade.md2"
	PitchOffset 90
	INHERITACTORPITCH
	Scale 1.2 1.2 1.2
	FrameIndex SGRN A 0 0
}
Model Q2GrenadeLauncher
{
	Path "Models/Weapons/GrenadeLauncher"
	Skin 0 "v_grenadelauncher.png"
	Model 0 "v_grenadelauncher.md2"
	Scale -1 1 1

	Frame GRL0 A 0 "active01"
	Frame GRL0 B 0 "active02"
	Frame GRL0 C 0 "active03"
	Frame GRL0 D 0 "active04"
	Frame GRL0 E 0 "active05"
	Frame GRL0 F 0 "active06"
	Frame GRL0 G 0 "active07"

	Frame GRL0 H 0 "pow01"
	Frame GRL0 I 0 "pow02"
	Frame GRL0 J 0 "pow03"
	Frame GRL0 K 0 "pow04"
	Frame GRL0 L 0 "pow05"
	Frame GRL0 M 0 "pow06"
	Frame GRL0 N 0 "pow07"
	Frame GRL0 O 0 "pow08"
	Frame GRL0 P 0 "pow09"
	Frame GRL0 Q 0 "pow10"
	Frame GRL0 R 0 "pow11"

	Frame GRL0 S 0 "putway01"
	Frame GRL0 T 0 "putway02"
	Frame GRL0 U 0 "putway03"
	Frame GRL0 V 0 "putway04"
	Frame GRL0 W 0 "putway05"

	Frame GRL1 A 0 "idle01"
	Frame GRL1 B 0 "idle02"
	Frame GRL1 C 0 "idle03"
	Frame GRL1 D 0 "idle04"
	Frame GRL1 E 0 "idle05"
	Frame GRL1 F 0 "idle06"
	Frame GRL1 G 0 "idle07"
	Frame GRL1 H 0 "idle08"
	Frame GRL1 I 0 "idle09"
	Frame GRL1 J 0 "idle10"
	Frame GRL1 K 0 "idle11"
	Frame GRL1 L 0 "idle12"
	Frame GRL1 M 0 "idle13"
	Frame GRL1 N 0 "idle14"
	Frame GRL1 O 0 "idle15"
	Frame GRL1 P 0 "idle16"
	Frame GRL1 Q 0 "idle17"
	Frame GRL1 R 0 "idle18"
	Frame GRL1 S 0 "idle19"
	Frame GRL1 T 0 "idle20"
	Frame GRL1 U 0 "idle21"
	Frame GRL1 V 0 "idle22"
	Frame GRL1 W 0 "idle23"
	Frame GRL1 X 0 "idle24"
	Frame GRL1 Y 0 "idle25"
	Frame GRL1 Z 0 "idle26"
	Frame GRL1 [ 0 "idle27"
	Frame GRL1 \ 0 "idle28"
	Frame GRL1 ] 0 "idle29"
	Frame GRL2 A 0 "idle30"
	Frame GRL2 B 0 "idle31"
	Frame GRL2 C 0 "idle32"
	Frame GRL2 D 0 "idle33"
	Frame GRL2 E 0 "idle34"
	Frame GRL2 F 0 "idle35"
	Frame GRL2 G 0 "idle36"
	Frame GRL2 H 0 "idle37"
	Frame GRL2 I 0 "idle38"
	Frame GRL2 J 0 "idle39"
	Frame GRL2 K 0 "idle40"
	Frame GRL2 L 0 "idle41"
	Frame GRL2 M 0 "idle42"
	Frame GRL2 N 0 "idle43"

	Path "Models/Weapons/GrenadeLauncher"
	Skin 0 "g_grenadelauncher.png"
	Model 0 "g_grenadelauncher.md2"
	Scale 1.25 1.25 1.25
	Offset 0 0 10
	ROTATING

	FrameIndex RLAU A 0 0
}
Model Q2Grenade
{
	Path "Models/Projectiles/Grenade"
	Skin 0 "Grenade.png"
	Model 0 "Grenade.md2"
	PitchOffset 90
	INHERITACTORPITCH
	FrameIndex SGRN A 0 0
}
Model Q2RocketLauncher
{
	Path "Models/Weapons/RocketLauncher"
	Skin 0 "v_rocketlauncher.png"
	Model 0 "v_rocketlauncher.md2"
	Scale -1 1 1

	Frame RCK0 A 0 "active01"
	Frame RCK0 B 0 "active02"
	Frame RCK0 C 0 "active03"
	Frame RCK0 D 0 "active04"
	Frame RCK0 E 0 "active05"

	Frame RCK0 F 0 "pow01"
	Frame RCK0 G 0 "pow02"
	Frame RCK0 H 0 "pow03"
	Frame RCK0 I 0 "pow04"
	Frame RCK0 J 0 "pow05"
	Frame RCK0 K 0 "pow06"
	Frame RCK0 L 0 "pow07"
	Frame RCK0 M 0 "pow08"

	Frame RCK0 N 0 "idle01"
	Frame RCK0 O 0 "idle02"
	Frame RCK0 P 0 "idle03"
	Frame RCK0 Q 0 "idle04"
	Frame RCK0 R 0 "idle05"
	Frame RCK0 S 0 "idle06"
	Frame RCK0 T 0 "idle07"
	Frame RCK0 U 0 "idle08"
	Frame RCK0 V 0 "idle09"
	Frame RCK0 W 0 "idle10"
	Frame RCK0 X 0 "idle11"
	Frame RCK0 Y 0 "idle12"
	Frame RCK0 Z 0 "idle13"
	Frame RCK0 [ 0 "idle14"
	Frame RCK0 \ 0 "idle15"
	Frame RCK0 ] 0 "idle16"
	Frame RCK1 A 0 "idle17"
	Frame RCK1 B 0 "idle18"
	Frame RCK1 C 0 "idle19"
	Frame RCK1 D 0 "idle20"
	Frame RCK1 E 0 "idle21"
	Frame RCK1 F 0 "idle22"
	Frame RCK1 G 0 "idle23"
	Frame RCK1 H 0 "idle24"
	Frame RCK1 I 0 "idle25"
	Frame RCK1 J 0 "idle26"
	Frame RCK1 K 0 "idle27"
	Frame RCK1 L 0 "idle28"
	Frame RCK1 M 0 "idle29"
	Frame RCK1 N 0 "idle30"
	Frame RCK1 O 0 "idle31"
	Frame RCK1 P 0 "idle32"
	Frame RCK1 Q 0 "idle33"
	Frame RCK1 R 0 "idle34"
	Frame RCK1 S 0 "idle35"
	Frame RCK1 T 0 "idle36"
	Frame RCK1 U 0 "idle37"
	Frame RCK1 V 0 "idle38"

	Frame RCK1 W 0 "putway01"
	Frame RCK1 X 0 "putway02"
	Frame RCK1 Y 0 "putway03"
	Frame RCK1 Z 0 "putway04"

	Path "Models/Weapons/RocketLauncher"
	Skin 0 "g_rocketLauncher.png"
	Model 0 "g_rocketlauncher.md2"
	Offset 0 0 10
	ROTATING

	FrameIndex RLAU A 0 0
}
Model Q2Rocket
{
	Path "Models/Projectiles/Rocket"
	Skin 0 "Rocket.png"
	Model 0 "Rocket.md2"
	PITCHFROMMOMENTUM
	Scale 1.5 1.5 1.5
	ROTATING
	Rotation-Speed 3
	Rotation-Vector 1 0 0
	FrameIndex MIS1 A 0 0
}
Model Q2HyperBlaster
{
	Path "Models/Weapons/HyperBlaster"
	Skin 0 "v_hyperblaster.png"
	Model 0 "v_hyperblaster.md2"
	Scale -1 1 1

	Frame HYP0 A 0 "active01"
	Frame HYP0 B 0 "active02"
	Frame HYP0 C 0 "active03"
	Frame HYP0 D 0 "active04"
	Frame HYP0 E 0 "active05"
	Frame HYP0 F 0 "active06"
	Frame HYP0 G 0 "putway01"
	Frame HYP0 H 0 "putway02"
	Frame HYP0 I 0 "putway03"
	Frame HYP0 J 0 "putway04"

	Frame HYP1 A 0 "pow11"
	Frame HYP1 B 0 "pow12"
	Frame HYP1 C 0 "pow13"
	Frame HYP1 D 0 "pow14"
	Frame HYP1 E 0 "pow15"
	Frame HYP1 F 0 "pow16"
	Frame HYP1 G 0 "pow17"
	Frame HYP1 H 0 "pow18"
	Frame HYP1 I 0 "pow19"
	Frame HYP1 J 0 "pow20"
	Frame HYP1 K 0 "pow21"
	Frame HYP1 L 0 "pow22"
	Frame HYP1 M 0 "pow23"
	Frame HYP1 N 0 "pow24"
	Frame HYP1 O 0 "pow25"

	Frame HYP2 A 0 "idle01"
	Frame HYP2 B 0 "idle02"
	Frame HYP2 C 0 "idle03"
	Frame HYP2 D 0 "idle04"
	Frame HYP2 E 0 "idle05"
	Frame HYP2 F 0 "idle06"
	Frame HYP2 G 0 "idle07"
	Frame HYP2 H 0 "idle08"
	Frame HYP2 I 0 "idle09"
	Frame HYP2 J 0 "idle10"
	Frame HYP2 K 0 "idle11"
	Frame HYP2 L 0 "idle12"
	Frame HYP2 M 0 "idle13"
	Frame HYP2 N 0 "idle14"
	Frame HYP2 O 0 "idle15"
	Frame HYP2 P 0 "idle16"
	Frame HYP2 Q 0 "idle17"
	Frame HYP2 R 0 "idle18"
	Frame HYP2 S 0 "idle19"
	Frame HYP2 T 0 "idle20"
	Frame HYP2 U 0 "idle21"
	Frame HYP2 V 0 "idle22"
	Frame HYP2 W 0 "idle23"
	Frame HYP2 X 0 "idle24"
	Frame HYP2 Y 0 "idle25"
	Frame HYP2 Z 0 "idle26"
	Frame HYP2 [ 0 "idle27"
	Frame HYP2 \ 0 "idle28"
	Frame HYP2 ] 0 "idle29"

	Path "Models/Weapons/HyperBlaster"
	Skin 0 "g_hyperblaster.png"
	Model 0 "g_hyperblaster.md2"
	Scale 1.1 1.1 1.1
	Offset 0 0 10
	ROTATING

	FrameIndex PLAS A 0 0
}
Model HyperBlasterProjectile
{
	AngleOffset 180
	Path "Models/Projectiles/Laser"
	Skin 0 "Laser.png"
	Model 0 "Laser.md2"
	Scale 1.33 1.33 1.33
	IGNORETRANSLATION
	PITCHFROMMOMENTUM
	FrameIndex NULL A 0 0
}
Model Q2Railgun
{
	Path "Models/Weapons/Railgun"
	Skin 0 "v_railgun.png"
	Model 0 "v_railgun.md2"
	Scale -1 1 1

	Frame RLG0 A 0 "active01"
	Frame RLG0 B 0 "active02"
	Frame RLG0 C 0 "active03"
	Frame RLG0 D 0 "active04"

	Frame RLG0 E 0 "pow01"
	Frame RLG0 F 0 "pow02"
	Frame RLG0 G 0 "pow03"
	Frame RLG0 H 0 "pow04"
	Frame RLG0 I 0 "pow05"
	Frame RLG0 J 0 "pow06"
	Frame RLG0 K 0 "pow07"
	Frame RLG0 L 0 "pow08"
	Frame RLG0 M 0 "pow09"
	Frame RLG0 N 0 "pow10"
	Frame RLG0 O 0 "pow11"
	Frame RLG0 P 0 "pow12"
	Frame RLG0 Q 0 "pow13"
	Frame RLG0 R 0 "pow14"
	Frame RLG0 S 0 "pow15"

	Frame RLG0 T 0 "putway01"
	Frame RLG0 U 0 "putway02"
	Frame RLG0 V 0 "putway03"
	Frame RLG0 W 0 "putway04"
	Frame RLG0 X 0 "putway05"

	Frame RLG1 A 0 "idle01"
	Frame RLG1 B 0 "idle02"
	Frame RLG1 C 0 "idle03"
	Frame RLG1 D 0 "idle04"
	Frame RLG1 E 0 "idle05"
	Frame RLG1 F 0 "idle06"
	Frame RLG1 G 0 "idle07"
	Frame RLG1 H 0 "idle08"
	Frame RLG1 I 0 "idle09"
	Frame RLG1 J 0 "idle10"
	Frame RLG1 K 0 "idle11"
	Frame RLG1 L 0 "idle12"
	Frame RLG1 M 0 "idle13"
	Frame RLG1 N 0 "idle14"
	Frame RLG1 O 0 "idle15"
	Frame RLG1 P 0 "idle16"
	Frame RLG1 Q 0 "idle17"
	Frame RLG1 R 0 "idle18"
	Frame RLG1 S 0 "idle19"
	Frame RLG1 T 0 "idle20"
	Frame RLG1 U 0 "idle21"
	Frame RLG1 V 0 "idle22"
	Frame RLG1 W 0 "idle23"
	Frame RLG1 X 0 "idle24"
	Frame RLG1 Y 0 "idle25"
	Frame RLG1 Z 0 "idle26"
	Frame RLG1 [ 0 "idle27"
	Frame RLG1 \ 0 "idle28"
	Frame RLG1 ] 0 "idle29"
	Frame RLG2 A 0 "idle30"
	Frame RLG2 B 0 "idle31"
	Frame RLG2 C 0 "idle32"
	Frame RLG2 D 0 "idle33"
	Frame RLG2 E 0 "idle34"
	Frame RLG2 F 0 "idle35"
	Frame RLG2 G 0 "idle36"
	Frame RLG2 H 0 "idle37"
	Frame RLG2 I 0 "idle38"

	Path "Models/Weapons/Railgun"
	Skin 0 "g_railgun.png"
	Model 0 "g_railgun.md2"
	Offset 0 0 10
	ROTATING

	FrameIndex PLAS A 0 0
}
Model Q2BFG10K
{
	Path "Models/Weapons/BFG10K"
	Model 0 "vBFG10K.md2"
	Skin 0 "vBFG10K.png"
	Scale -1 1 1

	Frame QBFG A 0 "active03"
	Frame QBFG B 0 "active04"
	Frame QBFG C 0 "active05"
	Frame QBFG D 0 "active06"
	Frame QBFG E 0 "active07"
	Frame QBFG F 0 "active08"
	Frame QBFG G 0 "active09"

	Frame QBFG H 0 "pow01"
	Frame QBFG I 0 "pow02"
	Frame QBFG J 0 "pow03"
	Frame QBFG K 0 "pow04"
	Frame QBFG L 0 "pow05"
	Frame QBFG M 0 "pow06"
	Frame QBFG N 0 "pow07"
	Frame QBFG O 0 "pow08"
	Frame QBFG P 0 "pow09"
	Frame QBFG Q 0 "pow10"
	Frame QBFG R 0 "pow11"
	Frame QBFG S 0 "pow12"
	Frame QBFG T 0 "pow13"
	Frame QBFG U 0 "pow14"
	Frame QBFG V 0 "pow15"
	Frame QBFG W 0 "pow16"
	Frame QBFG X 0 "pow17"
	Frame QBFG Y 0 "pow18"
	Frame QBFG Z 0 "pow19"
	Frame QBF2 A 0 "pow20"
	Frame QBF2 B 0 "pow21"
	Frame QBF2 C 0 "pow22"
	Frame QBF2 D 0 "pow23"

	Frame QBF2 E 0 "idle01"
	Frame QBF2 F 0 "idle02"
	Frame QBF2 G 0 "idle03"
	Frame QBF2 H 0 "idle04"
	Frame QBF2 I 0 "idle05"
	Frame QBF2 J 0 "idle06"
	Frame QBF2 K 0 "idle07"
	Frame QBF2 L 0 "idle08"
	Frame QBF2 M 0 "idle09"
	Frame QBF2 N 0 "idle10"
	Frame QBF2 O 0 "idle11"
	Frame QBF2 P 0 "idle12"
	Frame QBF2 Q 0 "idle13"
	Frame QBF2 R 0 "idle14"
	Frame QBF2 S 0 "idle15"
	Frame QBF2 T 0 "idle16"
	Frame QBF2 U 0 "idle17"
	Frame QBF2 V 0 "idle18"
	Frame QBF2 W 0 "idle19"
	Frame QBF2 X 0 "idle20"
	Frame QBF2 Y 0 "idle21"
	Frame QBF2 Z 0 "idle22"
	Frame QBF3 A 0 "idle23"

	Frame QBF3 B 0 "putway01"
	Frame QBF3 C 0 "putway02"
	Frame QBF3 D 0 "putway03"

	Path "Models/Weapons/BFG10K"
	Model 0 "BFG10K.md2"
	Skin 0 "BFG10K.png"
	Scale 1.25 1.25 1.25
	Offset 0 0 5
	ROTATING
	FrameIndex BFUG A 0 0
}
Model Q1SNG
{
	Path "Models/Weapons/SuperNailgun"
	Model 0 "v_nail2.md2"
	Skin 0 "v_nail2.png"

	Frame SNG1 A 0 "shot1"
	Frame SNG1 B 0 "shot2"
	Frame SNG1 C 0 "shot3"
	Frame SNG1 D 0 "shot4"
	Frame SNG1 E 0 "shot5"
	Frame SNG1 F 0 "shot6"
	Frame SNG1 G 0 "shot7"
	Frame SNG1 H 0 "shot8"
	Frame SNG1 I 0 "shot9"

	Model 0 "g_nail2.md2"
	Skin 0 "g_nail2.png"
	Offset 0 0 5
	ROTATING
	FrameIndex MGUN A 0 0
}
Model SNGNail
{
	Path "Models/Weapons/SuperNailgun"
	Model 0 "spike.md2"
	Skin 0 "spike.png"
	Scale 1 1 1
	PITCHFROMMOMENTUM

	FrameIndex PUFF A 0 0
}
Model Q1LightningGun
{
	Path "Models/Weapons/Thunderbolt"
	Model 0 "v_light.md2"
	Skin 0 "v_light.png"
	NOINTERPOLATION
	Frame THND A 0 "shot1"
	Frame THND B 0 "shot2"
	Frame THND C 0 "shot3"
	Frame THND D 0 "shot4"
	Frame THND E 0 "shot5"

	Model 0 "g_light.md2"
	Skin 0 "g_light.png"
	Offset 0 0 5
	ROTATING
	FrameIndex PLAS A 0 0
}
Model ThunderBoltLightningTrail
{
   Path "Models/Weapons/thunderbolt"
   SKIN 0 "bolt3.png"
   Scale 0.33 0.75 0.75
   PITCHFROMMOMENTUM
   INHERITACTORROLL
   Model 0 "bolt1.md3"
   FrameIndex PLSE B 0 0
   Model 0 "bolt1.md3"
   RollOffset 90
   FrameIndex PLSE C 0 0
   Model 0 "bolt1.md3"
   RollOffset 180
   FrameIndex PLSE D 0 0
   Model 0 "bolt1.md3"
   RollOffset 270
   FrameIndex PLSE E 0 0
}

Model Q2Phalanx
{
	Path "Models/Weapons/Phalanx"
	Model 0 "v_phalanx.md2"
	Skin 0 "v_phalanx.png"
	Scale -1 1 1
	Frame PHA0 A 0 "active_01"
	Frame PHA0 B 0 "active_02"
	Frame PHA0 C 0 "active_03"
	Frame PHA0 D 0 "active_04"
	Frame PHA0 E 0 "active_05"
	Frame PHA0 F 0 "active_06"

	Frame PHA0 G 0 "pow_01"
	Frame PHA0 H 0 "pow_02"
	Frame PHA0 I 0 "pow_03"
	Frame PHA0 J 0 "pow_04"
	Frame PHA0 K 0 "pow_05"
	Frame PHA0 L 0 "pow_06"
	Frame PHA0 M 0 "pow_07"
	Frame PHA0 N 0 "pow_08"
	Frame PHA0 O 0 "pow_09"
	Frame PHA0 P 0 "pow_10"
	Frame PHA0 Q 0 "pow_12"
	Frame PHA0 R 0 "pow_13"
	Frame PHA0 S 0 "pow_14"

	Frame PHA1 A 0 "walk_01"
	Frame PHA1 B 0 "walk_02"
	Frame PHA1 C 0 "walk_03"
	Frame PHA1 D 0 "walk_04"
	Frame PHA1 E 0 "walk_05"
	Frame PHA1 F 0 "walk_06"
	Frame PHA1 G 0 "walk_07"
	Frame PHA1 H 0 "walk_08"
	Frame PHA1 I 0 "walk_09"
	Frame PHA1 J 0 "walk_10"
	Frame PHA1 K 0 "walk_11"
	Frame PHA1 L 0 "walk_12"
	Frame PHA1 M 0 "walk_13"
	Frame PHA1 N 0 "walk_14"
	Frame PHA1 O 0 "walk_15"
	Frame PHA1 P 0 "walk_16"
	Frame PHA1 Q 0 "walk_17"
	Frame PHA1 R 0 "walk_18"
	Frame PHA1 S 0 "walk_19"
	Frame PHA1 T 0 "walk_20"
	Frame PHA1 U 0 "walk_21"
	Frame PHA1 V 0 "walk_22"
	Frame PHA1 W 0 "walk_23"
	Frame PHA1 X 0 "walk_24"
	Frame PHA1 Y 0 "walk_25"
	Frame PHA1 Z 0 "walk_26"
	Frame PHA1 \ 0 "walk_27"
	Frame PHA1 [ 0 "walk_28"
	Frame PHA1 ] 0 "walk_29"
	Frame PHA2 A 0 "walk_30"
	Frame PHA2 B 0 "walk_31"
	Frame PHA2 C 0 "walk_32"
	Frame PHA2 D 0 "walk_33"
	Frame PHA2 E 0 "walk_34"
	Frame PHA2 F 0 "walk_35"
	Frame PHA2 G 0 "walk_36"
	Frame PHA2 H 0 "walk_37"
	Frame PHA2 I 0 "walk_38"
	Frame PHA2 J 0 "walk_39"

	Frame PHA0 T 0 "putaway_01"
	Frame PHA0 U 0 "putaway_02"
	Frame PHA0 V 0 "putaway_03"
	Frame PHA0 W 0 "putaway_04"
	Frame PHA0 X 0 "putaway_05"

	Model 0 "g_phalanx.md2"
	Skin 0 "g_phalanx.png"
	Scale 1.1 1.1 1.1
	ZOffset 15
	ROTATING
	FrameIndex PLAS A 0 0
}
Model IonRipper
{
	Path "Models/Weapons/IonRIpper"
	Model 0 "v_ripper.md2"
	Skin 0 "v_ripper.png"
	Scale -1 1 1

	Frame RIP0 A 0 "active_01"
	Frame RIP0 B 0 "active_02"
	Frame RIP0 C 0 "active_03"
	Frame RIP0 D 0 "active_04"
	Frame RIP0 E 0 "active_05"

	Frame RIP0 F 0 "pow_01"
	Frame RIP0 G 0 "pow_02"

	Frame RIP0 H 0 "idle_01"
	Frame RIP1 A 0 "idle_02"
	Frame RIP1 B 0 "idle_03"
	Frame RIP1 C 0 "idle_04"
	Frame RIP1 D 0 "idle_05"
	Frame RIP1 E 0 "idle_06"
	Frame RIP1 F 0 "idle_07"
	Frame RIP1 G 0 "idle_08"
	Frame RIP1 H 0 "idle_09"
	Frame RIP1 I 0 "idle_10"
	Frame RIP1 J 0 "idle_11"
	Frame RIP1 K 0 "idle_12"
	Frame RIP1 L 0 "idle_13"
	Frame RIP1 M 0 "idle_14"
	Frame RIP1 N 0 "idle_15"
	Frame RIP1 O 0 "idle_16"
	Frame RIP1 P 0 "idle_17"
	Frame RIP1 Q 0 "idle_18"
	Frame RIP1 R 0 "idle_19"
	Frame RIP1 S 0 "idle_20"
	Frame RIP1 T 0 "idle_21"
	Frame RIP1 U 0 "idle_22"
	Frame RIP1 V 0 "idle_23"
	Frame RIP1 W 0 "idle_24"
	Frame RIP1 X 0 "idle_25"
	Frame RIP1 Y 0 "idle_26"
	Frame RIP1 Z 0 "idle_27"
	Frame RIP1 [ 0 "idle_28"
	Frame RIP1 ] 0 "idle_29"
	Frame RIP1 \ 0 "idle_30"

	Frame RIP2 A 0 "putaway_01"
	Frame RIP2 B 0 "putaway_02"
	Frame RIP2 C 0 "putaway_03"

	Model 0 "g_ripper.md2"
	Skin 0 "g_ripper.png"
	Scale 1.1 1.1 1.1
	ZOffset 15
	ROTATING
	FrameIndex PLAS A 0 0
}
Model IonRipperProjectile
{
	Path "Models/Projectiles/Boomerang"
	Skin 0 "Boo_post.png"
	Model 0 "Boomerang.md2"
	Scale 1.5 1.5 1.5
	IGNORETRANSLATION
	PITCHFROMMOMENTUM
	FrameIndex NULL A 0 0
}

Model Q2PlasmaBeamer
{
	Path "Models/Weapons/Beamer"
	Model 0 "v_beamer.md2"
	Skin 0 "v_beamer.png"
	Scale -1 1 1

	Frame BEM0 A 0 "active01"
	Frame BEM0 B 0 "active02"
	Frame BEM0 C 0 "active03"
	Frame BEM0 D 0 "active04"
	Frame BEM0 E 0 "active05"
	Frame BEM0 F 0 "active06"
	Frame BEM0 G 0 "active07"
	Frame BEM0 H 0 "active08"
	Frame BEM0 I 0 "active09"

	Skin 0 "v_beamer2.png"
	Frame BEM0 J 0 "idle01"
	Frame BEM0 K 0 "pow01"
	Frame BEM0 L 0 "pow01a"
	Frame BEM0 M 0 "pow01b"
	Frame BEM0 N 0 "pow01c"
	Skin 0 "v_beamer.png"

	Frame BEM1 A 0 "idle01"
	Frame BEM1 B 0 "idle02"
	Frame BEM1 C 0 "idle03"
	Frame BEM1 D 0 "idle04"
	Frame BEM1 E 0 "idle05"
	Frame BEM1 F 0 "idle06"
	Frame BEM1 G 0 "idle07"
	Frame BEM1 H 0 "idle08"
	Frame BEM1 I 0 "idle09"
	Frame BEM1 J 0 "idle10"
	Frame BEM1 K 0 "idle11"
	Frame BEM1 L 0 "idle12"
	Frame BEM1 M 0 "idle13"
	Frame BEM1 N 0 "idle14"
	Frame BEM1 O 0 "idle15"
	Frame BEM1 P 0 "idle16"
	Frame BEM1 Q 0 "idle17"
	Frame BEM1 R 0 "idle18"
	Frame BEM1 S 0 "idle19"
	Frame BEM1 T 0 "idle20"
	Frame BEM1 U 0 "idle21"
	Frame BEM1 V 0 "idle22"
	Frame BEM1 W 0 "idle23"
	Frame BEM1 X 0 "idle24"
	Frame BEM1 Y 0 "idle25"
	Frame BEM1 Z 0 "idle26"
	Frame BEM1 [ 0 "idle27"
	Frame BEM1 ] 0 "idle28"
	Frame BEM1 \ 0 "idle29"
	Frame BEM0 Z 0 "idle30"

	Frame BEM0 O 0 "putway01"
	Frame BEM0 P 0 "putway02"
	Frame BEM0 Q 0 "putway03"
	Frame BEM0 R 0 "putway04"
	Frame BEM0 S 0 "putway05"


	Model 0 "g_beamer.md2"
	Skin 0 "g_beamer.png"
	Scale .8 .8 .8
	ZOffset 12
	ROTATING
	FrameIndex PLAS A 0 0
}

Model Q2Trapito
{
	Path "Models/Weapons/Trap"
	Model 0 "v_trap.md2"
	Skin 0 "v_trap.png"
	Scale -1 1 1

	Frame TRA0 A 0 "active_01"
	Frame TRA0 B 0 "active_02"
	Frame TRA0 C 0 "active_03"
	Frame TRA0 D 0 "active_04"
	Frame TRA0 E 0 "active_05"
	Frame TRA0 F 0 "active_06"
	Frame TRA0 G 0 "active_07"
	Frame TRA0 H 0 "active_08"
	Frame TRA0 I 0 "active_09"
	Frame TRA0 J 0 "active_10"
	Frame TRA0 K 0 "active_11"

	Frame TRA0 L 0 "pow_01"
	Frame TRA0 M 0 "pow_02"
	Frame TRA0 N 0 "pow_03"
	Frame TRA0 O 0 "pow_04"
	Frame TRA0 P 0 "hold_01"

	Frame TRA1 A 0 "idle_01"
	Frame TRA1 B 0 "idle_02"
	Frame TRA1 C 0 "idle_03"
	Frame TRA1 D 0 "idle_04"
	Frame TRA1 E 0 "idle_05"
	Frame TRA1 F 0 "idle_06"
	Frame TRA1 G 0 "idle_07"
	Frame TRA1 H 0 "idle_08"
	Frame TRA1 I 0 "idle_09"
	Frame TRA1 J 0 "idle_10"
	Frame TRA1 K 0 "idle_11"
	Frame TRA1 L 0 "idle_12"
	Frame TRA1 M 0 "idle_13"
	Frame TRA1 N 0 "idle_14"
	Frame TRA1 O 0 "idle_15"
	Frame TRA1 P 0 "idle_16"
	Frame TRA1 Q 0 "idle_17"
	Frame TRA1 R 0 "idle_18"
	Frame TRA1 S 0 "idle_19"
	Frame TRA1 T 0 "idle_20"
	Frame TRA1 U 0 "idle_21"
	Frame TRA1 V 0 "idle_22"
	Frame TRA1 W 0 "idle_23"
	Frame TRA1 X 0 "idle_24"
	Frame TRA1 Y 0 "idle_25"
	Frame TRA1 Z 0 "idle_26"
	Frame TRA1 [ 0 "idle_27"
	Frame TRA1 ] 0 "idle_28"
	Frame TRA1 \ 0 "idle_29"
	Frame TRA0 X 0 "idle_30"
	Frame TRA0 Y 0 "idle_31"
	Frame TRA0 Z 0 "idle_32"

	Model 0 "g_trap.md2"
	Skin 0 "g_trap.png"
	Scale 1.1 1.1 1.1
	ZOffset 20
	ROTATING
	FrameIndex RBOX A 0 0
}
Model Q2Trapo
{
	Path "Models/Weapons/Trap"
	Model 0 "z_trap.md2"
	Skin 0 "g_trap.png"
	Scale 1 1 1
	//ZOffset 15
	FrameIndex CELL B 0 1
	FrameIndex CELL C 0 2
	FrameIndex CELL D 0 3
	FrameIndex CELL E 0 4
	FrameIndex CELL F 0 0
	ROTATING
	Rotation-Speed 6
	FrameIndex CELL A 0 0
}
Model TrapHealth
{
	Path "Models/Weapons/Trap"
	Model 0 "traphealth.md2"
	Skin 0 "traphealth.png"
	Scale 1 1 1
	ZOffset 15
	FrameIndex BON1 A 0 0
}

Model Q2EFTRifle
{
	Path "Models/Weapons/EftRifle"
	Skin 0 "vEftRifle.png"
	Model 0 "vEftRifle.md2"
	Scale -1 1 1

	Frame EFTA A 0 "active01"
	Frame EFTA B 0 "active02"
	Frame EFTA C 0 "active03"
	Frame EFTA D 0 "active04"
	Frame EFTA E 0 "active05"

	Frame EFTP A 0 "pow01a"
	Frame EFTP B 0 "pow02"

	Frame EFTI A 0 "idle101"
	Frame EFTI B 0 "idle102"
	Frame EFTI C 0 "idle103"
	Frame EFTI D 0 "idle104"
	Frame EFTI E 0 "idle105"
	Frame EFTI F 0 "idle106"
	Frame EFTI G 0 "idle107"
	Frame EFTI H 0 "idle108"
	Frame EFTI I 0 "idle109"
	Frame EFTI J 0 "idle110"
	Frame EFTI K 0 "idle111"
	Frame EFTI L 0 "idle112"
	Frame EFTI M 0 "idle113"
	Frame EFTI N 0 "idle114"
	Frame EFTI O 0 "idle115"
	Frame EFTI P 0 "idle116"
	Frame EFTI Q 0 "idle117"
	Frame EFTI R 0 "idle118"
	Frame EFTI S 0 "idle119"
	Frame EFTI T 0 "idle120"
	Frame EFTI U 0 "idle121"
	Frame EFTI V 0 "idle122"
	Frame EFTI W 0 "idle123"
	Frame EFTI X 0 "idle124"
	Frame EFTI Y 0 "idle125"
	Frame EFTI Z 0 "idle126"
	Frame EFT1 A 0 "idle127"
	Frame EFT1 B 0 "idle128"
	Frame EFT1 C 0 "idle129"
	Frame EFT1 D 0 "idle130"

	Frame EFTW A 0 "putway01"
	Frame EFTW B 0 "putway02"
	Frame EFTW C 0 "putway03"
	Frame EFTW D 0 "putway04"

	Path "Models/Weapons/EftRifle"
	Skin 0 "EftRifle.png"
	Model 0 "EftRifle.md2"
	Scale 1.25 1.25 1.25
	Offset 0 0 10
	ROTATING

	FrameIndex EFTR A 0 0
}