
;Implements a new attack type for non-gravity harps
;Adds Double Hand and Magic Sword support to some more weapon types
;Save space via some use of utility routines


;Attack type 2F (Harps, was Unused)
;Bells damage + status, for non-gravity harps
;also requires changes to the bell damage formula to deal damage
;Params: 	
;		$57 = Attack Power Override if set
;		$58 = Status Chance 
;		$59 = Status 2
Attack2F:
	JSR Attack39		;Vanilla Bell attack routine
	LDA AtkMissed		;check for miss (only happens on void)
	BNE .Ret
	LDA Param2
	STA Param1		;HitMagic expects hit chance in Param 1
	JSR HitMagic
	JMP Attack07_Status	;Vanilla Gravity/Harp routine, status portion
.Ret	RTS

;Attack Type 30 (Fists)
;Tweaks Adds Jump and Magic Sword modifiers (Blazing Fists are cool)
;Param1: Crit%
Attack30:
	JSR SetHit100andTargetEvade				;C2/6EBC: 20 47 7C     JSR $7C47  (Hit = 100, Evade = Evade)
	JSR HitPhysical						;C2/6EBF: 20 BE 7E     JSR $7EBE  (Hit Determination for physical)
	LDA AtkMissed						;C2/6EC2: A5 56        LDA $56
	BEQ .Hit						;C2/6EC4: F0 05        BEQ $6ECB
	JMP PhysMiss
.Hit	JSR FistDamage 						;C2/6ECB: 20 3E 80     JSR $803E  (Fists Damage Formula)
	JSR BackRowMod 						;C2/6ECE: 20 9B 83     JSR $839B  (Check Back Row Modifications)
	JSR CheckJump
	JSR CommandMod 						;C2/6ED1: 20 BD 83     JSR $83BD  (Check for Command Modifiers)
	JSR TargetStatusModPhys					;C2/6ED4: 20 12 85     JSR $8512  (Check Target Status Effect Modifiers to Physical Damage)
	JSR AttackerStatusModPhys				;C2/6ED7: 20 33 85     JSR $8533  (Check Attacker Status Effect Modifiers to Physical Damage)
	JSR CheckRuneEdge
	JSR MagicSwordMod
	JSR CheckCrit 						;C2/6EDA: 20 DF 87     JSR $87DF  (Check for Critical)
	JMP StandardMSwordFinish	

;Attack Type 31 (Swords)
;Tweaks: No gameplay changes, just using utility routines to save space
;Param1: Element
;Param2/3: Proc% and Proc, not handled here

Attack31:
	JSR SetHit100andTargetEvade					
	JSR HitPhysical							
	LDA AtkMissed							
	BEQ .Hit
	JMP PhysMiss
.Hit	JSR SwordDamage							
	JSR BackRowMod							
	JSR StandardMSwordMods	
	JSR PhysElement					
	JMP StandardMSwordFinish	

;Attack Type 32 (Knives)
;Tweak Adding Jump
;Param1: Element
;Param2/3: Proc% and Proc, not handled here
Attack32:
	JSR SetHit100andHalfTargetEvade					;C2/6F1E: 20 53 7C     JSR $7C53  Hit = 100%, Evade = Evade/2
	JSR HitPhysical							;C2/6F21: 20 BE 7E     JSR $7EBE  Hit% Determination for physical
	LDA AtkMissed				
	BEQ .Hit
	JMP PhysMiss
.Hit	JSR KnifeDamage							;C2/6F28: 20 D4 80     JSR $80D4  (Knives Damage Formula)
	JSR CheckJump
	JSR BackRowMod							;C2/6F2B: 20 9B 83     JSR $839B  (Check Back Row Modifications)
	JSR CommandMod 							;C2/6F2E: 20 BD 83     JSR $83BD  (Check for Command Modifiers)
	JSR TargetStatusModPhys						;C2/6F31: 20 12 85     JSR $8512  (Check Target Status Effect Modifiers to Physical Damage)
	JSR AttackerStatusModPhys					;C2/6F34: 20 33 85     JSR $8533  (Check Attacker Status Effect Modifiers to Physical Damage)
	JSR CheckRuneEdge
	JSR MagicSwordMod						;C2/6F37: 20 84 86     JSR $8684  (Check Magic Sword Modifiers)
	JSR PhysElement	
	JMP StandardMSwordFinish	
