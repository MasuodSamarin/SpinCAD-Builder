/*
 * generated by Xtext
 */
package com.holycityaudio.spincad.generator

//import com.google.inject.Inject 
import com.holycityaudio.spincad.spinCAD.SpinElement
import com.holycityaudio.spincad.spinCAD.Equate
import com.holycityaudio.spincad.spinCAD.Instruction
import com.holycityaudio.spincad.spinCAD.Mem
import com.holycityaudio.spincad.spinCAD.Program
import com.holycityaudio.spincad.spinCAD.AudioInput
import com.holycityaudio.spincad.spinCAD.AudioOutput
import com.holycityaudio.spincad.spinCAD.ControlOutput
import com.holycityaudio.spincad.spinCAD.ControlInput
import com.holycityaudio.spincad.spinCAD.InputPin
import com.holycityaudio.spincad.spinCAD.Macro
import com.holycityaudio.spincad.spinCAD.Pin
import com.holycityaudio.spincad.spinCAD.Offset
import com.holycityaudio.spincad.spinCAD.IsPinConnected
import com.holycityaudio.spincad.spinCAD.IsElse
import com.holycityaudio.spincad.spinCAD.IsEndif
import com.holycityaudio.spincad.spinCAD.GetInputDefault
import com.holycityaudio.spincad.spinCAD.SetOutputPin
import com.holycityaudio.spincad.spinCAD.GetBaseAddress
import com.holycityaudio.spincad.spinCAD.GetDelayScaleControl
import java.awt.Label
import com.holycityaudio.spincad.spinCAD.Absa
import com.holycityaudio.spincad.spinCAD.And
import com.holycityaudio.spincad.spinCAD.ChorusReadDelay
import com.holycityaudio.spincad.spinCAD.ChorusReadValue
import com.holycityaudio.spincad.spinCAD.Clr
import com.holycityaudio.spincad.spinCAD.Exp
import com.holycityaudio.spincad.spinCAD.Jam
import com.holycityaudio.spincad.spinCAD.Ldax
import com.holycityaudio.spincad.spinCAD.LoadRampLFO
import com.holycityaudio.spincad.spinCAD.LoadSinLFO
import com.holycityaudio.spincad.spinCAD.Or
import com.holycityaudio.spincad.spinCAD.Not
import com.holycityaudio.spincad.spinCAD.Skip
import com.holycityaudio.spincad.spinCAD.Xor
import com.holycityaudio.spincad.spinCAD.WriteRegisterHighshelf
import com.holycityaudio.spincad.spinCAD.WriteRegisterLowshelf
import com.holycityaudio.spincad.spinCAD.WriteRegister
import com.holycityaudio.spincad.spinCAD.WriteDelay
import com.holycityaudio.spincad.spinCAD.WriteAllpass
import com.holycityaudio.spincad.spinCAD.ScaleOffset
import com.holycityaudio.spincad.spinCAD.ReadRegisterFilter
import com.holycityaudio.spincad.spinCAD.ReadRegister
import com.holycityaudio.spincad.spinCAD.ReadDelay
import com.holycityaudio.spincad.spinCAD.ReadDelayPointer
import com.holycityaudio.spincad.spinCAD.Log
import com.holycityaudio.spincad.spinCAD.Maxx
import com.holycityaudio.spincad.spinCAD.Mulx
import com.holycityaudio.spincad.spinCAD.Inst_B15_S1_9

