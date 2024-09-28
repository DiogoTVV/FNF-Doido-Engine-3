package;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID as FlxPad;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput.FlxInputState;
import data.MobileUtil;

using haxe.EnumTools;

enum DoidoKey
{
	// gameplay
	LEFT;
	DOWN;
	UP;
	RIGHT;
	RESET;
	// ui stuff
	UI_LEFT;
	UI_DOWN;
	UI_UP;
	UI_RIGHT;
	ACCEPT;
	BACK;
	PAUSE;

	NONE;
}

class Controls
{
	public static function justPressed(bind:DoidoKey):Bool
	{
		return checkBind(bind, JUST_PRESSED);
	}

	public static function pressed(bind:DoidoKey):Bool
	{
		return checkBind(bind, PRESSED);
	}

	public static function released(bind:DoidoKey):Bool
	{
		return checkBind(bind, JUST_RELEASED);
	}

	public static function checkBind(rawBind:DoidoKey, inputState:FlxInputState):Bool
	{
		var bind = bindToString(rawBind);
		if(!allControls.exists(bind))
		{
			trace("that bind does not exist dummy");
			return false;
		}

		for(i in 0...allControls.get(bind)[0].length)
		{
			var key:FlxKey = allControls.get(bind)[0][i];
			if(FlxG.keys.checkStatus(key, inputState)
			&& key != FlxKey.NONE)
				return true;
		}

		// gamepads
		if(FlxG.gamepads.lastActive != null)
		for(i in 0...allControls.get(bind)[1].length)
		{
			var key:FlxPad = allControls.get(bind)[1][i];
			if(FlxG.gamepads.lastActive.checkStatus(key, inputState)
			&& key != FlxPad.NONE)
				return true;
		}

		// mobile
		switch (bind) {
			case "UI_LEFT":
				return SwipeUtil.swipeLeft;
			case "UI_DOWN":
				return SwipeUtil.swipeDown;
			case "UI_UP":
				return SwipeUtil.swipeUp;
			case "UI_RIGHT":
				return SwipeUtil.swipeRight;
			case "ACCEPT":
				return TouchUtil.justReleased && !SwipeUtil.swipeLeft && !SwipeUtil.swipeRight;
			//case "BACK" | "PAUSE":
			//	return Main.activeState.virtualPad.justPressed(BACK);
		}

		return false;
	}

	inline public static function bindToString(bind:DoidoKey):String
	{
		var constructors = DoidoKey.getConstructors();
		return constructors[constructors.indexOf(Std.string(bind))];
	}

	//THIS IS A TEMP FIX!!!! CHANGE LATER!!!!
	inline public static function stringToBind(bind:String):DoidoKey
	{
		#if linux
		switch(bind) {
			case "LEFT":
				return LEFT;
			case "DOWN":
				return DOWN;
			case "UP":
				return UP;
			case "RIGHT":
				return RIGHT;
			case "RESET":
				return RESET;
			case "UI_LEFT":
				return UI_LEFT;
			case "UI_DOWN":
				return UI_DOWN;
			case "UI_UP":
				return UI_UP;
			case "UI_RIGHT":
				return UI_RIGHT;
			case "ACCEPT":
				return ACCEPT;
			case "BACK":
				return BACK;
			case "PAUSE":
				return PAUSE;
			default:
				return NONE;
		}
		#else
		return cast DoidoKey.getConstructors().indexOf(Std.string(bind));
		#end
	}
	
	public static function setSoundKeys(?empty:Bool = false)
	{
		if(empty)
		{
			FlxG.sound.muteKeys 		= [];
			FlxG.sound.volumeDownKeys 	= [];
			FlxG.sound.volumeUpKeys 	= [];
		}
		else
		{
			FlxG.sound.muteKeys 		= [ZERO,  NUMPADZERO];
			FlxG.sound.volumeDownKeys 	= [MINUS, NUMPADMINUS];
			FlxG.sound.volumeUpKeys 	= [PLUS,  NUMPADPLUS];
		}
	}
	
	// self explanatory (i think)
	public static final changeableControls:Array<String> = [
		'LEFT', 'DOWN', 'UP', 'RIGHT',
		'RESET',
	];
	
	/*
	** [0]: keyboard
	** [1]: gamepad
	*/
	public static var allControls:Map<String, Array<Dynamic>> = [
		// gameplay controls
		'LEFT' => [
			[FlxKey.A, FlxKey.LEFT],
			[FlxPad.LEFT_TRIGGER, FlxPad.DPAD_LEFT],
		],
		'DOWN' => [
			[FlxKey.S, FlxKey.DOWN],
			[FlxPad.LEFT_SHOULDER, FlxPad.DPAD_DOWN],
		],
		'UP' => [
			[FlxKey.W, FlxKey.UP],
			[FlxPad.RIGHT_SHOULDER, FlxPad.DPAD_UP],
		],
		'RIGHT' => [
			[FlxKey.D, FlxKey.RIGHT],
			[FlxPad.RIGHT_TRIGGER, FlxPad.DPAD_RIGHT],
		],
		'RESET' => [
			[FlxKey.R, FlxKey.NONE],
			[FlxPad.BACK, FlxPad.NONE],
		],

		// ui controls
		'UI_LEFT' => [
			[FlxKey.A, FlxKey.LEFT],
			[FlxPad.LEFT_STICK_DIGITAL_LEFT, FlxPad.DPAD_LEFT],
		],
		'UI_DOWN' => [
			[FlxKey.S, FlxKey.DOWN],
			[FlxPad.LEFT_STICK_DIGITAL_DOWN, FlxPad.DPAD_DOWN],
		],
		'UI_UP' => [
			[FlxKey.W, FlxKey.UP],
			[FlxPad.LEFT_STICK_DIGITAL_UP, FlxPad.DPAD_UP],
		],
		'UI_RIGHT' => [
			[FlxKey.D, FlxKey.RIGHT],
			[FlxPad.LEFT_STICK_DIGITAL_RIGHT, FlxPad.DPAD_RIGHT],
		],

		// ui buttons
		'ACCEPT' => [
			[FlxKey.SPACE, FlxKey.ENTER],
			[FlxPad.A, FlxPad.X, FlxPad.START],
		],
		'BACK' => [
			[FlxKey.BACKSPACE, FlxKey.ESCAPE],
			[FlxPad.B],
		],
		'PAUSE' => [
			[FlxKey.ENTER, FlxKey.ESCAPE],
			[FlxPad.START],
		],
	];

	public static function load()
	{
		if(SaveData.saveControls.data.allControls == null
		|| Lambda.count(allControls) != Lambda.count(SaveData.saveControls.data.allControls))
		{
			SaveData.saveControls.data.allControls = allControls;
		}
		
		// allControls = SaveData.saveControls.data.allControls;
		var impControls:Map<String, Array<Dynamic>> = SaveData.saveControls.data.allControls;
		for(label => key in impControls)
		{
			if(changeableControls.contains(label))
				allControls.set(label, key);
		}

		save();
	}

	public static function save()
	{
		SaveData.saveControls.data.allControls = allControls;
		SaveData.save();
	}
}