.Ret	RTS 								;C2/6F57: 60           RTS 

;Attack Type 33 (Spears)
;Tweaks: Adding Double Hand and Magic Sword
;Param1: Element
;Param2/3: Proc% and Proc, not handled here
Attack33:
	JSR SetHit100andTargetEvade 					
	JSR HitPhysical  						
	LDA AtkMissed							
	BEQ .Hit
	JMP PhysMiss
.Hit	JSR SwordDamage
	JSR BackRowMod 						
	JSR StandardMSwordMods	
	JSR PhysElement					
	JMP StandardMSwordFinish	

;Attack Type 34 (Axes)
;Tweaks: Adding Magic Sword and Jump
;Param1: Hit%
;Param2/3: Proc% and Proc, not handled here
Attack34:
	JSR SetHitParam1andTargetEvade_Dupe				
	JSR HitPhysical							
	LDA AtkMissed							
	BEQ .Hit	
	JMP PhysMiss
.Hit	JSR AxeDamage							
	JSR BackRowMod							
	JSR StandardMSwordMods				
	JMP StandardMSwordFinish							

;Attack Type 37 (Katanas)
;Tweaks: Adding Magic Sword and Jump
;Param1: Crit%
;Param2/3: Proc% and Proc, not handled here
Attack37:
	JSR SetHit100andTargetEvade 					
	JSR HitPhysical 						
	LDA AtkMissed							
	BEQ .Hit
	JMP PhysMiss
.Hit	JSR SwordDamage							
	JSR BackRowMod	
	JSR StandardMSwordMods					
	JSR CheckCrit
	JMP StandardMSwordFinish	

;Attack Type 3A (Long Reach Axes)
;Tweaks: Adding Magic Sword and Jump
;Param1: Hit%
;Param2/3: Proc% and Proc, not handled here
Attack3A:
	JSR SetHitParam1andTargetEvade_Dupe				
	JSR HitPhysical							
	LDA AtkMissed							
	BNE .Hit							
	JMP PhysMiss
.Hit	JSR AxeDamage
	JSR StandardMSwordMods				
	JMP StandardMSwordFinish
	
;Attack Type 3C (Rune Weapons)
;Tweaks: Adding Magic Sword and Jump
;Param1: Hit%
;Param2: Rune Damage Boost
;Param3: Rune MP Cost
Attack3C:
	JSR SetHitParam1andTargetEvade_Dupe				
	JSR HitPhysical							
	LDA AtkMissed							
	BEQ .Hit
	JMP PhysMiss	
.Hit	JSR AxeDamage							
	JSR RuneMod							
	JSR BackRowMod
	JSR StandardMSwordMods	
	JMP StandardMSwordFinish					

;Attack Type 64 (Chicken Knife)
;Tweaks: Adding Jump
;Param2/3: Proc% and Proc, not handled here
Attack64:
	JSR SetHit100andHalfTargetEvade					;C2/7774: 20 53 7C     JSR $7C53  (Hit = 100, Evade = Evade/2)
	JSR HitPhysical							;C2/7777: 20 BE 7E     JSR $7EBE  (Hit Determination for physical)
	LDA AtkMissed							;C2/777A: A5 56        LDA $56						
	BEQ .Hit
	JMP PhysMiss	
.Hit	JSR ChickenDamage						;C2/777E: 20 26 86     JSR $8626  (Chicken Knife Damage formula)
	JSR BackRowMod							;C2/7781: 20 9B 83     JSR $839B  (Back Row Modifications to Damage)
	JSR CheckJump
	JSR CommandMod							;C2/7784: 20 BD 83     JSR $83BD  (Command Modifiers to Damage)
	JSR TargetStatusModPhys						;C2/7787: 20 12 85     JSR $8512  (Target Status Effect Modifiers to Damage)
	JSR AttackerStatusModPhys					;C2/778A: 20 33 85     JSR $8533  (Attacker Status Effect Modifiers to Damage)
	JSR CheckRuneEdge
	JSR MagicSwordMod						;C2/778D: 20 84 86     JSR $8684  (Magic Sword Modifiers)
	JMP StandardMSwordFinish	