class SpinCADBlockGenerator {
 
def codeGenerate(String blockName, Program pr) {
'''
/* SpinCAD Designer - DSP Development Tool for the Spin FV-1 
 * «blockName»CADBlock.java
 * Copyright (C)2013 - Gary Worsham 
 * Based on ElmGen by Andrew Kilpatrick 
 * 
 *   This program is free software: you can redistribute it and/or modify 
 *   it under the terms of the GNU General Public License as published by 
 *   the Free Software Foundation, either version 3 of the License, or 
 *   (at your option) any later version. 
 * 
 *   This program is distributed in the hope that it will be useful, 
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 *   GNU General Public License for more details. 
 * 
 *   You should have received a copy of the GNU General Public License 
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 *     
 */ 
		package com.holycityaudio.SpinCAD.CADBlocks;
	
		import com.holycityaudio.SpinCAD.SpinCADBlock;
		import com.holycityaudio.SpinCAD.SpinCADPin;
		import com.holycityaudio.SpinCAD.SpinFXBlock;
 		import com.holycityaudio.SpinCAD.ControlPanel.«blockName+"ControlPanel"»;
		
		public class «blockName+"CADBlock"» extends SpinCADBlock {

			private static final long serialVersionUID = 1L;
			
			«FOR SpinElement e : pr.elements»
				«switch e {
					Equate:{genEquate(e)}
				}»
			«ENDFOR»

			public «blockName+"CADBlock"»(int x, int y) {
				super(x, y);
				controlPanelImplemented = true;
				setName("«pr.name»");	
				// Iterate through pin definitions and allocate or assign as needed
				«FOR Pin p : pr.pins»
					«switch p {
						AudioInput:{genAudioInput(p)}
						AudioOutput:{genAudioOutput(p)}
						ControlOutput:{genControlOutput(p)}
						ControlInput:{genControlInput(p)}
					}»
				«ENDFOR»
			}
		
			// In the event there are parameters editable by control panel
			public void editBlock(){ 
				new «blockName+"ControlPanel"»(this);
			}	
				
			public void generateCode(SpinFXBlock sfxb) {
	
			// Iterate through mem and equ statements, allocate accordingly
			«FOR SpinElement e : pr.elements»
				«switch e {
					Offset:{genOffset(e) }
				}»
			«ENDFOR»
			
			sfxb.comment(getName());
			
			SpinCADPin sp = null;
					
			// Iterate through pin definitions and connect or assign as needed
			«FOR Pin p : pr.pins»
			«switch p {
				InputPin: {connect(p)}
			}»
			«ENDFOR»
			
			// finally, generate the instructions
			«FOR SpinElement e : pr.elements»
				«switch e {
					Instruction:{genInstruction(e)}
					Equate:{setEquate(e)}
					Mem:{genMem(e)}
					Macro: { genMacro(e) }
				}»
			«ENDFOR»

			}
			
			// create setters and getter for control panel variables
			«FOR SpinElement e : pr.elements»
				«switch e {
					Equate: { sortSetterGetter(e) }
			}»
			«ENDFOR»
		}	
	'''
	}

def sortSetterGetter(Equate e) { 
	'''
	«IF e.control == "SliderLabel"»
		«genSetterGetter(e)»
	«ENDIF»
	'''
}

// this will generate setters and getters in the CADBlock class	
def genSetterGetter(Equate e) { '''
	public void set«e.ename»(double __param) {
		«e.ename» = __param;	
	}
	
	public double get«e.ename»() {
		return «e.ename»;	
	}
	
	'''			
	}

//-------------------------------------------------------------
	def genAudioInput(Pin p) ''' 
		addInputPin(this, "«p.name»");
	'''
	
	def genAudioOutput(Pin p) '''
		addOutputPin(this, "«p.name»");
	'''

	def genControlInput(Pin p) '''
		addControlInputPin(this, "«p.name»");
	'''
	
	def genControlOutput(Pin p) '''
		addControlOutputPin(this, "«p.name»");
	'''
	
	def connect(Pin p) '''
		sp = this.getPin("«p.name»").getPinConnection();
		int «p.varName» = -1;
		if(sp != null) {
			«p.varName» = sp.getRegister();
		}

	'''
	
	def setOutput(Pin p) '''
		this.getPin("«p.name»").setRegister(«p.varName»);
	'''
	
	// TODO the idea of isPinConnected() is to create conditional sections within codeGenerate() 
	// of any given block.  For example, if the pin is connected, then take the value of the source.
	// Otherwise, assign a default value.  Maybe I can generalize that last part a bit better.
	// This needs an instruction assigned in the grammar, etc.
	// Delete the println part once it's working OK
	
	def genIsPinConnected(IsPinConnected p) {
		'''
		if(this.getPin("«p.arg1»").getPinConnection() != null) {
		'''
	}
	
	def genElse(IsElse e) '''
	} else {
	'''
	
	def genEndif(IsEndif e) '''
	}
	
	'''
// This macro adds code to read a specifically named pin, and scale it 
// but if it is not connected, assign a default value
// which is in the accumulator when we leave

def genGetInputDefault(GetInputDefault g)'''
		if(«g.variable» != -1) {
			System.out.println("Pin is Connected! " + "«g.name»"); 
			sfxb.readRegister(«g.variable», «g.scale»);
		}
		else
		{
			System.out.println("Assigning default value! " + "«g.defaultVal»"); 
			sfxb.scaleOffset(0.0, «g.defaultVal»);
		}
'''

