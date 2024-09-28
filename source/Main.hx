package;

import data.*;
import data.GameData;
import flixel.FlxG;
import flixel.FlxState;
import openfl.display.Sprite;
import data.FPSCounter;
import flixel.input.keyboard.FlxKey;

#if !html5
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Main extends Sprite
{
	public static var fpsCount:FPSCounter;

	public static final savePath:String = "DiogoTV/DoidoEngine";

	public static var instance:Main;
	@:unreflective
	var game:DoidoGame;

	public function new()
	{
		super();
		instance = this;

		addChild(game = new DoidoGame(0, 0, Init, 120, 120, true));

		#if desktop
		fpsCount = new FPSCounter(10, 3);
		addChild(fpsCount);
		#end

		// shader coords fix
		FlxG.signals.focusGained.add(function() {
			resetCamCache();
		});
		FlxG.signals.gameResized.add(function(w, h) {
			resetCamCache();
		});
		// Prevent flixel from listening to key inputs when switching fullscreen mode
		// thanks @nebulazorua, @crowplexus, @diogotvv
		FlxG.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, (e) ->
		{
			if (e.keyCode == FlxKey.ENTER && e.altKey)
				e.stopImmediatePropagation();
		}, false, 100);
	}
	
	function resetCamCache()
	{
		if(FlxG.cameras != null) {
			for(cam in FlxG.cameras.list) {
				if(cam != null && cam.filters != null)
					resetSpriteCache(cam.flashSprite);
			}
		}
		if(FlxG.game != null)
			resetSpriteCache(FlxG.game);
	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
			sprite.__cacheBitmap 	 = null;
			sprite.__cacheBitmapData = null;
		}
	}
	
	public static var activeState:FlxState;
	public static var gFont:String = Paths.font("vcr.ttf");
	
	public static var skipClearMemory:Bool = false; // dont
	public static var skipTrans:Bool = true; // starts on but it turns false inside Init
	public static function switchState(?target:FlxState):Void
	{
		var trans = new GameTransition(false);
		trans.finishCallback = function()
		{
			if(target != null)		
				FlxG.switchState(target);
			else
				FlxG.resetState();
		};

		if(skipTrans)
			return trans.finishCallback();
		
		//FlxG.state.openSubState(trans);
		if(activeState != null)
			activeState.openSubState(trans);
	}
	
	// you could just do Main.switchState() but whatever
	public static function resetState():Void
		return switchState();

	// so you dont have to type it every time
	public static function skipStuff(?ohreally:Bool = true):Void
	{
		skipClearMemory = ohreally;
		skipTrans = ohreally;
	}

	public static function changeFramerate(rawFps:Float = 120)
	{
		var newFps:Int = Math.floor(rawFps);

		if(newFps > FlxG.updateFramerate)
		{
			FlxG.updateFramerate = newFps;
			FlxG.drawFramerate   = newFps;
		}
		else
		{
			FlxG.drawFramerate   = newFps;
			FlxG.updateFramerate = newFps;
		}
	}
}
