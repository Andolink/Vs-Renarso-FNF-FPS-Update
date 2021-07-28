package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;

class MenuItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;

	public function new(x:Float, y:Float, weekNum:Int = 0)
	{
		super(x, y);

		var tex = FlxAtlasFrames.fromSparrow('assets/images/campaign_menu_UI_assets.png', 'assets/images/campaign_menu_UI_assets.xml');

		week = new FlxSprite();
			week.frames = tex;
		
		// TUTORIAL IS WEEK 0
		week.animation.addByPrefix('week0', 'tutorial selected', 24);
		week.animation.addByPrefix('week1', "week 7", 24);
		week.animation.addByPrefix('week2', "week 7", 24);
		week.animation.addByPrefix('week3', "week 7", 24);
		week.animation.addByPrefix('week4', "week 7", 24);
		week.animation.addByPrefix('week5', "week 7", 24);
		week.animation.addByPrefix('week6', "week 7", 24);
		week.animation.addByPrefix('week7', 'week 7', 24);
		add(week);

		week.animation.play('week' + (weekNum));
		week.animation.pause();
		week.updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17);
	}
}