	def genMacro(Macro inst) {
		'''
		«switch inst {  
			IsPinConnected: genIsPinConnected(inst)
			IsElse: genElse(inst)
			IsEndif: genEndif(inst)
			GetInputDefault: genGetInputDefault(inst)
			SetOutputPin: genSetOutputPin(inst)
			GetBaseAddress: genGetBaseAddress(inst)
			GetDelayScaleControl: genGetDelayScaleControl(inst)
			}»	
		'''
	}
	
def genGetDelayScaleControl(GetDelayScaleControl g) {
	'''
		sfxb.clear();
		sfxb.or(32767 * 256);
		«IF g.control != null»
		sfxb.mulx(«g.control»);
		«ENDIF»
		sfxb.scaleOffset((double)(«g.length»/32768.0), (double) («g.buffer»/32768.0));
		sfxb.writeRegister(ADDR_PTR, 0);	
	'''
}	

def genGetBaseAddress(GetBaseAddress g) {
	'''
	int	delayOffset = sfxb.getDelayMemAllocated() + 1;
	'''
}	

def genSetOutputPin(SetOutputPin p) {
	'''
		this.getPin("«p.pinName»").setRegister(«p.varName»);
	'''
}	

// try to figure out a way to distinguish REGx equates from INT or DOUBLE
// this seems to have worked!

	def genEquate(Equate e) '''
		«IF e.getValue.toUpperCase.startsWith("REG",0)»
		private int «e.getEname»;
		«ELSE»
		private double «e.getEname»;
		«ENDIF»
	'''

	def setEquate(Equate e) '''
		«IF e.getValue.toUpperCase.startsWith("REG",0)»
		«e.getEname» = sfxb.allocateReg();
		«ELSE»
		«e.getEname» = «e.getValue»;
		«ENDIF»
	'''

	def genOffset(Offset e) '''
		int «e.getName» = «e.getLength»;
	'''

	def genMem(Mem m) '''
		sfxb.FXallocDelayMem("«m.getBuffer»", «m.getLength»); 
	'''

	def genLabel(Label l) '''
		«l.name» 
	''' 
 
	def genInstruction(Instruction inst) '''
		«switch inst {
			Absa: genAbsa(inst)
			And: genAnd(inst)
			ChorusReadDelay: genChorusReadDelay(inst)
			ChorusReadValue: genChorusReadValue(inst)
			Clr: genClr(inst)
			Exp: genExp(inst)
			Jam: genJam(inst)
			Ldax: genLdax(inst)
			LoadRampLFO: genWldr(inst) 
			LoadSinLFO: genWlds(inst)
			Log: genLog(inst)
			Maxx: genMaxx(inst)
			Mulx: genMulx(inst)
			Not: genNot(inst)
			Or: genOr(inst)			
			ReadDelayPointer: genReadDelayPointer(inst)
			ReadDelay: genReadDelay(inst)
			ReadRegister: genReadRegister(inst)
			ReadRegisterFilter: genReadRegisterFilter(inst)
			ScaleOffset: genScaleOffset(inst)
			Skip: genSkip(inst)
			WriteAllpass: genWriteAllpass(inst)
			WriteDelay: genWriteDelay(inst)
			WriteRegister: genWriteRegister(inst)
			WriteRegisterLowshelf: genWriteRegisterLowshelf(inst)
			WriteRegisterHighshelf: genWriteRegisterHighshelf(inst)
			Xor: genXor(inst)
		}»
	'''

	def genAbsa(Absa inst) '''
	sfxb.absa();
	'''

	def genNot(Not inst) '''
	sfxb.not();
	'''

	def genClr(Clr inst) '''
	sfxb.clear();
	'''

	def genLog(Log inst) '''
	sfxb.log(«inst.getArg1», «inst.getArg2»);
	'''

	def genExp(Exp inst) '''
	sfxb.exp(«inst.getArg1», «inst.getArg2»);
	'''

	def genSkip(Skip inst) {
	'''
	sfxb.skip(«inst.getFlags().toUpperCase()», «UtilSC::getDiff(inst)»);
	'''}

	def genJam(Jam inst) '''
	sfxb.jam(«inst.getArg1»);
	'''

	def genScaleOffset(ScaleOffset inst) '''
	sfxb.scaleOffset(«inst.getArg1», «inst.getArg2»);
	'''

	def genOr(Or inst) '''
	sfxb.or(«inst.getArg1.toJavaBinary»);
	'''

	def genAnd(And inst) '''
	sfxb.and(«inst.getArg1.toJavaBinary»);
	'''

	def genXor(Xor inst) '''
	sfxb.xor(«inst.getArg1.toJavaBinary»);
	'''