.Ret	RTS 			;**optimize, get rid of this		;C2/77A3: 60           RTS 

;Attack Type 6E (Brave Blade)
Attack6E:
	JSR SetHit100andTargetEvade
	JSR HitPhysical							
	LDA AtkMissed								
	BEQ .Hit
	JMP PhysMiss	
.Hit	JSR BraveDamage							
	JSR BackRowMod 							
	JSR StandardMSwordMods
	JSR StandardMSwordFinish
.Ret	RTS 								

;Attack Type 73 (Spears Strong vs. Creature)
;Tweaks: Adding Magic Sword
;Param1: Creature Type
Attack73:
	JSR SetHit100andTargetEvade					
	JSR HitPhysical							
	LDA AtkMissed							
	BEQ .Hit
	JMP PhysMiss	
.Hit	JSR SwordDamage
	JSR BackRowMod			
	JSR StandardMSwordMods		
	JSR CheckCreatureCrit
	JMP StandardMSwordFinish	
	
;Check for Jump
;**optimize: save some bytes by shifting in 8 bit mode to avoid mode switches
CheckJump:
	LDX AttackerOffset			;
	LDA CharStruct.CmdStatus,X	;
	AND #$10					;
	BEQ .NoJump 				;(If Attacker is Not Jumping)
	REP #$20					;	
	LDA Attack					;Damage = Damage		
	ASL           				;Damage = Damage * 2
	CLC 						;		
	ADC Attack    				;Damage = Damage + (Damage * 2)
	LSR           				;Damage = (Damage + (Damage * 2))/2
	STA Attack					;
	TDC 						;
	SEP #$20					;
.NoJump		RTS 				;

CheckRuneEdge:
	LDX AttackerOffset				;
	LDA CharStruct.Passives1,X		;Load Passives
	AND #$08    					;(We're using the bit for Dash)
	BEQ .Ret
	REP #$20						;
	LDX AttackerOffset				;
	LDA CharStruct.CurMP,X			;
	CMP #$0005						;Can we pay the 5 MP?
	BCC .Abort   					;not enough MP? Abort
	SEC 							;
	SBC #$0005						;(Subtract 5 MP)
	STA CharStruct.CurMP,X			;
	CLC 							;
	LDA Attack						;Load Current Attack
	ADC #$000A						;Add the bonus 10 damange
	STA Attack     					;Store
	TDC 							;
	SEP #$20						;
	LDA MagicPower   				;(Magic Power)
	JSR StatTimesLevel				;Stat * Level, returns in 16 bit mode
	JSR ShiftDivide_128				;M = (Level * Magic Power)/128
	CLC 							;
	ADC M							;
	STA M 							;(M = M + (Level * Magic Power)/128)
	TDC 							;
	SEP #$20						;
	INC Crit						;
	RTS 							;
.Abort	TDC 						;
	SEP #$20						;
.Ret	RTS 						;



;Utility Routines

PhysMiss:
	LDA #$80	
	STA AtkMissed	
.Ret	RTS 		

StandardMSwordFinish:
	LDA TargetDead			
	BNE PhysMiss_Ret		;borrowing RTS here to save a byte		
	LDA AtkMissed			
	BEQ .Hit
	JMP PhysMiss	
.Hit	JSR CalcFinalDamageMSword	
	JMP ApplyMSwordStatus
	
PhysElement:
	LDA Param1							
	STA AtkElement							
	JSR ElementDamageModPhys
	RTS		
	
StandardMSwordMods:										
	JSR CheckJump
	JSR CommandMod							
	JSR DoubleGripMod				
	JSR TargetStatusModPhys						
	JSR AttackerStatusModPhys
	JSR CheckRuneEdge							
	JSR MagicSwordMod
	RTS

