package engine.states;

import engine.music.Song;
import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxAssets.FlxSoundAsset;

class MusicalState extends FlxState {
	private final _songAsset:FlxSoundAsset;
	public var song:Song;

	public function new(songAsset:FlxSoundAsset)
	{
		super();

		if (songAsset == null)
		{
			FlxG.log.error('Expected song asset, got null');
		}
		
		_songAsset = songAsset;
	}

	override public function create():Void
	{
		super.create();

		song = new Song({
			instrumentalAsset: _songAsset,
			bpm: 120,
			timeSignature: new TimeSignature(4, 4)
		});
		
		song.instrumental.looped = true;
		add(song);

		song.onBeat.add(beatHit);
		song.onQuarter.add(quarterHit);
		song.onStep.add(stepHit);

		song.play();
	}

	public function beatHit(beat:Int):Void {}
	public function quarterHit(quarter:Int):Void {}
	public function stepHit(step:Int):Void {}
}