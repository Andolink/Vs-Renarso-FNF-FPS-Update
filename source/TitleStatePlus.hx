package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
//import polymod.Polymod;

using StringTools;

class TitleStatePlus extends MusicBeatState
{
	static var initialized:Bool = true;
	static public var soundExt:String = ".ogg";

	override public function create():Void
	{
		//Polymod.init({modRoot: "mods", dirs: ['introMod']});

		// DEBUG BULLSHIT

		super.create();
		FlxG.mouse.visible = false;

		FlxG.save.bind('data');

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		KeyBinds.keyCheck();
		PlayerSettings.init();

		Main.fpsDisplay.visible = true;

		startIntro();
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var dance:Bool = false;
	var titleText:FlxSprite;
	var CreditText:FlxText;

	function startIntro()
	{
		Conductor.changeBPM(158);
		persistentUpdate = true;

		logoBl = new FlxSprite(-50, -100);
		logoBl.frames = FlxAtlasFrames.fromSparrow('assets/images/logoBumpin.png', 'assets/images/logoBumpin.xml');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();

		var bgGrad:FlxSprite = new FlxSprite().loadGraphic('assets/images/titleBG.png');
		bgGrad.antialiasing = true;
		bgGrad.updateHitbox();

		gfDance = new FlxSprite(FlxG.width * 0.45+100, -200);
		gfDance.frames = FlxAtlasFrames.fromSparrow('assets/images/gfDanceTitle.png', 'assets/images/gfDanceTitle.xml');
		gfDance.animation.addByPrefix('danceLeft', 'Idle DanceL', 18, false);
		gfDance.animation.addByPrefix('danceRight', 'Idle DanceR', 18, false);
		gfDance.antialiasing = true;
		add(bgGrad);
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = FlxAtlasFrames.fromSparrow('assets/images/titleEnter.png', 'assets/images/titleEnter.xml');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		CreditText = new FlxText(FlxG.width * 0.45+300, FlxG.height - 50, 0, "Mod by Andolink & SeiferSJ", 12);
		CreditText.scrollFactor.set();
		CreditText.setFormat("VCR OSD Mono", 22, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(CreditText);

		skipIntro();
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if(initialized){
			Conductor.songPosition = FlxG.sound.music.time;
			// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

			if (FlxG.keys.justPressed.F)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}

			var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.START)
					pressedEnter = true;

				#if switch
				if (gamepad.justPressed.B)
					pressedEnter = true;
				#end
			}

			if (pressedEnter && !transitioning && skippedIntro)
			{
				titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt, 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					// Check if version is outdated
					FlxG.switchState(new MainMenuState());
				});
				// FlxG.sound.play('assets/music/titleShoot' + TitleState.soundExt, 0.7);
			}
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight', true);
		else
			gfDance.animation.play('danceLeft', true);

		FlxG.log.add(curBeat);
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);
			PlayerSettings.player1.controls.loadKeyBinds();
			Config.configCheck();
			skippedIntro = true;
		}
	}
}
