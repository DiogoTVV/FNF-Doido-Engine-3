package gameObjects.android;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.ui.FlxButton;

enum VAction
{
	BACK; //BACK BUTTON FOR MENUS
	PAUSE; //PAUSE BUTTON FOR PLAYSTATE
	SKIP; //SKIP BUTTON FOR DIALOG
	BLANK; //NO BUTTONS
}

enum VButton
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
	A;
	B;
	C;
	D;
	BACK;
}

/**
 * Virtual Gamepad
 *
 * @author Ka Wing Chin
 * @author teles
 */
class VPad extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonA:FlxButton = new FlxButton(0, 0);
	public var buttonB:FlxButton = new FlxButton(0, 0);
	public var buttonC:FlxButton = new FlxButton(0, 0);
	public var buttonD:FlxButton = new FlxButton(0, 0);
	public var buttonBack:FlxButton = new FlxButton(0, 0);

	var padActive:Bool = false;

	public function new(Mode:VAction = BLANK):Void
	{
		super();

		switch (Mode)
		{
			case PAUSE:
				add(buttonBack = createButton(FlxG.width - 105, 0, 'util/pause', 0.3, 0.8));
			case SKIP:
				add(buttonBack = createButton(FlxG.width - 105, 0, 'util/skip', 0.5, 0.8));
			case BACK:
				add(buttonBack = createButton(FlxG.width - 105, 0, 'util/back', 0.5, 0.8));


			/* -- REFERENCE POSITIONS FOR FACE BUTTONS
			case WATTS:
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a'));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b'));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c'));
				add(buttonD = createButton(FlxG.width - 258, FlxG.height - 255, 'd'));
				add(buttonBack = createButton(FlxG.width - 105, 0, 'back', 0.5, 0.8));
			*/

			case BLANK: // do nothing
		}

		scrollFactor.set();
	}

	/**
	 * Clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = FlxDestroyUtil.destroy(buttonLeft);
		buttonUp = FlxDestroyUtil.destroy(buttonUp);
		buttonDown = FlxDestroyUtil.destroy(buttonDown);
		buttonRight = FlxDestroyUtil.destroy(buttonRight);
		buttonA = FlxDestroyUtil.destroy(buttonA);
		buttonB = FlxDestroyUtil.destroy(buttonB);
		buttonC = FlxDestroyUtil.destroy(buttonC);
		buttonD = FlxDestroyUtil.destroy(buttonD);
		buttonBack = FlxDestroyUtil.destroy(buttonBack);
	}

	private function createButton(X:Float, Y:Float, Graphic:String, alpha:Float = 0.5, scale:Float = 1):FlxButton
	{
		var graphic:FlxGraphic;

		if (Paths.fileExists('images/android/buttons/${Graphic}.png'))
			graphic = FlxG.bitmap.add('assets/images/android/buttons/${Graphic}.png');
		else
			graphic = FlxG.bitmap.add('assets/images/android/buttons/default.png');

		var button:FlxButton = new FlxButton();
		button.frames = FlxTileFrames.fromGraphic(graphic, FlxPoint.get(Std.int(graphic.width), graphic.height));
		button.solid = false;
		button.immovable = true;
		button.scale.set(scale, scale);
		button.updateHitbox();
		button.scrollFactor.set();
		button.x = X;
		button.y = Y;
		button.alpha = alpha;
		return button;
	}

	public function justPressed(Button:VButton):Bool {
		var buttonState:Null<Bool> = false;
		switch (Button)
		{
			case UP:
				buttonState = buttonUp.justPressed;
			case DOWN:
				buttonState = buttonDown.justPressed;
			case LEFT:
				buttonState = buttonLeft.justPressed;
			case RIGHT:
				buttonState = buttonRight.justPressed;
			case A:
				buttonState = buttonA.justPressed;
			case B:
				buttonState = buttonB.justPressed;
			case C:
				buttonState = buttonC.justPressed;
			case D:
				buttonState = buttonD.justPressed;
			case BACK:
				buttonState = buttonBack.justPressed;
		}

		if(buttonState == null)
			buttonState = false;
		return buttonState;
	}
}