	def genWldr(LoadRampLFO inst) '''
	sfxb.loadRampLFO(«inst.getArg1.spinRegs», «inst.getArg2», «inst.getArg3»);
	'''

def genWlds(LoadSinLFO inst) '''
	sfxb.loadSinLFO(«inst.getArg1.spinRegs», «inst.getArg2», «inst.getArg3»);
	'''
// B15_S1_9 instructions - RDA, WRA, WRAP - B15 is SPINMEM data type

def genReadDelay(ReadDelay inst) { 
		genDelayInst(inst, "FXreadDelay");	
	}
	
def genWriteDelay(WriteDelay inst) { 	
		genDelayInst(inst, "FXwriteDelay");	
	}

def genWriteAllpass(WriteAllpass inst) { 
		genDelayInst(inst, "FXwriteAllpass");	
	}

	
def genDelayInst(Inst_B15_S1_9 inst, String className) { 
		
		if(inst.arg1.getBuffer.endsWith("+") || inst.arg1.getBuffer.endsWith("-")) {
	 		if(inst.getArg1.getValue != 0) {'''
			sfxb.«className»("«inst.getArg1.getBuffer»", «inst.getArg1.getValue», «inst.getArg2»);
			'''
			} 
			else {
			'''
			sfxb.«className»("«inst.getArg1.getBuffer»", «inst.getArg1.getOffset.getName», «inst.getArg2»);
			'''
			} 
		}
		else {
			'''
			sfxb.«className»("«inst.getArg1.getBuffer»", 0, «inst.getArg2»);
			'''		
		}
	}

// this is the other instruction that uses the SPINMEM data type
def genChorusReadDelay(ChorusReadDelay inst) ''' 
	sfxb.FXchorusReadDelay(«inst.getArg1.toUpperCase()», «inst.getArg2.toUpperCase()», "«inst.getArg3.getBuffer»", «inst.getArg3.getValue»);
	'''

//=============================================================================
		
	def genReadDelayPointer(ReadDelayPointer inst) '''
	sfxb.readDelayPointer(«inst.getArg1.spinRegs»);
	'''

	def genReadRegisterFilter(ReadRegisterFilter inst) '''
	sfxb.readRegisterFilter(«inst.getArg1», «inst.getArg2»);
	'''
	
def genReadRegister(ReadRegister inst) '''
	sfxb.readRegister(«inst.getArg1.spinRegs», «inst.getArg2»);
	'''
	
def genMaxx(Maxx inst) { '''
	sfxb.maxx(«inst.getArg1.spinRegs», «inst.getArg2»);
	'''
	
	}
	def genWriteRegister(WriteRegister inst) '''
	sfxb.writeRegister(«inst.getArg1.spinRegs», «inst.getArg2»);
	'''
	
	def genWriteRegisterHighshelf(WriteRegisterHighshelf inst) '''
	sfxb.writeRegisterHighshelf(«inst.getArg1», «inst.getArg2»);
	'''
	
	def genWriteRegisterLowshelf(WriteRegisterLowshelf inst) '''
	sfxb.writeRegisterLowshelf(«inst.getArg1», «inst.getArg2»);
	'''
	
	def genMulx(Mulx inst) '''
	sfxb.mulx(«inst.getArg1.spinRegs»);
	'''

	def genLdax(Ldax inst) '''
	sfxb.loadAccumulator(«inst.getArg1»);
	'''
	
	def genChorusReadValue(ChorusReadValue inst) '''
	sfxb.chorusReadValue(«inst.getArg1.spinRegs»);
	'''
	
	def toJavaBinary(String spinBinary) {
		if (spinBinary.startsWith('%')) {
			spinBinary.replace("%", "0b")
		}	
		else if (spinBinary.startsWith('$')) {
			spinBinary.replace("$", "0x")
		}	
		else {
			spinBinary;
		}
}
	
	
	def spinRegs(String reg) { 
		if (reg == "pot0") return "input0";
		if (reg == "pot1") return "input1";
		if (reg == "pot2") return "input2";
		if (reg == "sin0") return "SIN0";
		if (reg == "sin1") return "SIN1";
		if (reg == "rmp0") return "RMP0";
		if (reg == "rmp1") return "RMP1";
		if (reg == "sin0_rate") return "SIN0_RATE";
		if (reg == "sin1_rate") return "SIN1_RATE";
		if (reg == "rmp0_rate") return "RMP0_RATE";
		if (reg == "rmp1_rate") return "RMP1_RATE";
		if (reg == "sin0_range") return "SIN0_RANGE";
		if (reg == "sin1_range") return "SIN1_RANGE";
		if (reg == "cos0") return "COS0";
		if (reg == "cos1") return "COS1";
		if (reg == "neg") return "NEG";
		if (reg == "zrc") return "ZRC";
		if (reg == "run") return "RUN";
		if (reg == "gez") return "GEZ";
		if (reg == "addr_ptr") return "ADDR_PTR";
		return reg;
	}
}
