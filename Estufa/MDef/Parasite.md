Model Q2Parasite
{
	Path "Models/Monsters/Parasite"
	Model 0 "Parasite.md2"
	Skin 0 "Parasite.png"
	Scale 1.25 1.25 1.25
	Offset 0 0 25
	
	Frame PRT0 A 0 "stand01"
	Frame PRT0 B 0 "stand02"
	Frame PRT0 C 0 "stand03"
	Frame PRT0 D 0 "stand04"
	Frame PRT0 E 0 "stand05"
	Frame PRT0 F 0 "stand06"
	Frame PRT0 G 0 "stand07"
	Frame PRT0 H 0 "stand08"
	Frame PRT0 I 0 "stand18"
	Frame PRT0 J 0 "stand19"
	Frame PRT0 K 0 "stand20"
	Frame PRT0 L 0 "stand21"
	Frame PRT0 M 0 "stand22"
	Frame PRT0 N 0 "stand23"
	Frame PRT0 O 0 "stand24"
	Frame PRT0 P 0 "stand25"
	Frame PRT0 Q 0 "stand26"
	Frame PRT0 R 0 "stand27"
	Frame PRT0 S 0 "stand28"
	Frame PRT0 T 0 "stand29"
	Frame PRT0 U 0 "stand30"
	Frame PRT0 V 0 "stand31"
	Frame PRT0 W 0 "stand32"
	Frame PRT0 X 0 "stand33"
	Frame PRT0 Y 0 "stand34"
	Frame PRT0 Z 0 "stand35"
	
	Frame PRT1 A 0 "run01"
	Frame PRT1 B 0 "run02"
	Frame PRT1 C 0 "run03"
	Frame PRT1 D 0 "run04"
	Frame PRT1 E 0 "run05"
	Frame PRT1 F 0 "run06"
	Frame PRT1 G 0 "run07"
	Frame PRT1 H 0 "run08"
	Frame PRT1 I 0 "run09"
	Frame PRT1 J 0 "run10"
	Frame PRT1 K 0 "run11"
	Frame PRT1 L 0 "run12"
	Frame PRT1 M 0 "run13"
	Frame PRT1 N 0 "run14"
	Frame PRT1 O 0 "run15"
	
	Frame PRT2 A 0 "drain01"
	Frame PRT2 B 0 "drain02"
	Frame PRT2 C 0 "drain03"
	Frame PRT2 D 0 "drain04"
	Frame PRT2 E 0 "drain05"
	Frame PRT2 F 0 "drain06"
	Frame PRT2 G 0 "drain07"
	Frame PRT2 H 0 "drain08"
	Frame PRT2 I 0 "drain09"
	Frame PRT2 J 0 "drain10"
	Frame PRT2 K 0 "drain11"
	Frame PRT2 L 0 "drain12"
	Frame PRT2 M 0 "drain13"
	Frame PRT2 N 0 "drain14"
	Frame PRT2 O 0 "drain15"
	Frame PRT2 P 0 "drain16"
	Frame PRT2 Q 0 "drain17"
	Frame PRT2 R 0 "drain18"

	Frame PRT3 A 0 "pain101"
	Frame PRT3 B 0 "pain102"
	Frame PRT3 C 0 "pain103"
	Frame PRT3 D 0 "pain104"
	Frame PRT3 E 0 "pain105"
	Frame PRT3 F 0 "pain106"
	Frame PRT3 G 0 "pain107"
	Frame PRT3 H 0 "pain108"
	Frame PRT3 I 0 "pain109"
	Frame PRT3 J 0 "pain110"
	Frame PRT3 K 0 "pain111"
	
	Skin 0 "Parasiteb.png"
	Frame PRT3 L 0 "death101"
	Frame PRT3 M 0 "death102"
	Frame PRT3 N 0 "death103"
	Frame PRT3 O 0 "death104"
	Frame PRT3 P 0 "death105"
	Frame PRT3 Q 0 "death106"
	Frame PRT3 R 0 "death107"
}
Model ParasiteProjectileSegment
{
	Path "Models/Monsters/Parasite"
	Model 0 "Segment.md2"
	Skin 0 "Segment.png"
	Scale 0.66 1 1
	PITCHFROMMOMENTUM
	
	FrameIndex NULL A 0 0
	RollOffset 45
	FrameIndex NULL B 0 0
	RollOffset 90
	FrameIndex NULL C 0 0
	RollOffset 135
	FrameIndex NULL D 0 0
	RollOffset 180
}