/*
 * generated by Xtext
 */
package com.holycityaudio.spincadmenu.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import com.holycityaudio.spincadmenu.spinCADMenu.Menu
import com.holycityaudio.spincadmenu.spinCADMenu.MENU_ITEM
import com.holycityaudio.spincadmenu.spinCADMenu.MENU_HEADER
import com.holycityaudio.spincadmenu.spinCADMenu.Element
import com.holycityaudio.spincadmenu.spinCADMenu.TEST_ITEM
// import com.holycityaudio.spincad.generator.SpinCADTestGenerator

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class SpinCADMenuGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		// generate menu
		// on Windows change these forward slashes to double back slashes
		var pkage = "/com/holycityaudio/SpinCAD/"
		fsa.generateFile(pkage + resource.className+"Menu"+".java", toMenuCode(resource.contents.head as Menu))
		// TODO generate test cases for non-generated CAD Blocks
		}
		
		def className(Resource res) {
			var name = res.getURI.lastSegment
			println(name)
			return name.substring(0, name.indexOf('.'))
		}
	
	
	def toTestCases(Menu mn, Resource resource, IFileSystemAccess fsa) {
	'''
		«FOR Element m : mn.elements»
			«switch m {
				TEST_ITEM:{genTestItem(m, resource, fsa)}
			}»
		«ENDFOR»
	'''		
	}
	
def genTestItem(TEST_ITEM m, Resource resource, IFileSystemAccess fsa) { 
		var pkage = "\\com\\holycityaudio\\SpinCAD\\test\\"
//		fsa.generateFile(pkage + m.className+"Test.java", new SpinCADTestGenerator.genTestHeader(m.className))
}	

def toTestCode(Menu mn) {
'''
/* SpinCAD Designer - DSP Development Tool for the Spin FV-1
 * Copyright (C) 2013 - 2014 - Gary Worsham
 * Based on ElmGen by Andrew Kilpatrick.  Modified by Gary Worsham 2013 - 2014.  Look for GSW in code.
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

// this is a bunch of units tests for the blocks
// could stand improvement

package com.holycityaudio.SpinCAD.test;

import javax.swing.SwingUtilities;

import com.holycityaudio.SpinCAD.SpinCADFrame;

import org.andrewkilpatrick.elmGen.ElmProgram;
import org.andrewkilpatrick.elmGen.simulator.SimulatorState;
import org.andrewkilpatrick.elmGen.simulator.SinLFO;

public class SpinCADTest {

	public SpinCADTest() {
	}
	
	// ------------------------------------------------------------
	/**
	 * Launch the application.
	 */
	
	public static void main(String[] args) {
		
		
		final ElmProgram p = new ElmProgram("Test");
		
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				try { 
					
					SpinCADFrame dspFrame = new SpinCADFrame();
					dspFrame.setVisible(true);
					
					// these were generated by GenTestCases() - old Java written CADBlocks
/*					new BitCrusherTest(dspFrame);
					new SingleDelayTest(dspFrame);
					new MultiTapTest(dspFrame);
					new HPF2PTest(dspFrame);
					new OneBandEQTest(dspFrame);
					new SixBandEQTest(dspFrame);
					new BiQuadTest(dspFrame);
					new ChorusTest(dspFrame);
					new ChorusPresetTest(dspFrame);
					new DelayTest(dspFrame);
					new LPF4PTest(dspFrame);
//					new CubeGainTest(dspFrame);
*/					
					// these are auto-generated from spincad source files
					new very_tight_plate_verbTest(dspFrame);	
//					new InstructionTestTest(dspFrame);
//					new dance_ir_fla_lTest(dspFrame);
					new ToverXTest(dspFrame);
					new OctaveTest(dspFrame);
					new distTest(dspFrame);	
					new ga_demo_chorusTest(dspFrame);
					new ga_demo_echoTest(dspFrame);
					new ga_demo_flangerTest(dspFrame);
					new crossfadeTest(dspFrame);
					new control_smootherTest(dspFrame);
					new ga_demo_flangerTest(dspFrame);
					new MN3011aTest(dspFrame);
					new ga_demo_phaserTest(dspFrame);
					new ga_demo_vibratoTest(dspFrame);
					new ga_demo_wahTest(dspFrame);
					new rms_lim_expTest(dspFrame);
					new rms_limiterTest(dspFrame);
					new slow_gearTest(dspFrame);
					new gated_verbTest(dspFrame);
					new rom_rev1Test(dspFrame);
					new shimmer_verbTest(dspFrame);
					new act_xoverTest(dspFrame); 	
					new soft_knee_limiterTest(dspFrame);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});

	}
'''
}

def toMenuCode(Menu mn) {
		var menuNameY = "testing"
		'''
			package com.holycityaudio.SpinCAD;
			import com.holycityaudio.SpinCAD.SpinCADBlock;
			«FOR Element m : mn.elements»
				«switch m {
					MENU_ITEM:{importMenuItem(m)}
				}»
			«ENDFOR»

			import java.awt.event.ActionEvent;
			import java.awt.event.ActionListener;
		
			import javax.swing.JMenu;
			import javax.swing.JMenuBar;
			import javax.swing.JMenuItem;
		
			public class «mn.eResource.className+"Menu"» {

		//	private static final long serialVersionUID = 1L;

			public «mn.eResource.className+"Menu"»(final SpinCADFrame f, final SpinCADPanel panel, JMenuBar menuBar) {
		
			«FOR Element m : mn.elements»
				«switch m {
					MENU_HEADER:{menuNameY = getMenuName(m.name); genMenu(m)}
					MENU_ITEM:{genMenuItem(m, menuNameY)}
				}»
			«ENDFOR»
			}
		}
		'''
		}

	def String genMenu(MENU_HEADER m) {
		var menuNameX = getMenuName(m.name)
		'''
		JMenu «menuNameX» = new JMenu("«m.name»");
		menuBar.add(«menuNameX»);
		
	''' 
		}
				
	def genMenuItem(MENU_ITEM m, String menuName) '''	
		final JMenuItem mntm_«m.className» = new JMenuItem("«m.name»");
		mntm_«m.className».addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				SpinCADBlock pcB = new «m.className»CADBlock(50, 100);
				f.dropBlock(panel, pcB);
			}
		});
		«menuName».add(mntm_«m.className»);
			
'''

	def importMenuItem(MENU_ITEM m) '''		
		import com.holycityaudio.SpinCAD.CADBlocks.«m.className»CADBlock;
'''

	def getMenuName(String header) {
		var menuName = header.replaceAll("\\s+","")
		menuName = menuName.replaceAll("\\/","") 
		menuName = menuName.replaceAll("-","_") 
		"mn_" + menuName.toLowerCase()
	}
}